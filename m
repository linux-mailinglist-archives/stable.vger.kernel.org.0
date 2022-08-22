Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0987A59BD5D
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbiHVKJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiHVKJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:09:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55D2DE9A
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:09:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67A68B81011
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 10:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD69EC433C1;
        Mon, 22 Aug 2022 10:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661162938;
        bh=Er+bgM+ONmAteEt37gHf9aVa+qhweNrgdfFtY49tOAg=;
        h=Subject:To:Cc:From:Date:From;
        b=oqH4wDo6872uN/76RWnRvuRGy7gCe8Y0pXQdGfGid8HMu0OlnEz2epXmS4O5ReZuo
         h5FUsfAP0IKkRpPgLVqtM+mHnXQXOytULS593j++FQXLIJawwraNxLq0G2SYL1WuSC
         o0R5+VQ2hU9yIo+P1wrzUCxFBjPOdIQ1OXPl9AKg=
Subject: FAILED: patch "[PATCH] fs/ntfs3: Make ntfs_fallocate return -ENOSPC instead of" failed to apply to 5.19-stable tree
To:     almaz.alexandrovich@paragon-software.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 12:08:47 +0200
Message-ID: <16611629270176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b3e048720dee5641c522015d3f0ff0f0dc9cdc37 Mon Sep 17 00:00:00 2001
From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Date: Fri, 13 May 2022 19:21:54 +0300
Subject: [PATCH] fs/ntfs3: Make ntfs_fallocate return -ENOSPC instead of
 -EFBIG

In some cases we need to return ENOSPC
Fixes xfstest generic/213
Fixes: 114346978cf6 ("fs/ntfs3: Check new size for limits")

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index cf16bde810cc..b5f8837f4145 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -671,6 +671,19 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 		ni_unlock(ni);
 	} else {
 		/* Check new size. */
+
+		/* generic/213: expected -ENOSPC instead of -EFBIG. */
+		if (!is_supported_holes) {
+			loff_t to_alloc = new_size - inode_get_bytes(inode);
+
+			if (to_alloc > 0 &&
+			    (to_alloc >> sbi->cluster_bits) >
+				    wnd_zeroes(&sbi->used.bitmap)) {
+				err = -ENOSPC;
+				goto out;
+			}
+		}
+
 		err = inode_newsize_ok(inode, new_size);
 		if (err)
 			goto out;

