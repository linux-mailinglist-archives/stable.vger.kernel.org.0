Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A7F201309
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392634AbgFSPT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389683AbgFSPTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C8BE218AC;
        Fri, 19 Jun 2020 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579944;
        bh=1S5Q9TpFA1WJBMNsZ9T26wr84UeMbZz/aKxvsdAw2F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZDxD//+b+VQW/H2E5MQcf4g5IlK7sNA6JwuzyrC8tiN03A0UwEBDBMZui00ToiTz
         9r5wLwrQY4J4jcHW5fE77hOLtJKIN9Wyanmv8KSB1S8OHBszXV9F/z04zR7VeDP+Kh
         v2ijLQ09jsj4G0dUOfHTsuznj9XY+IrzZAG5Izoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 064/376] spi: mux: repair mux usage
Date:   Fri, 19 Jun 2020 16:29:42 +0200
Message-Id: <20200619141713.384191146@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



