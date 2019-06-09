Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45403AACC
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbfFIQpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729717AbfFIQpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:45:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1DCE2145D;
        Sun,  9 Jun 2019 16:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098714;
        bh=F8mVEECUDWVAl2J0GvhC9Qkc1zHUdiM9elyggL2b6Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdfoaqZPby3ngSIcgq5Uo5TCSijmO+iw2t17WwVQXaE/TdqesCQ+FI5tX8wDusUjc
         FZD2D1De8Lgv8h7eSFP1fWL4zQTqouHeycbgz6T0OTrFLMFEpi7KSckDi626cghoMY
         u6E9ujzYHlwVmbZjGa2MIuCfBBjO07AL+wMo2abA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pi-Hsun Shih <pihsun@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.1 33/70] pstore: Set tfm to NULL on free_buf_for_compression
Date:   Sun,  9 Jun 2019 18:41:44 +0200
Message-Id: <20190609164129.877736227@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pi-Hsun Shih <pihsun@chromium.org>

commit a9fb94a99bb515d8720ba8440ce3aba84aec80f8 upstream.

Set tfm to NULL on free_buf_for_compression() after crypto_free_comp().

This avoid a use-after-free when allocate_buf_for_compression()
and free_buf_for_compression() are called twice. Although
free_buf_for_compression() freed the tfm, allocate_buf_for_compression()
won't reinitialize the tfm since the tfm pointer is not NULL.

Fixes: 95047b0519c1 ("pstore: Refactor compression initialization")
Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/platform.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -347,8 +347,10 @@ static void allocate_buf_for_compression
 
 static void free_buf_for_compression(void)
 {
-	if (IS_ENABLED(CONFIG_PSTORE_COMPRESS) && tfm)
+	if (IS_ENABLED(CONFIG_PSTORE_COMPRESS) && tfm) {
 		crypto_free_comp(tfm);
+		tfm = NULL;
+	}
 	kfree(big_oops_buf);
 	big_oops_buf = NULL;
 	big_oops_buf_sz = 0;


