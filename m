Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A790615999
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiKBDPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiKBDOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:14:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4689523EA3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE1E4B82062
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC34CC433D6;
        Wed,  2 Nov 2022 03:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358835;
        bh=KqKkcehuAyvVrhgWWxSqZ77BPf+d4EtEhWd7f9hxvrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oeMsYOBzVToPU2dPNlk8fl4+TQmq3KIsPYFj7qOzWF8rEw4yO5rbp2/sbOqOmQep0
         hoy0vcT5NVV8VLiYjmAtyMt44Ti2E3LSpqdBO7IN5zpjtuxNja+gO54WXpOq4fO/d/
         H6nwP6PgnjVLw91Cbl2sRfEtegVG+PXTAmahHL3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        Demi Marie Obenour <demi@invisiblethingslab.com>
Subject: [PATCH 5.10 32/91] Xen/gntdev: dont ignore kernel unmapping error
Date:   Wed,  2 Nov 2022 03:33:15 +0100
Message-Id: <20221102022055.953484410@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit f28347cc66395e96712f5c2db0a302ee75bafce6 upstream.

While working on XSA-361 and its follow-ups, I failed to spot another
place where the kernel mapping part of an operation was not treated the
same as the user space part. Detect and propagate errors and add a 2nd
pr_debug().

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/c2513395-74dc-aea3-9192-fd265aa44e35@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Co-authored-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -395,6 +395,14 @@ static void __unmap_grant_pages_done(int
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = -1;
+		if (use_ptemod) {
+			WARN_ON(map->kunmap_ops[offset+i].status &&
+				map->kunmap_ops[offset+i].handle != -1);
+			pr_debug("kunmap handle=%u st=%d\n",
+				 map->kunmap_ops[offset+i].handle,
+				 map->kunmap_ops[offset+i].status);
+			map->kunmap_ops[offset+i].handle = -1;
+		}
 	}
 	/*
 	 * Decrease the live-grant counter.  This must happen after the loop to


