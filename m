Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4317D582AD4
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbiG0QYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbiG0QX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:23:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CB84D829;
        Wed, 27 Jul 2022 09:23:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2A14B821B9;
        Wed, 27 Jul 2022 16:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DAEC4314F;
        Wed, 27 Jul 2022 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658938980;
        bh=KEIaJi8lrA6F8TQthN9Avi7j7nLeBSA+Btq6vmsi3Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KupRJ0hetaBe/v7L5x1t6mlrjRA4rz4PWWIu0fUjdND6/kGvFNdI1HtgHyQ28TA7r
         lw133vzEdK4oh5Qbo7pBuJfQONkRWAy/EUjlAC+4AISsz+4/Mzkjt75t4VDqKkIpPp
         vcFSq+Qn8Z81S+sWBBCVBZ3wDs7r4pRXEzW4M77Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Subject: [PATCH 4.14 01/37] xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE
Date:   Wed, 27 Jul 2022 18:10:27 +0200
Message-Id: <20220727161000.891042002@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Demi Marie Obenour <demi@invisiblethingslab.com>

commit 166d3863231667c4f64dee72b77d1102cdfad11f upstream.

The error paths of gntdev_mmap() can call unmap_grant_pages() even
though not all of the pages have been successfully mapped.  This will
trigger the WARN_ON()s in __unmap_grant_pages_done().  The number of
warnings can be very large; I have observed thousands of lines of
warnings in the systemd journal.

Avoid this problem by only warning on unmapping failure if the handle
being unmapped is not INVALID_GRANT_HANDLE.  The handle field of any
page that was not successfully mapped will be INVALID_GRANT_HANDLE, so
this catches all cases where unmapping can legitimately fail.

Fixes: dbe97cff7dd9 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
Cc: stable@vger.kernel.org
Suggested-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220710230522.1563-1-demi@invisiblethingslab.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -393,7 +393,8 @@ static void __unmap_grant_pages_done(int
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset+i].status &&
+			map->unmap_ops[offset+i].handle != -1);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);


