Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49E42C0928
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387611AbgKWNEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:04:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387605AbgKWMvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B99B20732;
        Mon, 23 Nov 2020 12:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135855;
        bh=zhvzN87Fa32w8zG5NZxmYcOn+hF5t93T3wTMiQDu4+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/fwkrCIZdiRgdBBooTi7KMtTVwAJ64Fzv28qMBaXkim8q1r9mii24RvUJt1Rqpao
         DS9FPdkYlf5COXZfrqIsO59L05yOiVHTNQjiH6el1b6co8sxFd8sXjQOvfB/SGZLeC
         kuGTz7ogL2CVd20gfdO7OTxiJOm1EplBRYC2WdbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.9 220/252] spi: npcm-fiu: Dont leak SPI master in probe error path
Date:   Mon, 23 Nov 2020 13:22:50 +0100
Message-Id: <20201123121846.191628060@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
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
 


