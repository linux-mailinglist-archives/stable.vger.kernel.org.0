Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2A8246FFB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388643AbgHQR4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388549AbgHQQK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:10:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7386C22D75;
        Mon, 17 Aug 2020 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680614;
        bh=xdUZ6JmuAWxPCP7ksF1xp3Pn0z3uNevBMXyZq8yKP4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxpyeVKC0bLPFWOfWgwj9HH1WsfG5wuicNq6ROvZPSQkh6UKp0zbTmej1utDKnyoR
         K31GV38hogT6PGlFciKLW/XyiJsXm5NNdGQ5lwalXtysYkyZ4yDRjiU/GA917sMapl
         NM/gWOiFQCdDMcor3yU/7VI0pEt1PBAd6SxaLWo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@linux.microsoft.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 256/270] pstore: Fix linking when crypto API disabled
Date:   Mon, 17 Aug 2020 17:17:37 +0200
Message-Id: <20200817143808.572108530@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@linux.microsoft.com>

commit fd49e03280e596e54edb93a91bc96170f8e97e4a upstream.

When building a kernel with CONFIG_PSTORE=y and CONFIG_CRYPTO not set,
a build error happens:

    ld: fs/pstore/platform.o: in function `pstore_dump':
    platform.c:(.text+0x3f9): undefined reference to `crypto_comp_compress'
    ld: fs/pstore/platform.o: in function `pstore_get_backend_records':
    platform.c:(.text+0x784): undefined reference to `crypto_comp_decompress'

This because some pstore code uses crypto_comp_(de)compress regardless
of the CONFIG_CRYPTO status. Fix it by wrapping the (de)compress usage
by IS_ENABLED(CONFIG_PSTORE_COMPRESS)

Signed-off-by: Matteo Croce <mcroce@linux.microsoft.com>
Link: https://lore.kernel.org/lkml/20200706234045.9516-1-mcroce@linux.microsoft.com
Fixes: cb3bee0369bc ("pstore: Use crypto compress API")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/platform.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -275,6 +275,9 @@ static int pstore_compress(const void *i
 {
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_PSTORE_COMPRESSION))
+		return -EINVAL;
+
 	ret = crypto_comp_compress(tfm, in, inlen, out, &outlen);
 	if (ret) {
 		pr_err("crypto_comp_compress failed, ret = %d!\n", ret);
@@ -661,7 +664,7 @@ static void decompress_record(struct pst
 	int unzipped_len;
 	char *unzipped, *workspace;
 
-	if (!record->compressed)
+	if (!IS_ENABLED(CONFIG_PSTORE_COMPRESSION) || !record->compressed)
 		return;
 
 	/* Only PSTORE_TYPE_DMESG support compression. */


