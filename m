Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A14912C765
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbfL2R2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbfL2R2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:28:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76961222D9;
        Sun, 29 Dec 2019 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640522;
        bh=OEryQMCDO0h3nxDcpCjCIVho6fs03Rb0teB4tkP6A74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgxpEeHqhzOoBFsyrbwa5m+Xv1iEAvt7BtVcJafxs1ipQ2GWhy0AB55mTRuMC/u/o
         bMPBEw8Uyd8XBcEsSup6B54NFKYmw3AfjinvrruxAErRgyf/8V2P3nQR5oZMf3e9Bd
         HmUvoVE7OCDH3KHkrA2QvsVx5jijj1EYhDHfSPjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Wilczynski <kw@linux.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/219] iio: light: bh1750: Resolve compiler warning and make code more readable
Date:   Sun, 29 Dec 2019 18:17:12 +0100
Message-Id: <20191229162513.029169275@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Wilczynski <kw@linux.com>

[ Upstream commit f552fde983d378e7339f9ea74a25f918563bf0d3 ]

Separate the declaration of struct bh1750_chip_info from definition
of bh1750_chip_info_tbl[] in a single statement as it makes the code
hard to read, and with the extra newline it makes it look as if the
bh1750_chip_info_tbl[] had no explicit type.

This change also resolves the following compiler warning about the
unusual position of the static keyword that can be seen when building
with warnings enabled (W=1):

drivers/iio/light/bh1750.c:64:1: warning:
  ‘static’ is not at beginning of declaration [-Wold-style-declaration]

Related to commit 3a11fbb037a1 ("iio: light: add support for ROHM
BH1710/BH1715/BH1721/BH1750/BH1751 ambient light sensors").

Signed-off-by: Krzysztof Wilczynski <kw@linux.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/bh1750.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/bh1750.c b/drivers/iio/light/bh1750.c
index a814828e69f5..5f5d54ce882b 100644
--- a/drivers/iio/light/bh1750.c
+++ b/drivers/iio/light/bh1750.c
@@ -62,9 +62,9 @@ struct bh1750_chip_info {
 
 	u16 int_time_low_mask;
 	u16 int_time_high_mask;
-}
+};
 
-static const bh1750_chip_info_tbl[] = {
+static const struct bh1750_chip_info bh1750_chip_info_tbl[] = {
 	[BH1710] = { 140, 1022, 300, 400,  250000000, 2, 0x001F, 0x03E0 },
 	[BH1721] = { 140, 1020, 300, 400,  250000000, 2, 0x0010, 0x03E0 },
 	[BH1750] = { 31,  254,  69,  1740, 57500000,  1, 0x001F, 0x00E0 },
-- 
2.20.1



