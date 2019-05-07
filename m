Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E542E15BB3
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfEGFhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbfEGFhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42A920578;
        Tue,  7 May 2019 05:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207464;
        bh=EiAGYo1E9SxfPaS0i1ndJq2wTAwaTy0SAsYy7NBE9E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6HQS+K2Rw5Xt5FFvV3vBPfmzpZ/Ld5kBYA2vQGt7ccCLP7iVTDVX2kgqvo5tD3Ea
         u6hjUYD1REZ7/zx+whyu0fSDZ7FhwZ6MGAQCG/xUq87/H0p72zSNJty2OupHVOovlw
         o/37sCJGgrlwdFrJjESXKMG5QlOM7fHq2SCb3BCQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Gomez <dagmcr@gmail.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 57/81] spi: ST ST95HF NFC: declare missing of table
Date:   Tue,  7 May 2019 01:35:28 -0400
Message-Id: <20190507053554.30848-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Gomez <dagmcr@gmail.com>

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
index 2b26f762fbc3..01acb6e53365 100644
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

