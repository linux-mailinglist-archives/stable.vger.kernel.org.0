Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB043C4504
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhGLGXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234110AbhGLGVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88BFA610CD;
        Mon, 12 Jul 2021 06:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070734;
        bh=74xzt05qMpxL9HP0JbjXN2a93+3P8I224lauiDtI4N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDCJZtfZpnsdzhUBkeyQbOknpEa6HoFiEZQSkVlsNbPlNkcW118FIJpLlbaUm6tLi
         SVYtYTg3BDSwpeYDw+XJ1afblYpYwhWP+0Vs0GMQV5+iUi5IyiFN0AngyiHYTxKm4m
         FjDtKETKuHVSMzPDFC1rLdyBvEytp9C7qnNt5VIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tian Tao <tiantao6@hisilicon.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/348] spi: omap-100k: Fix the length judgment problem
Date:   Mon, 12 Jul 2021 08:07:38 +0200
Message-Id: <20210712060711.755851547@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b8e201c09484..f64d030c760a 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -242,7 +242,7 @@ static int omap1_spi100k_setup_transfer(struct spi_device *spi,
 	else
 		word_len = spi->bits_per_word;
 
-	if (spi->bits_per_word > 32)
+	if (word_len > 32)
 		return -EINVAL;
 	cs->word_len = word_len;
 
-- 
2.30.2



