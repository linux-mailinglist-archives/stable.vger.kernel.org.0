Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241F02E3999
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388891AbgL1NZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388888AbgL1NZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:25:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BD6E2076D;
        Mon, 28 Dec 2020 13:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161879;
        bh=Y+rJ8lGN1YztEouiO0NoaB5+PCJbJ95aNkZ3fggLqzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCF5hPhUN2ycECkFqGPaddU2IDS0uVZa2iTmSTMS85IjScD+h2UjAEOmdDYMgNZ6v
         4svZnKReJQp64y9d89MGejXPoHK5dkmAGnqBPlewZ96M4E0h4Y3QJW6S6FeG3H2boy
         hykT4AqgHnweWyh/+TXlnbP+pwn7zrgQLsYgn0FU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/346] crypto: talitos - Fix return type of current_desc_hdr()
Date:   Mon, 28 Dec 2020 13:47:12 +0100
Message-Id: <20201228124925.252270268@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 0237616173fd363a54bd272aa3bd376faa1d7caa ]

current_desc_hdr() returns a u32 but in fact this is a __be32,
leading to a lot of sparse warnings.

Change the return type to __be32 and ensure it is handled as
sure by the caller.

Fixes: 3e721aeb3df3 ("crypto: talitos - handle descriptor not found in error path")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 7e69d77ea2595..c70a7c4f5b739 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -474,7 +474,7 @@ DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
 /*
  * locate current (offending) descriptor
  */
-static u32 current_desc_hdr(struct device *dev, int ch)
+static __be32 current_desc_hdr(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int tail, iter;
@@ -515,13 +515,13 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 /*
  * user diagnostics; report root cause of error based on execution unit status
  */
-static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
+static void report_eu_error(struct device *dev, int ch, __be32 desc_hdr)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int i;
 
 	if (!desc_hdr)
-		desc_hdr = in_be32(priv->chan[ch].reg + TALITOS_DESCBUF);
+		desc_hdr = cpu_to_be32(in_be32(priv->chan[ch].reg + TALITOS_DESCBUF));
 
 	switch (desc_hdr & DESC_HDR_SEL0_MASK) {
 	case DESC_HDR_SEL0_AFEU:
-- 
2.27.0



