Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6113D451359
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348171AbhKOTuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:50:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245680AbhKOTVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C59F16357C;
        Mon, 15 Nov 2021 18:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001553;
        bh=W0ELrzJMxGLWNUf0TkqG30Vy8t8GwFJcoOZnhnjEX60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vTg7hrYekc1GhfiJsz6MZyfGCPjFbtgGUuxyHBnCKSXPndcbuvy2kdalFXkgFnJp
         /upX+Ty+RnnM4k3pzz+4DI2yztzTuAnG2K/gC9gR0ndKy9gHiQ12hpdG26pYjmQyoV
         jwvRxyS0w3ICLruCmugXuQOjrx9kEXCCFP+Uz1SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 201/917] crypto: aesni - check walk.nbytes instead of err
Date:   Mon, 15 Nov 2021 17:54:56 +0100
Message-Id: <20211115165435.611033758@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



