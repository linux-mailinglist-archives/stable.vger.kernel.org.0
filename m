Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8F95B241C
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 19:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiIHRAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 13:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIHRAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 13:00:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D923C4831
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 10:00:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10D0561D89
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 17:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F0DC433C1;
        Thu,  8 Sep 2022 17:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662656438;
        bh=HUuOYKO5s4a43mOIo4q2p2VYyZvG0qHqhriT+q/0N6Y=;
        h=Subject:To:Cc:From:Date:From;
        b=CED4eLz94wF6t1A3aWr2NJkNwAOdESNE6l7nHf0is0I+ymM0jczNTNpkSp0oDa9qG
         gRZXRZ5umQ9TS4oKdvXmX5DBe0OgVj+qh78MXvIW/FTrZZeDUKgu88dzGeJxaFR+A7
         e2yOZH4v2XytJfLmWEz9501/SxH5YgkC9kKnp4Qc=
Subject: FAILED: patch "[PATCH] efi: capsule-loader: Fix use-after-free in efi_capsule_write" failed to apply to 4.9-stable tree
To:     imv4bel@gmail.com, ardb@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 08 Sep 2022 19:00:59 +0200
Message-ID: <166265645917687@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

9cb636b5f6a8 ("efi: capsule-loader: Fix use-after-free in efi_capsule_write")
5dce14b9d1a2 ("efi/capsule: Clean up pr_err/_info() messages")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9cb636b5f6a8cc6d1b50809ec8f8d33ae0c84c95 Mon Sep 17 00:00:00 2001
From: Hyunwoo Kim <imv4bel@gmail.com>
Date: Wed, 7 Sep 2022 09:07:14 -0700
Subject: [PATCH] efi: capsule-loader: Fix use-after-free in efi_capsule_write

A race condition may occur if the user calls close() on another thread
during a write() operation on the device node of the efi capsule.

This is a race condition that occurs between the efi_capsule_write() and
efi_capsule_flush() functions of efi_capsule_fops, which ultimately
results in UAF.

So, the page freeing process is modified to be done in
efi_capsule_release() instead of efi_capsule_flush().

Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/all/20220907102920.GA88602@ubuntu/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 4dde8edd53b6..3e8d4b51a814 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -242,29 +242,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	return ret;
 }
 
-/**
- * efi_capsule_flush - called by file close or file flush
- * @file: file pointer
- * @id: not used
- *
- *	If a capsule is being partially uploaded then calling this function
- *	will be treated as upload termination and will free those completed
- *	buffer pages and -ECANCELED will be returned.
- **/
-static int efi_capsule_flush(struct file *file, fl_owner_t id)
-{
-	int ret = 0;
-	struct capsule_info *cap_info = file->private_data;
-
-	if (cap_info->index > 0) {
-		pr_err("capsule upload not complete\n");
-		efi_free_all_buff_pages(cap_info);
-		ret = -ECANCELED;
-	}
-
-	return ret;
-}
-
 /**
  * efi_capsule_release - called by file close
  * @inode: not used
@@ -277,6 +254,13 @@ static int efi_capsule_release(struct inode *inode, struct file *file)
 {
 	struct capsule_info *cap_info = file->private_data;
 
+	if (cap_info->index > 0 &&
+	    (cap_info->header.headersize == 0 ||
+	     cap_info->count < cap_info->total_size)) {
+		pr_err("capsule upload not complete\n");
+		efi_free_all_buff_pages(cap_info);
+	}
+
 	kfree(cap_info->pages);
 	kfree(cap_info->phys);
 	kfree(file->private_data);
@@ -324,7 +308,6 @@ static const struct file_operations efi_capsule_fops = {
 	.owner = THIS_MODULE,
 	.open = efi_capsule_open,
 	.write = efi_capsule_write,
-	.flush = efi_capsule_flush,
 	.release = efi_capsule_release,
 	.llseek = no_llseek,
 };

