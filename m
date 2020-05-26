Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACBD1E2D7D
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391558AbgEZTLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391544AbgEZTLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:11:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBAD820888;
        Tue, 26 May 2020 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520298;
        bh=iBUom3UexuJtoL9Ox33IMnAZayXMsAmGh1AfuUlcV8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3Hb/W73i1gCgu1ukd8EdKOixenga+i5bPAvIArA+XsWEcPLY48xEB6ZuYHvFjyzl
         8QxvgNCBOIZJa/TxdUVF0BA1F4DVjD66vMHYruyRgiwSyE3buk6sOkUDPE3KUFu7zW
         E/xl69YSLVb8U8067Tve0Nu4ACTPjdUcUImfme4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 004/126] evm: Check also if *tfm is an error pointer in init_desc()
Date:   Tue, 26 May 2020 20:52:21 +0200
Message-Id: <20200526183937.860467687@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit 53de3b080d5eae31d0de219617155dcc34e7d698 ]

This patch avoids a kernel panic due to accessing an error pointer set by
crypto_alloc_shash(). It occurs especially when there are many files that
require an unsupported algorithm, as it would increase the likelihood of
the following race condition:

Task A: *tfm = crypto_alloc_shash() <= error pointer
Task B: if (*tfm == NULL) <= *tfm is not NULL, use it
Task B: rc = crypto_shash_init(desc) <= panic
Task A: *tfm = NULL

This patch uses the IS_ERR_OR_NULL macro to determine whether or not a new
crypto context must be created.

Cc: stable@vger.kernel.org
Fixes: d46eb3699502b ("evm: crypto hash replaced by shash")
Co-developed-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
Signed-off-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index d485f6fc908e..302adeb2d37b 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -93,7 +93,7 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 		algo = hash_algo_name[hash_algo];
 	}
 
-	if (*tfm == NULL) {
+	if (IS_ERR_OR_NULL(*tfm)) {
 		mutex_lock(&mutex);
 		if (*tfm)
 			goto out;
-- 
2.25.1



