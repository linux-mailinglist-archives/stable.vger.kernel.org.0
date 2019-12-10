Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E97119A15
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfLJVte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfLJVId (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E832B24697;
        Tue, 10 Dec 2019 21:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012112;
        bh=SgKtEPnqVxF0Va4TfbyUSL22ciLWUHPlgxeLtNInAOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXXOdRPHesjrbZfaNi6F4K/Qesf06jsmUIbbfaO+mgxct6hSBumKQb5tIr1iONFhT
         0yLV5EgFHLPMsGT/+iKxgNL1Eaj/AFmwU8xhFQ6JzPqeZsT/brDxn7CUAjBWBdsAT0
         RULAOodqTIxxOr7G3y81MuG1/hJlV8RBM1DiNcro=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 085/350] crypto: inside-secure - Fix a maybe-uninitialized warning
Date:   Tue, 10 Dec 2019 16:03:10 -0500
Message-Id: <20191210210735.9077-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 74e6bd472b6d9e80ec9972989d8991736fe46c51 ]

A previous fixup avoided an unused variable warning but replaced
it with a slightly scarier warning:

drivers/crypto/inside-secure/safexcel.c:1100:6: error: variable 'irq' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]

This is harmless as it is impossible to get into this case, but
the compiler has no way of knowing that. Add an explicit error
handling case to make it obvious to both compilers and humans
reading the source.

Fixes: 212ef6f29e5b ("crypto: inside-secure - Fix unused variable warning when CONFIG_PCI=n")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 294debd435b6b..991a4425f006a 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1120,6 +1120,8 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 				irq_name, irq);
 			return irq;
 		}
+	} else {
+		return -ENXIO;
 	}
 
 	ret = devm_request_threaded_irq(dev, irq, handler,
-- 
2.20.1

