Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9D95B739F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiIMPGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbiIMPEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:04:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860B274DCC;
        Tue, 13 Sep 2022 07:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3907A614DA;
        Tue, 13 Sep 2022 14:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDC8C433D6;
        Tue, 13 Sep 2022 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079421;
        bh=d8/BjMjVzY/n7XeMlWP1JgbELelWC0FaNED4myX5wmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXn7Y6D+9rkxH8csv3hoX2Z+CwRkIyLKxsLLvfuH4khgryIXTSqEXTOgCFz139zPt
         eoa2Q7sbcxA72S2X4hpM7MEsMf24Khhd0/SjWyd1ttG/XP3SUX2142YbsHwcEZZJ7P
         ZJckrO8ArdEF7JQKzi/h+iAcLG4HlAhDhVu+SNYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunwoo Kim <imv4bel@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.19 02/79] efi: capsule-loader: Fix use-after-free in efi_capsule_write
Date:   Tue, 13 Sep 2022 16:06:20 +0200
Message-Id: <20220913140348.959636664@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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
@@ -244,29 +244,6 @@ failed:
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
@@ -278,6 +255,13 @@ static int efi_capsule_release(struct in
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
@@ -325,7 +309,6 @@ static const struct file_operations efi_
 	.owner = THIS_MODULE,
 	.open = efi_capsule_open,
 	.write = efi_capsule_write,
-	.flush = efi_capsule_flush,
 	.release = efi_capsule_release,
 	.llseek = no_llseek,
 };


