Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4AB328858
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238821AbhCARi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:38:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238224AbhCARbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:31:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E9996509B;
        Mon,  1 Mar 2021 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617563;
        bh=qA2TRLyly4mfWKsGE8VnSuu01WrBUCQNqc7S0NQ+JhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJC+53Yigf1u2DoDzxTPnTfLEysJafHJlBs66ApLqlGH17FkfrVZbDN0pCQzI6DOY
         x+52p4QzBzkE2WVt351YfgO+VKOSgpCH91Oq3m4VNbn8XC8Vmqy1JsgEdKF73dpZFN
         xqcOanFsIf/XzS19Rzg3RL2C8yol6bXHutBIotsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/340] crypto: ecdh_helper - Ensure len >= secret.len in decode_key()
Date:   Mon,  1 Mar 2021 17:11:01 +0100
Message-Id: <20210301161054.096001322@linuxfoundation.org>
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

From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>

[ Upstream commit a53ab94eb6850c3657392e2d2ce9b38c387a2633 ]

The length ('len' parameter) passed to crypto_ecdh_decode_key() is never
checked against the length encoded in the passed buffer ('buf'
parameter). This could lead to an out-of-bounds access when the passed
length is less than the encoded length.

Add a check to prevent that.

Fixes: 3c4b23901a0c7 ("crypto: ecdh - Add ECDH software support")
Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdh_helper.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/ecdh_helper.c b/crypto/ecdh_helper.c
index 66fcb2ea81544..fca63b559f655 100644
--- a/crypto/ecdh_helper.c
+++ b/crypto/ecdh_helper.c
@@ -67,6 +67,9 @@ int crypto_ecdh_decode_key(const char *buf, unsigned int len,
 	if (secret.type != CRYPTO_KPP_SECRET_TYPE_ECDH)
 		return -EINVAL;
 
+	if (unlikely(len < secret.len))
+		return -EINVAL;
+
 	ptr = ecdh_unpack_data(&params->curve_id, ptr, sizeof(params->curve_id));
 	ptr = ecdh_unpack_data(&params->key_size, ptr, sizeof(params->key_size));
 	if (secret.len != crypto_ecdh_key_len(params))
-- 
2.27.0



