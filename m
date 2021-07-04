Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1D93BB1BA
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhGDXMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232702AbhGDXLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D249661963;
        Sun,  4 Jul 2021 23:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440106;
        bh=D1SZFDaMxPzzvYQFmKOyEyui/MyeIasJrxDmGU7ek9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyIa7d+4YavUOjK/aROMH7JMeYTCbWT8MquIT5bzWLiZP8bvM8V2/3sIl9dSTc3et
         c5+5hVPBfzImTYehip8C0sAoKKHBXmMr4pczJliDg/kedlP9miTLcORGDctCjvhPEf
         dpuiMBC6ifP1MtaGHGb2bWw8a4qPT3tEBl6oMdb7uMShStgtW1IPOv33sBdu+swTBd
         xfU45lS8Ty83vd0/APADSF4LunapjMd8R3K6mMWhjNBCT/TwG8Tghf1kShQv2/7uWM
         9e/VH4yXOyLKcDoUPG9iFTumHQeoyfUtFrHV5nWu5xWFDFtKOXX7bPhysKPnsNOpNJ
         uI+YvWl9NMsvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/70] spi: omap-100k: Fix the length judgment problem
Date:   Sun,  4 Jul 2021 19:07:10 -0400
Message-Id: <20210704230804.1490078-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>

[ Upstream commit e7a1a3abea373e41ba7dfe0fbc93cb79b6a3a529 ]

word_len should be checked in the omap1_spi100k_setup_transfer
function to see if it exceeds 32.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Link: https://lore.kernel.org/r/1619695248-39045-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap-100k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index ccd817ee4917..0d0cd061d356 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -241,7 +241,7 @@ static int omap1_spi100k_setup_transfer(struct spi_device *spi,
 	else
 		word_len = spi->bits_per_word;
 
-	if (spi->bits_per_word > 32)
+	if (word_len > 32)
 		return -EINVAL;
 	cs->word_len = word_len;
 
-- 
2.30.2

