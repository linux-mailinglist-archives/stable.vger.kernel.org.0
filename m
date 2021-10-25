Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C8C43A212
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbhJYTpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235541AbhJYTnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:43:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50D1F6115B;
        Mon, 25 Oct 2021 19:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190654;
        bh=DWvVpaeqOMtcSi804xnPU2l1EgY76Kl8fNskxk+F6j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLu6tls9KMYX+7oUKhKYgMqiqMeroaHYN88HlaprhqvMSNFHb3gPxtxnj+NKkcKv7
         PdFfuXV0dqda/HaPz4HeP38y2RjpKboySaEB+d1HMhjSfr+G/QTKP8x07lmFZH6Lc/
         a80ptc0QNmZgqJAuAWw31vo/RkUBQNh3tOWw4KCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        patches@opensource.cirrus.com,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 021/169] ASoC: cs4341: Add SPI device ID table
Date:   Mon, 25 Oct 2021 21:13:22 +0200
Message-Id: <20211025191020.387736691@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 0cc3687eadd0971d5d38ff90d14819d88f854960 ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding SPI IDs for parts that
only have a compatible listed.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: patches@opensource.cirrus.com
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210924194844.45974-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs4341.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/cs4341.c b/sound/soc/codecs/cs4341.c
index 7d3e54d8eef3..29d05e32d341 100644
--- a/sound/soc/codecs/cs4341.c
+++ b/sound/soc/codecs/cs4341.c
@@ -305,12 +305,19 @@ static int cs4341_spi_probe(struct spi_device *spi)
 	return cs4341_probe(&spi->dev);
 }
 
+static const struct spi_device_id cs4341_spi_ids[] = {
+	{ "cs4341a" },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, cs4341_spi_ids);
+
 static struct spi_driver cs4341_spi_driver = {
 	.driver = {
 		.name = "cs4341-spi",
 		.of_match_table = of_match_ptr(cs4341_dt_ids),
 	},
 	.probe = cs4341_spi_probe,
+	.id_table = cs4341_spi_ids,
 };
 #endif
 
-- 
2.33.0



