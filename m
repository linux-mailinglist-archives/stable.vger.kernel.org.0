Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D7F29AF4D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755267AbgJ0OJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755265AbgJ0OJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:09:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668E7218AC;
        Tue, 27 Oct 2020 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807745;
        bh=98MVfGRSz67JXtxqsZ5WoHZirfKIEbRY1tvqQIFMS+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbtYwWvZ4BNbTfGJEvBDe419SVKys/bitCvU0Fv77fTGjrOo4zSVWpupj4XVRx/np
         fVhKEH1uPmHDw6SNeYi3TzKMwGIb1zksbKMp1Vi6q6Dxp3hRbERH9C0C7clGfgptHg
         NMNgOLYXec8Cv0tRMu5HS+qEi9LBFZmC1H6CZlSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 025/191] crypto: algif_skcipher - EBUSY on aio should be an error
Date:   Tue, 27 Oct 2020 14:48:00 +0100
Message-Id: <20201027134910.931831071@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 2a05b029c1ee045b886ebf9efef9985ca23450de ]

I removed the MAY_BACKLOG flag on the aio path a while ago but
the error check still incorrectly interpreted EBUSY as success.
This may cause the submitter to wait for a request that will never
complete.

Fixes: dad419970637 ("crypto: algif_skcipher - Do not set...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algif_skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index d9ec5dca86729..a9dc4eeddcd53 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -133,7 +133,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
 
 		/* AIO operation in progress */
-		if (err == -EINPROGRESS || err == -EBUSY)
+		if (err == -EINPROGRESS)
 			return -EIOCBQUEUED;
 
 		sock_put(sk);
-- 
2.25.1



