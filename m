Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A481D29B511
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793723AbgJ0PIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1791000AbgJ0PFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:05:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E0F121D24;
        Tue, 27 Oct 2020 15:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811143;
        bh=l4vVEA+YL8NQ1DFUC4El5nHkJVhc94FNNUke2RJ9F4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPhbelA8A9+Esjgm9qiaNcz9NgAVzv7gXMYEWVlUyKdFlQvZ8zkMTA20ZGwJV8jDm
         UN9uOU3poua5HQXGptf8ksAgqNB5u0tFPh36Q2Pgq5VJdc4oN6iaWavN1MbbMPTTiL
         vOtVkniopqbzdDMeV6LIg4uF3iNipCAF026cD+6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Kerello <christophe.kerello@st.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 389/633] mtd: rawnand: stm32_fmc2: fix a buffer overflow
Date:   Tue, 27 Oct 2020 14:52:12 +0100
Message-Id: <20201027135540.951081132@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Kerello <christophe.kerello@st.com>

[ Upstream commit ab16f54ef3cdb6bbc06a36f636a89e6db8a6cea3 ]

This patch solves following static checker warning:
drivers/mtd/nand/raw/stm32_fmc2_nand.c:350 stm32_fmc2_nfc_select_chip()
error: buffer overflow 'nfc->data_phys_addr' 2 <= 2

The CS value can only be 0 or 1.

Signed-off-by: Christophe Kerello <christophe.kerello@st.com>
Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash controller driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/1595325127-32693-1-git-send-email-christophe.kerello@st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/stm32_fmc2_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/stm32_fmc2_nand.c b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
index 65c9d17b25a3c..dce6d7a10a364 100644
--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -1791,7 +1791,7 @@ static int stm32_fmc2_nfc_parse_child(struct stm32_fmc2_nfc *nfc,
 			return ret;
 		}
 
-		if (cs > FMC2_MAX_CE) {
+		if (cs >= FMC2_MAX_CE) {
 			dev_err(nfc->dev, "invalid reg value: %d\n", cs);
 			return -EINVAL;
 		}
-- 
2.25.1



