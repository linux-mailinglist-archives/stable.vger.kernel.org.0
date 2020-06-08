Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2C1F2DDD
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgFIAhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729633AbgFHXNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 934D6212CC;
        Mon,  8 Jun 2020 23:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658032;
        bh=iBUom3UexuJtoL9Ox33IMnAZayXMsAmGh1AfuUlcV8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0eL5QqP8ei447D5afqv2l8GxkeH0hRjTbXsuTBo8hNRWhZOQ/0TMNh+8UEqOXG/j
         HAbV9zm/3zV08DTc+C0eAKCu3kPi8SDoGSySu2aa5lZSXjIp2aTTfiI34Kv0jUZrLb
         GHZNcoh36qrUTd6wS0qdbPS9Fd9fXyXxUv3OO6sg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 083/606] evm: Check also if *tfm is an error pointer in init_desc()
Date:   Mon,  8 Jun 2020 19:03:28 -0400
Message-Id: <20200608231211.3363633-83-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

