Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41323328851
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbhCARit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237463AbhCAR3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:29:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABD5C6508F;
        Mon,  1 Mar 2021 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617486;
        bh=Ul8Be2rg6ebIpXmgEbayiVOTFpc0ZHSVmxl3kPdvAak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=be0WG2jRvKt6PlYJWpz8c4cBidm4HPoPddiHV46yuFI9+Kt2+klREupUOx8Fyczrl
         deIk7xGRtN66F8eD+aYl2Pa0JtwTIjJogwLfVNhlwdWKzEIfBTt2e5vKAPpn/4/wfY
         OJirP/UunO1OWc1I5fmvGP5U/ssOLplYHwj0nK50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/340] evm: Fix memleak in init_desc
Date:   Mon,  1 Mar 2021 17:10:34 +0100
Message-Id: <20210301161052.755490611@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit ccf11dbaa07b328fa469415c362d33459c140a37 ]

tmp_tfm is allocated, but not freed on subsequent kmalloc failure, which
leads to a memory leak.  Free tmp_tfm.

Fixes: d46eb3699502b ("evm: crypto hash replaced by shash")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
[zohar@linux.ibm.com: formatted/reworded patch description]
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index ee6bd945f3d6a..25dac691491b1 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -75,7 +75,7 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 {
 	long rc;
 	const char *algo;
-	struct crypto_shash **tfm, *tmp_tfm;
+	struct crypto_shash **tfm, *tmp_tfm = NULL;
 	struct shash_desc *desc;
 
 	if (type == EVM_XATTR_HMAC) {
@@ -120,13 +120,16 @@ unlock:
 alloc:
 	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(*tfm),
 			GFP_KERNEL);
-	if (!desc)
+	if (!desc) {
+		crypto_free_shash(tmp_tfm);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	desc->tfm = *tfm;
 
 	rc = crypto_shash_init(desc);
 	if (rc) {
+		crypto_free_shash(tmp_tfm);
 		kfree(desc);
 		return ERR_PTR(rc);
 	}
-- 
2.27.0



