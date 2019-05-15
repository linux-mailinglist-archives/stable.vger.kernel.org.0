Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2286C1F1B2
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbfEOLRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbfEOLRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:17:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1D9420644;
        Wed, 15 May 2019 11:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919027;
        bh=OGmgcPDYmpGZoe6b7p5Kka/NjwDpmejKew+gZBRRk08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NN5r6cwpiuVubtn3Zc5OTQKExrNtnafFO2z4IIF/uqrytlnjusR0+MS5rBs0gPhMI
         fUZ6nNGASMeauvCIq8EoHLrUfDwd+yREwEXVgLAONUhj1KMPKSbinwJ3ElGbgnG9+c
         p+GgyJhw/f++wEYiso2SQEtUrGr77jxMksJzPtDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Daniel Gomez <dagmcr@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 038/115] spi: ST ST95HF NFC: declare missing of table
Date:   Wed, 15 May 2019 12:55:18 +0200
Message-Id: <20190515090702.220165255@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d04830531d0c4a99c897a44038e5da3d23331d2f ]

Add missing <of_device_id> table for SPI driver relying on SPI
device match since compatible is in a DT binding or in a DTS.

Before this patch:
modinfo drivers/nfc/st95hf/st95hf.ko | grep alias
alias:          spi:st95hf

After this patch:
modinfo drivers/nfc/st95hf/st95hf.ko | grep alias
alias:          spi:st95hf
alias:          of:N*T*Cst,st95hfC*
alias:          of:N*T*Cst,st95hf

Reported-by: Javier Martinez Canillas <javier@dowhile0.org>
Signed-off-by: Daniel Gomez <dagmcr@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st95hf/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 2b26f762fbc3b..01acb6e533655 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -1074,6 +1074,12 @@ static const struct spi_device_id st95hf_id[] = {
 };
 MODULE_DEVICE_TABLE(spi, st95hf_id);
 
+static const struct of_device_id st95hf_spi_of_match[] = {
+        { .compatible = "st,st95hf" },
+        { },
+};
+MODULE_DEVICE_TABLE(of, st95hf_spi_of_match);
+
 static int st95hf_probe(struct spi_device *nfc_spi_dev)
 {
 	int ret;
@@ -1260,6 +1266,7 @@ static struct spi_driver st95hf_driver = {
 	.driver = {
 		.name = "st95hf",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(st95hf_spi_of_match),
 	},
 	.id_table = st95hf_id,
 	.probe = st95hf_probe,
-- 
2.20.1



