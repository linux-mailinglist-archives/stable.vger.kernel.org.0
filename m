Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE051481D8
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391289AbgAXLXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:23:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391288AbgAXLXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:23:11 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B08CD214DB;
        Fri, 24 Jan 2020 11:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864990;
        bh=QQMrl2AYpw4eoy/KkYteriQnmbgh1dlGzHeJYhnkIA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtfzZGPtUym14uyTJqyY+hoopxRY2hay0mMUIQ2hrWrcaRsLla55iGAX5EvZ1P/qy
         f7EztcGGWS8dCI3z4/NiKyTJ8kZpWp8vyXkZa2xVa97kzppRsUmBBc9j3atEUdfi+q
         TKSh9vSkBZtszW0geidALrhlaIbOw1czNVsa0LhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 414/639] crypto: inside-secure - fix queued len computation
Date:   Fri, 24 Jan 2020 10:29:44 +0100
Message-Id: <20200124093138.883889624@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

[ Upstream commit ccd65a206a5025cf953a2e4f37e894921b131a5c ]

This patch fixes the queued len computation, which could theoretically
be wrong if req->len[1] - req->processed[1] > 1. Be future-proof here,
and fix it.

Fixes: b460edb6230a ("crypto: inside-secure - sha512 support")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 9a02f64a45b96..f3b02c00b7846 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -50,10 +50,12 @@ struct safexcel_ahash_req {
 
 static inline u64 safexcel_queued_len(struct safexcel_ahash_req *req)
 {
-	if (req->len[1] > req->processed[1])
-		return 0xffffffff - (req->len[0] - req->processed[0]);
+	u64 len, processed;
 
-	return req->len[0] - req->processed[0];
+	len = (0xffffffff * req->len[1]) + req->len[0];
+	processed = (0xffffffff * req->processed[1]) + req->processed[0];
+
+	return len - processed;
 }
 
 static void safexcel_hash_token(struct safexcel_command_desc *cdesc,
-- 
2.20.1



