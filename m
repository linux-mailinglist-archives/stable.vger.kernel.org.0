Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637BD1F30D5
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbgFIBDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727946AbgFHXHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E56B2087E;
        Mon,  8 Jun 2020 23:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657656;
        bh=1S5Q9TpFA1WJBMNsZ9T26wr84UeMbZz/aKxvsdAw2F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=km9GvmngdZq79C+MzaGB8nqr2G2hUBnj764Y6Zvkg9+Zad9q6VXVq+tQZO+tGbLA6
         0uGO41lNP0N3zDpyaSyAzmzRmYIu0dz/taCQ5p/XlEw9tGkXFwH3A2AZUj3Owmu4c5
         VxKXWEhxvsY9Yu+UdwX4e49GE/6BuCMK+juDu/0E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Rosin <peda@axentia.se>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 069/274] spi: mux: repair mux usage
Date:   Mon,  8 Jun 2020 19:02:42 -0400
Message-Id: <20200608230607.3361041-69-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

[ Upstream commit a2b02e4623fb127fa65a13e4ac5aa56e4ae16291 ]

It is not valid to cache/short out selection of the mux.

mux_control_select() only locks the mux until mux_control_deselect()
is called. mux_control_deselect() may put the mux in some low power
state or some other user of the mux might select it for other purposes.
These things are probably not happening in the original setting where
this driver was developed, but it is said to be a generic SPI mux.

Also, the mux framework will short out the actual low level muxing
operation when/if that is possible.

Fixes: e9e40543ad5b ("spi: Add generic SPI multiplexer")
Signed-off-by: Peter Rosin <peda@axentia.se>
Link: https://lore.kernel.org/r/20200525104352.26807-1-peda@axentia.se
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mux.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-mux.c b/drivers/spi/spi-mux.c
index 4f94c9127fc1..cc9ef371db14 100644
--- a/drivers/spi/spi-mux.c
+++ b/drivers/spi/spi-mux.c
@@ -51,6 +51,10 @@ static int spi_mux_select(struct spi_device *spi)
 	struct spi_mux_priv *priv = spi_controller_get_devdata(spi->controller);
 	int ret;
 
+	ret = mux_control_select(priv->mux, spi->chip_select);
+	if (ret)
+		return ret;
+
 	if (priv->current_cs == spi->chip_select)
 		return 0;
 
@@ -62,10 +66,6 @@ static int spi_mux_select(struct spi_device *spi)
 	priv->spi->mode = spi->mode;
 	priv->spi->bits_per_word = spi->bits_per_word;
 
-	ret = mux_control_select(priv->mux, spi->chip_select);
-	if (ret)
-		return ret;
-
 	priv->current_cs = spi->chip_select;
 
 	return 0;
-- 
2.25.1

