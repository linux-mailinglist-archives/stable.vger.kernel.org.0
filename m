Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8931E10BD9C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbfK0Uzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:55:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730218AbfK0Uzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:55:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4B442154A;
        Wed, 27 Nov 2019 20:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888147;
        bh=SWAWfJzmUKIYI5K513r05IPRQy5xw/PP18Nyx4gvL2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdxutCGDrWol8MkXPyYtXmnAKMRUSCPSTnvBJQNjPlZ62Ywv3TBqkCfJN3h1rEFY7
         QEGYf7H0XgawhIUxqcDg1tjIDEBKC63rpvnSXXkbymuEmOUVoAxgbsjpDrQnhKQSCI
         OL4GZh9CfHGaMhxaEpszFeGfyUcAA2TKrsGTtv/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schupikov <michael@schupikov.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/306] crypto: testmgr - fix sizeof() on COMP_BUF_SIZE
Date:   Wed, 27 Nov 2019 21:27:53 +0100
Message-Id: <20191127203116.384045764@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Schupikov <michael@schupikov.de>

[ Upstream commit 22a8118d329334833cd30f2ceb36d28e8cae8a4f ]

After allocation, output and decomp_output both point to memory chunks of
size COMP_BUF_SIZE. Then, only the first bytes are zeroed out using
sizeof(COMP_BUF_SIZE) as parameter to memset(), because
sizeof(COMP_BUF_SIZE) provides the size of the constant and not the size of
allocated memory.

Instead, the whole allocated memory is meant to be zeroed out. Use
COMP_BUF_SIZE as parameter to memset() directly in order to accomplish
this.

Fixes: 336073840a872 ("crypto: testmgr - Allow different compression results")

Signed-off-by: Michael Schupikov <michael@schupikov.de>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3664c26f4838e..13cb2ea99d6a5 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1400,8 +1400,8 @@ static int test_comp(struct crypto_comp *tfm,
 		int ilen;
 		unsigned int dlen = COMP_BUF_SIZE;
 
-		memset(output, 0, sizeof(COMP_BUF_SIZE));
-		memset(decomp_output, 0, sizeof(COMP_BUF_SIZE));
+		memset(output, 0, COMP_BUF_SIZE);
+		memset(decomp_output, 0, COMP_BUF_SIZE);
 
 		ilen = ctemplate[i].inlen;
 		ret = crypto_comp_compress(tfm, ctemplate[i].input,
@@ -1445,7 +1445,7 @@ static int test_comp(struct crypto_comp *tfm,
 		int ilen;
 		unsigned int dlen = COMP_BUF_SIZE;
 
-		memset(decomp_output, 0, sizeof(COMP_BUF_SIZE));
+		memset(decomp_output, 0, COMP_BUF_SIZE);
 
 		ilen = dtemplate[i].inlen;
 		ret = crypto_comp_decompress(tfm, dtemplate[i].input,
-- 
2.20.1



