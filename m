Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0E35B7076
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiIMO1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiIMO0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:26:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8670A61D91;
        Tue, 13 Sep 2022 07:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4D26B80EFC;
        Tue, 13 Sep 2022 14:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DEEC433D6;
        Tue, 13 Sep 2022 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078600;
        bh=U0lw36v5K3lnpJ4xVPpX9D5MtIMf5s6/6zDt1oauxo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQdJ+HyKXD+Ed+XlyRZm2wvM3u7eLzIo5ygZW02oK8+Qtj3sgx0Pn/Ladf2JVV2a3
         eT3ChGV0ancq25FyUHIiq+UH51grG6+8LNm+I0fBI/dl1CPRFgE8QBn4FhNJyVd9eB
         RLpqGJKHQP/pv+pTjSZraP1p6DzQFwXfO0O/+PGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunwoo Kim <imv4bel@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15 003/121] efi: capsule-loader: Fix use-after-free in efi_capsule_write
Date:   Tue, 13 Sep 2022 16:03:14 +0200
Message-Id: <20220913140357.472106951@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 9cb636b5f6a8cc6d1b50809ec8f8d33ae0c84c95 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/capsule-loader.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -243,29 +243,6 @@ failed:
 }
 
 /**
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
-/**
  * efi_capsule_release - called by file close
  * @inode: not used
  * @file: file pointer
@@ -277,6 +254,13 @@ static int efi_capsule_release(struct in
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
@@ -324,7 +308,6 @@ static const struct file_operations efi_
 	.owner = THIS_MODULE,
 	.open = efi_capsule_open,
 	.write = efi_capsule_write,
-	.flush = efi_capsule_flush,
 	.release = efi_capsule_release,
 	.llseek = no_llseek,
 };


