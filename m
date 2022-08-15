Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D442594368
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350252AbiHOWjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350452AbiHOWgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:36:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BF35A2CC;
        Mon, 15 Aug 2022 12:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6299BB80EAD;
        Mon, 15 Aug 2022 19:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8ABFC433D6;
        Mon, 15 Aug 2022 19:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593014;
        bh=trG8oyJvYdJGnFL4oAnns9pnq+hwSnbarSZgSlzOSAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ki27J9mOd0GfVFehM2nCgArNcaIS6EJWUvWYelBJZeLB5r2B336+iqSzYM1oqxOQU
         gyQttrh5nI1yd5juUltruugVa43FA/PhysgBa6YIY/Fcn5UwRFWHu3CzuRR7JxS4sO
         pjoTv00s8NRwXzxTFbGrEwjePDeXd/re7MIhW+pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0200/1157] spi: spi-altera-dfl: Fix an error handling path
Date:   Mon, 15 Aug 2022 19:52:36 +0200
Message-Id: <20220815180447.683159381@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 8e3ca32f46994e74b7f43c57731150b2aedb2630 ]

The spi_alloc_master() call is not undone in all error handling paths.
Moreover, there is no .remove function to release the allocated memory.

In order to fix both this issues, switch to devm_spi_alloc_master().

This allows further simplification of the probe.

Fixes: ba2fc167e944 ("spi: altera: Add DFL bus driver for Altera API Controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/0607bb59f4073f86abe5c585d35245aef0b045c6.1653805901.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-altera-dfl.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-altera-dfl.c b/drivers/spi/spi-altera-dfl.c
index ca40923258af..596e181ae136 100644
--- a/drivers/spi/spi-altera-dfl.c
+++ b/drivers/spi/spi-altera-dfl.c
@@ -128,9 +128,9 @@ static int dfl_spi_altera_probe(struct dfl_device *dfl_dev)
 	struct spi_master *master;
 	struct altera_spi *hw;
 	void __iomem *base;
-	int err = -ENODEV;
+	int err;
 
-	master = spi_alloc_master(dev, sizeof(struct altera_spi));
+	master = devm_spi_alloc_master(dev, sizeof(struct altera_spi));
 	if (!master)
 		return -ENOMEM;
 
@@ -159,10 +159,9 @@ static int dfl_spi_altera_probe(struct dfl_device *dfl_dev)
 	altera_spi_init_master(master);
 
 	err = devm_spi_register_master(dev, master);
-	if (err) {
-		dev_err(dev, "%s failed to register spi master %d\n", __func__, err);
-		goto exit;
-	}
+	if (err)
+		return dev_err_probe(dev, err, "%s failed to register spi master\n",
+				     __func__);
 
 	if (dfl_dev->revision == FME_FEATURE_REV_MAX10_SPI_N5010)
 		strscpy(board_info.modalias, "m10-n5010", SPI_NAME_SIZE);
@@ -179,9 +178,6 @@ static int dfl_spi_altera_probe(struct dfl_device *dfl_dev)
 	}
 
 	return 0;
-exit:
-	spi_master_put(master);
-	return err;
 }
 
 static const struct dfl_device_id dfl_spi_altera_ids[] = {
-- 
2.35.1



