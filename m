Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DF6383275
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbhEQOsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241774AbhEQOqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:46:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD9F061448;
        Mon, 17 May 2021 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261280;
        bh=Kt9kyEWJd9xaRMNQHUWBMtEao+CZbeSDxxLpH2azuwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soD9DfllXu2RsQK11meg+2tnd+Go3jV/5xX6DmE1NThAWBYXgQ/nyy7kQkRDexuXs
         Scug8P3A3ZSILQ5RRo88e4CMFURXhU5+596hfupJ2JcQv9/+PdIedZPGEXenOznipF
         nUROJMetTFDQE8v59SrjHLvGBbi768tQauPMA8Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 001/289] KEYS: trusted: Fix memory leak on object td
Date:   Mon, 17 May 2021 15:58:46 +0200
Message-Id: <20210517140305.198832527@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 83a775d5f9bfda95b1c295f95a3a041a40c7f321 upstream.

Two error return paths are neglecting to free allocated object td,
causing a memory leak. Fix this by returning via the error return
path that securely kfree's td.

Fixes clang scan-build warning:
security/keys/trusted-keys/trusted_tpm1.c:496:10: warning: Potential
memory leak [unix.Malloc]

Cc: stable@vger.kernel.org
Fixes: 5df16caada3f ("KEYS: trusted: Fix incorrect handling of tpm_get_random()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm1.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -500,10 +500,12 @@ static int tpm_seal(struct tpm_buf *tb,
 
 	ret = tpm_get_random(chip, td->nonceodd, TPM_NONCE_SIZE);
 	if (ret < 0)
-		return ret;
+		goto out;
 
-	if (ret != TPM_NONCE_SIZE)
-		return -EIO;
+	if (ret != TPM_NONCE_SIZE) {
+		ret = -EIO;
+		goto out;
+	}
 
 	ordinal = htonl(TPM_ORD_SEAL);
 	datsize = htonl(datalen);


