Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B272C0A53
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbgKWMjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:39:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732324AbgKWMjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30D082076E;
        Mon, 23 Nov 2020 12:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135183;
        bh=zhvzN87Fa32w8zG5NZxmYcOn+hF5t93T3wTMiQDu4+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qL4v3MVMX3ch7uPmeYkmWLwwPyBtFB5WOBMp73ro5wY5O5xus4L6+CU3NJwV6/KwF
         cPLldAywzpGNe3XLaCjdjTQQksrJlG9Wi7FjgcDcC6TJA7Fg8I+FMZtw2xK96NDlOq
         hNeG4ZHya9wpoPfYxewn+yUmElq8+JYcpeMxFM1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 135/158] spi: npcm-fiu: Dont leak SPI master in probe error path
Date:   Mon, 23 Nov 2020 13:22:43 +0100
Message-Id: <20201123121826.444823000@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 04a9cd51d3f3308a98cbc6adc07acb12fbade011 upstream.

If the calls to of_match_device(), of_alias_get_id(),
devm_ioremap_resource(), devm_regmap_init_mmio() or devm_clk_get()
fail on probe of the NPCM FIU SPI driver, the spi_controller struct is
erroneously not freed.

Fix by switching over to the new devm_spi_alloc_master() helper.

Fixes: ace55c411b11 ("spi: npcm-fiu: add NPCM FIU controller driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.4+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Tomer Maimon <tmaimon77@gmail.com>
Link: https://lore.kernel.org/r/a420c23a363a3bc9aa684c6e790c32a8af106d17.1605512876.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-npcm-fiu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -680,7 +680,7 @@ static int npcm_fiu_probe(struct platfor
 	int ret;
 	int id;
 
-	ctrl = spi_alloc_master(dev, sizeof(*fiu));
+	ctrl = devm_spi_alloc_master(dev, sizeof(*fiu));
 	if (!ctrl)
 		return -ENOMEM;
 


