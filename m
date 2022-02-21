Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536E44BE07B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346750AbiBUJAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:00:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346949AbiBUI7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:59:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93FA26564;
        Mon, 21 Feb 2022 00:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E653B80EB0;
        Mon, 21 Feb 2022 08:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CA8C340E9;
        Mon, 21 Feb 2022 08:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433675;
        bh=2q4UXnd3Xm4j8S6LXhTHHIr/l1gojctX/Mcti5T1R18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfC59+tWq+6MwLs1KbR8TFRyjyggGe1oCXswzr0x2subU1Sot2Esj8E7fYi5V3k7S
         uNR8wcWgkj/VkMef+SiMbNi9cbh0GGJv2eUophY4JZn50+cKIlOsC/Dg9WVH4087P8
         g0hqucPS0HAVzVj3la7g+tHgLsG2VMWIsy/feidk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eliav Farber <farbere@amazon.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.14 33/45] EDAC: Fix calculation of returned address and next offset in edac_align_ptr()
Date:   Mon, 21 Feb 2022 09:49:24 +0100
Message-Id: <20220221084911.517804904@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084910.454824160@linuxfoundation.org>
References: <20220221084910.454824160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eliav Farber <farbere@amazon.com>

commit f8efca92ae509c25e0a4bd5d0a86decea4f0c41e upstream.

Do alignment logic properly and use the "ptr" local variable for
calculating the remainder of the alignment.

This became an issue because struct edac_mc_layer has a size that is not
zero modulo eight, and the next offset that was prepared for the private
data was unaligned, causing an alignment exception.

The patch in Fixes: which broke this actually wanted to "what we
actually care about is the alignment of the actual pointer that's about
to be returned." But it didn't check that alignment.

Use the correct variable "ptr" for that.

  [ bp: Massage commit message. ]

Fixes: 8447c4d15e35 ("edac: Do alignment logic properly in edac_align_ptr()")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220113100622.12783-2-farbere@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/edac_mc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -264,7 +264,7 @@ void *edac_align_ptr(void **p, unsigned
 	else
 		return (char *)ptr;
 
-	r = (unsigned long)p % align;
+	r = (unsigned long)ptr % align;
 
 	if (r == 0)
 		return (char *)ptr;


