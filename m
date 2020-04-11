Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6378D1A587C
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgDKXaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729650AbgDKXKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDBA520757;
        Sat, 11 Apr 2020 23:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646638;
        bh=10325/ww294pR6V/vtzlL8aYDZ/x2rLiFJWgKNGtC4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9LTe292Weuap0I7qjAqHEsPCY9UJQRXeY5xBWrm7IfaRokcQ/aBETHXesq27tnBs
         CTODmryb+UExnQvTFb+puc3A1bP7c8LUmfvlYi0bDfyLY+gz02ECE9ahyaBxEIr2fQ
         4vmPiPL7ZgnmRyJNEBpEnpKQGQnDkjaffDoVPbug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 045/108] crypto: tcrypt - fix printed skcipher [a]sync mode
Date:   Sat, 11 Apr 2020 19:08:40 -0400
Message-Id: <20200411230943.24951-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

[ Upstream commit 8e3b7fd7ea554ccb1bdc596bfbcdaf56f7ab017c ]

When running tcrypt skcipher speed tests, logs contain things like:
testing speed of async ecb(des3_ede) (ecb(des3_ede-generic)) encryption
or:
testing speed of async ecb(aes) (ecb(aes-ce)) encryption

The algorithm implementations are sync, not async.
Fix this inaccuracy.

Fixes: 7166e589da5b6 ("crypto: tcrypt - Use skcipher")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 83ad0b1fab30a..d164ec4e4db95 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1514,8 +1514,8 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of async %s (%s) %s\n", algo,
-			get_driver_name(crypto_skcipher, tfm), e);
+	pr_info("\ntesting speed of %s %s (%s) %s\n", async ? "async" : "sync",
+		algo, get_driver_name(crypto_skcipher, tfm), e);
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-- 
2.20.1

