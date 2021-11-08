Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C18944A05A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241543AbhKIBDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:03:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241558AbhKIBDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:03:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC11261279;
        Tue,  9 Nov 2021 01:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419618;
        bh=W0ELrzJMxGLWNUf0TkqG30Vy8t8GwFJcoOZnhnjEX60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NH1RQYGnfsIl2C414BEbRjC09rtOYxpyiCR9KCtpBruwSiYNoK2uw0snb2TP/GzIO
         HhnCE3yyVP0F23134BOxJ8J9lXheUWB1erFdmNnQpeKMnDC97WQRky8jnhNEWccCFZ
         pKXeEvLBE+MnsSA5dbEidqCZXq52Z9sHYka9eqWp5iMB9a1J6u7FB72FEwWFObV+D3
         ec6Oe/mUGweWcL+ORJEzUAmExdhHHf0IjyZeaLkwfmMtOelQ+wngHO/Zon059z1Bwu
         B/PposcW0WBYfhkJDnOz3LMV4jO7AcrKRICPm+rbIBDv6Ab6j/rvPfF2nQ/QWkEmZp
         0N3knEQCsF42Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, Herbert@vger.kernel.org,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 020/146] crypto: aesni - check walk.nbytes instead of err
Date:   Mon,  8 Nov 2021 12:42:47 -0500
Message-Id: <20211108174453.1187052-20-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>

[ Upstream commit a2d3cbc80d2527b435154ff0f89b56ef4b84370f ]

In the code for xts_crypt(), we check for the err value returned by
skcipher_walk_virt() and return from the function if it is non zero.
However, skcipher_walk_virt() can set walk.nbytes to 0, which would cause
us to call kernel_fpu_begin(), and then skip the kernel_fpu_end() call.

This patch checks for the walk.nbytes value instead, and returns if
walk.nbytes is 0. This prevents us from calling kernel_fpu_begin() in
the first place and also covers the case of having a non zero err value
returned from skcipher_walk_virt().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 0fc961bef299c..e09f4672dd382 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -866,7 +866,7 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		req = &subreq;
 
 		err = skcipher_walk_virt(&walk, req, false);
-		if (err)
+		if (!walk.nbytes)
 			return err;
 	} else {
 		tail = 0;
-- 
2.33.0

