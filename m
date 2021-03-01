Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DBE328CE0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240810AbhCATA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:00:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240793AbhCASx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:53:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F9D065191;
        Mon,  1 Mar 2021 17:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618665;
        bh=aX5hJxqw5n5ej0Fl9vYIFNNP+8dvW9NKJkz4v5qLVkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qu5LMXSzmb0Iv+YVRidjL8cGuvQNtzSKxTrvito2pdzDoSWZGm5IWAKkrJAJDxYoF
         DGgf1hsjarMSCSe9/kQzd07Vb5KawvrYmb+GWA3vJLuFV3i60+e34MoV/Lb5W/2xq5
         4CL8Nudk8P2b4WSDJ5DXhpU3pJrChUSHhVWUYCjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/663] evm: Fix memleak in init_desc
Date:   Mon,  1 Mar 2021 17:07:00 +0100
Message-Id: <20210301161150.294433715@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 168c3b78ac47b..a6dd47eb086da 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -73,7 +73,7 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 {
 	long rc;
 	const char *algo;
-	struct crypto_shash **tfm, *tmp_tfm;
+	struct crypto_shash **tfm, *tmp_tfm = NULL;
 	struct shash_desc *desc;
 
 	if (type == EVM_XATTR_HMAC) {
@@ -118,13 +118,16 @@ unlock:
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



