Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A19923685
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389004AbfETMZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389000AbfETMZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E97E020645;
        Mon, 20 May 2019 12:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355109;
        bh=g+LiIFWUKzTKBJwpmGwYkeqEN7TNVfGGtCtw2bIfbs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEoqgwRshE/Sw0Gtmv78FevFi5TvUO9DCkX5S0El1H+DnJQVauZm4/owBfYofQmQ1
         2nDDlgF8pt4FMpqe/lBJVfjeCKSFGN01ezBHkw8ma2PNoG6nwlHu8rzQA+3EUBDQUO
         XXgwp2m7vVeBbNgUKuK51wlSdNumXFAcou1z5DXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Guenter Roeck <groeck@chromium.org>
Subject: [PATCH 4.19 101/105] pstore: Refactor compression initialization
Date:   Mon, 20 May 2019 14:14:47 +0200
Message-Id: <20190520115254.199143364@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 95047b0519c17a28e09df5f38750f5354e3db4c4 upstream.

This refactors compression initialization slightly to better handle
getting potentially called twice (via early pstore_register() calls
and later pstore_init()) and improves the comments and reporting to be
more verbose.

Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/platform.c |   48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -274,36 +274,56 @@ static int pstore_decompress(void *in, v
 
 static void allocate_buf_for_compression(void)
 {
+	struct crypto_comp *ctx;
+	int size;
+	char *buf;
+
+	/* Skip if not built-in or compression backend not selected yet. */
 	if (!IS_ENABLED(CONFIG_PSTORE_COMPRESS) || !zbackend)
 		return;
 
+	/* Skip if no pstore backend yet or compression init already done. */
+	if (!psinfo || tfm)
+		return;
+
 	if (!crypto_has_comp(zbackend->name, 0, 0)) {
-		pr_err("No %s compression\n", zbackend->name);
+		pr_err("Unknown compression: %s\n", zbackend->name);
 		return;
 	}
 
-	big_oops_buf_sz = zbackend->zbufsize(psinfo->bufsize);
-	if (big_oops_buf_sz <= 0)
+	size = zbackend->zbufsize(psinfo->bufsize);
+	if (size <= 0) {
+		pr_err("Invalid compression size for %s: %d\n",
+		       zbackend->name, size);
 		return;
+	}
 
-	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
-	if (!big_oops_buf) {
-		pr_err("allocate compression buffer error!\n");
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf) {
+		pr_err("Failed %d byte compression buffer allocation for: %s\n",
+		       size, zbackend->name);
 		return;
 	}
 
-	tfm = crypto_alloc_comp(zbackend->name, 0, 0);
-	if (IS_ERR_OR_NULL(tfm)) {
-		kfree(big_oops_buf);
-		big_oops_buf = NULL;
-		pr_err("crypto_alloc_comp() failed!\n");
+	ctx = crypto_alloc_comp(zbackend->name, 0, 0);
+	if (IS_ERR_OR_NULL(ctx)) {
+		kfree(buf);
+		pr_err("crypto_alloc_comp('%s') failed: %ld\n", zbackend->name,
+		       PTR_ERR(ctx));
 		return;
 	}
+
+	/* A non-NULL big_oops_buf indicates compression is available. */
+	tfm = ctx;
+	big_oops_buf_sz = size;
+	big_oops_buf = buf;
+
+	pr_info("Using compression: %s\n", zbackend->name);
 }
 
 static void free_buf_for_compression(void)
 {
-	if (IS_ENABLED(CONFIG_PSTORE_COMPRESS) && !IS_ERR_OR_NULL(tfm))
+	if (IS_ENABLED(CONFIG_PSTORE_COMPRESS) && tfm)
 		crypto_free_comp(tfm);
 	kfree(big_oops_buf);
 	big_oops_buf = NULL;
@@ -774,7 +794,6 @@ void __init pstore_choose_compression(vo
 	for (step = zbackends; step->name; step++) {
 		if (!strcmp(compress, step->name)) {
 			zbackend = step;
-			pr_info("using %s compression\n", zbackend->name);
 			return;
 		}
 	}
@@ -791,8 +810,7 @@ static int __init pstore_init(void)
 	 * initialize compression because crypto was not ready. If so,
 	 * initialize compression now.
 	 */
-	if (psinfo && !tfm)
-		allocate_buf_for_compression();
+	allocate_buf_for_compression();
 
 	ret = pstore_init_fs();
 	if (ret)


