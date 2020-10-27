Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F27B29B6E5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368764AbgJ0P1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798129AbgJ0PZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:25:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17AB12064B;
        Tue, 27 Oct 2020 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812338;
        bh=3bRW85rmW9aAnByhqcnNN6OnazKFpyr44Txi37WjZs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+JbAbH+Z6p27kH/pEv5wj6H+Aafl3N/Gg1Xa4dL3CM2yyvaZCXKjwq9oeqqCOhqt
         G2kQD+lkm7gtJyG+QVMQV9t0w9KOazEjq9WTJJHmjz8lZieSdHCZfhJGk6TRM8v35i
         wCSF4CQkEEnsesFPdo9KUduzxLZ2hjrPne3+UXoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Tero Kristo <t-kristo@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 144/757] crypto: sa2ul - fix compiler warning produced by clang
Date:   Tue, 27 Oct 2020 14:46:34 +0100
Message-Id: <20201027135457.352517492@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit 17bce37e1b5eca95f9da783a07930b6d608c1389 ]

Clang detects a warning for an assignment that doesn't really do
anything. Fix this by removing the offending piece of code.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com> # build
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 5bc099052bd20..ff8bbdb4d235d 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1148,12 +1148,10 @@ static int sa_run(struct sa_req *req)
 			ret = sg_split(req->dst, mapped_dst_nents, 0, 1,
 				       &split_size, &dst, &dst_nents,
 				       gfp_flags);
-			if (ret) {
-				dst_nents = dst_nents;
+			if (ret)
 				dst = req->dst;
-			} else {
+			else
 				rxd->split_dst_sg = dst;
-			}
 		}
 	}
 
-- 
2.25.1



