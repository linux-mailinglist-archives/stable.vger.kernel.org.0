Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C826A3B61F4
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhF1Okb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235031AbhF1OjG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:39:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 906BE61CB1;
        Mon, 28 Jun 2021 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890684;
        bh=I49dlS5replOMXaiNRkW/DNDzkiXhB7kUX7ofN3K66g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLa++Dpo9NGHI4go2MRI4mAp/QxGQFLoMYD2EwPZG7mu0leEcr7pl24e/2Nd93sAb
         vdX9X692xJ3C6wwNyUM+NQxyuZdoUE1dhNKEj5cau5Pouiqe+bjVRN2LBHfRJ7Py9o
         D3Rmhjra7FIO8Lo/NoE7GgTxWzqx2+uCP2wdyTPq1a0RJCU46ybnB2ffX2IYQeJzYl
         w3eZOTW6R4pFLM2tIKE5g6l0xQofEyC9VY3mCWr46/I0USVFUAOWnBZlbzjHRVT8b4
         HFrFj2O9T7CBeAD8jKKx2Bh0+p1u3a0U99BeENonZaWl4ZHsmLple3TeAjZ6OqAT2Q
         jsr2zV62866XQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nayna Jain <nayna@linux.ibm.com>, Mimi Zohar <zohar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 67/71] certs: Add wrapper function to check blacklisted binary hash
Date:   Mon, 28 Jun 2021 10:30:00 -0400
Message-Id: <20210628143004.32596-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nayna Jain <nayna@linux.ibm.com>

[ Upstream commit 2434f7d2d488c3301ae81f1031e1c66c6f076fb7 ]

The -EKEYREJECTED error returned by existing is_hash_blacklisted() is
misleading when called for checking against blacklisted hash of a
binary.

This patch adds a wrapper function is_binary_blacklisted() to return
-EPERM error if binary is blacklisted.

Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1572492694-6520-7-git-send-email-zohar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 certs/blacklist.c             | 9 +++++++++
 include/keys/system_keyring.h | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/certs/blacklist.c b/certs/blacklist.c
index 025a41de28fd..f1c434b04b5e 100644
--- a/certs/blacklist.c
+++ b/certs/blacklist.c
@@ -135,6 +135,15 @@ int is_hash_blacklisted(const u8 *hash, size_t hash_len, const char *type)
 }
 EXPORT_SYMBOL_GPL(is_hash_blacklisted);
 
+int is_binary_blacklisted(const u8 *hash, size_t hash_len)
+{
+	if (is_hash_blacklisted(hash, hash_len, "bin") == -EKEYREJECTED)
+		return -EPERM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(is_binary_blacklisted);
+
 /*
  * Initialise the blacklist
  */
diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index c1a96fdf598b..fb8b07daa9d1 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -35,12 +35,18 @@ extern int restrict_link_by_builtin_and_secondary_trusted(
 extern int mark_hash_blacklisted(const char *hash);
 extern int is_hash_blacklisted(const u8 *hash, size_t hash_len,
 			       const char *type);
+extern int is_binary_blacklisted(const u8 *hash, size_t hash_len);
 #else
 static inline int is_hash_blacklisted(const u8 *hash, size_t hash_len,
 				      const char *type)
 {
 	return 0;
 }
+
+static inline int is_binary_blacklisted(const u8 *hash, size_t hash_len)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_IMA_BLACKLIST_KEYRING
-- 
2.30.2

