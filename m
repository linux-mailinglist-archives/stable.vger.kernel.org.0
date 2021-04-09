Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284CD359AF4
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhDIKHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233550AbhDIKDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:03:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F0A4611F2;
        Fri,  9 Apr 2021 10:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962428;
        bh=LrzzfTbwiK3OB9WdWUInWmIVYV7/3jgwGKThzM5586o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5ouoh1XJH401CWQ98yf33zGRhum0CsH0FHAFrQQAqOnIet7RgNmtdTXeVBHuxLP/
         if+N7jJ03C1lMkhu51o5ppCDNd0WYPJvspbXWXG/mu7DHbfMj9wlR1RVTFmVsBFfNs
         9TYqWGlTIsEzAorusUEsMFjORgYTk97QhBKMuqEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Phan <daniel.phan36@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 12/45] mac80211: Check crypto_aead_encrypt for errors
Date:   Fri,  9 Apr 2021 11:53:38 +0200
Message-Id: <20210409095305.794681785@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Phan <daniel.phan36@gmail.com>

[ Upstream commit 58d25626f6f0ea5bcec3c13387b9f835d188723d ]

crypto_aead_encrypt returns <0 on error, so if these calls are not checked,
execution may continue with failed encrypts.  It also seems that these two
crypto_aead_encrypt calls are the only instances in the codebase that are
not checked for errors.

Signed-off-by: Daniel Phan <daniel.phan36@gmail.com>
Link: https://lore.kernel.org/r/20210309204137.823268-1-daniel.phan36@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/aead_api.c | 5 +++--
 net/mac80211/aes_gmac.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/aead_api.c b/net/mac80211/aead_api.c
index d7b3d905d535..b00d6f5b33f4 100644
--- a/net/mac80211/aead_api.c
+++ b/net/mac80211/aead_api.c
@@ -23,6 +23,7 @@ int aead_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
 	struct aead_request *aead_req;
 	int reqsize = sizeof(*aead_req) + crypto_aead_reqsize(tfm);
 	u8 *__aad;
+	int ret;
 
 	aead_req = kzalloc(reqsize + aad_len, GFP_ATOMIC);
 	if (!aead_req)
@@ -40,10 +41,10 @@ int aead_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
 	aead_request_set_crypt(aead_req, sg, sg, data_len, b_0);
 	aead_request_set_ad(aead_req, sg[0].length);
 
-	crypto_aead_encrypt(aead_req);
+	ret = crypto_aead_encrypt(aead_req);
 	kfree_sensitive(aead_req);
 
-	return 0;
+	return ret;
 }
 
 int aead_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
diff --git a/net/mac80211/aes_gmac.c b/net/mac80211/aes_gmac.c
index 6f3b3a0cc10a..512cab073f2e 100644
--- a/net/mac80211/aes_gmac.c
+++ b/net/mac80211/aes_gmac.c
@@ -22,6 +22,7 @@ int ieee80211_aes_gmac(struct crypto_aead *tfm, const u8 *aad, u8 *nonce,
 	struct aead_request *aead_req;
 	int reqsize = sizeof(*aead_req) + crypto_aead_reqsize(tfm);
 	const __le16 *fc;
+	int ret;
 
 	if (data_len < GMAC_MIC_LEN)
 		return -EINVAL;
@@ -59,10 +60,10 @@ int ieee80211_aes_gmac(struct crypto_aead *tfm, const u8 *aad, u8 *nonce,
 	aead_request_set_crypt(aead_req, sg, sg, 0, iv);
 	aead_request_set_ad(aead_req, GMAC_AAD_LEN + data_len);
 
-	crypto_aead_encrypt(aead_req);
+	ret = crypto_aead_encrypt(aead_req);
 	kfree_sensitive(aead_req);
 
-	return 0;
+	return ret;
 }
 
 struct crypto_aead *ieee80211_aes_gmac_key_setup(const u8 key[],
-- 
2.30.2



