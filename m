Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBB12E3F55
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392098AbgL1Oip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392093AbgL1Obo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26E9820715;
        Mon, 28 Dec 2020 14:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165863;
        bh=LOnALXAwccCD9RXii7ICJ5jy51cug5E67HC3V0KiZps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08+NItALbpZjAf/OcZqrbbg6EyuV7UAfUnVdzjrkswTp9Tb+aAgUDGyp6Xf95lvUV
         Wkb1jc7c/iE025GV2CvJNILU3k9aNFj3Q5ST9WSHjxoelwIGf90qYVQhAgLPq8YqwU
         gCC1PE4lP3xrY25E0R1GOQICwRuZueOXEFmtHD5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 650/717] spi: npcm-fiu: Disable clock in probe error path
Date:   Mon, 28 Dec 2020 13:50:48 +0100
Message-Id: <20201228125052.090332666@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 234266a5168bbe8220d263e3aa7aa80cf921c483 upstream.

If the call to devm_spi_register_master() fails on probe of the NPCM FIU
SPI driver, the clock "fiu->clk" is erroneously not unprepared and
disabled.  Fix it.

Fixes: ace55c411b11 ("spi: npcm-fiu: add NPCM FIU controller driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Tomer Maimon <tmaimon77@gmail.com>
Link: https://lore.kernel.org/r/9ae62f4e1cfe542bec57ac2743e6fca9f9548f55.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-npcm-fiu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -677,7 +677,7 @@ static int npcm_fiu_probe(struct platfor
 	struct npcm_fiu_spi *fiu;
 	void __iomem *regbase;
 	struct resource *res;
-	int id;
+	int id, ret;
 
 	ctrl = devm_spi_alloc_master(dev, sizeof(*fiu));
 	if (!ctrl)
@@ -735,7 +735,11 @@ static int npcm_fiu_probe(struct platfor
 	ctrl->num_chipselect = fiu->info->max_cs;
 	ctrl->dev.of_node = dev->of_node;
 
-	return devm_spi_register_master(dev, ctrl);
+	ret = devm_spi_register_master(dev, ctrl);
+	if (ret)
+		clk_disable_unprepare(fiu->clk);
+
+	return ret;
 }
 
 static int npcm_fiu_remove(struct platform_device *pdev)


