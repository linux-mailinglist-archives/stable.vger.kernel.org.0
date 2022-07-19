Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A728C579A9B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238720AbiGSMPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238882AbiGSMNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:13:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5757B1900B;
        Tue, 19 Jul 2022 05:04:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0EDF6173D;
        Tue, 19 Jul 2022 12:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DC0C341C6;
        Tue, 19 Jul 2022 12:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232244;
        bh=Gp0hYuhUtPpI2slSZ1jNHZ6CZOKc7M9FB2d/Lt6BXSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFCrotNpbUzKLBMsj3N3Sj6JfuocXSPYaXkt2uwiEqPLgMqmVBi8KBgRvbDvW9raJ
         sTal+u0tNVpzxlyVusQ4UXydtj6FIpojs+/3kAkq5QSeBdy4Nv2TxiXGEy51vDAn5D
         wmZeeoCP8hHayS00rRHIP99Gxnc8rOYyT42eh6mI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Fabio Estevam <festevam@denx.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/71] ASoC: sgtl5000: Fix noise on shutdown/remove
Date:   Tue, 19 Jul 2022 13:53:47 +0200
Message-Id: <20220719114554.577162129@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 040e3360af3736348112d29425bf5d0be5b93115 ]

Put the SGTL5000 in a silent/safe state on shutdown/remove, this is
required since the SGTL5000 produces a constant noise on its output
after it is configured and its clock is removed. Without this change
this is happening every time the module is unbound/removed or from
reboot till the clock is enabled again.

The issue was experienced on both a Toradex Colibri/Apalis iMX6, but can
be easily reproduced everywhere just playing something on the codec and
after that removing/unbinding the driver.

Fixes: 9b34e6cc3bc2 ("ASoC: Add Freescale SGTL5000 codec support")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Fabio Estevam <festevam@denx.de>
Link: https://lore.kernel.org/r/20220624101301.441314-1-francesco.dolcini@toradex.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sgtl5000.c | 9 +++++++++
 sound/soc/codecs/sgtl5000.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 8a1e485982d8..76d3c0681f37 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1788,6 +1788,9 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 {
 	struct sgtl5000_priv *sgtl5000 = i2c_get_clientdata(client);
 
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_DIG_POWER, SGTL5000_DIG_POWER_DEFAULT);
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_ANA_POWER, SGTL5000_ANA_POWER_DEFAULT);
+
 	clk_disable_unprepare(sgtl5000->mclk);
 	regulator_bulk_disable(sgtl5000->num_supplies, sgtl5000->supplies);
 	regulator_bulk_free(sgtl5000->num_supplies, sgtl5000->supplies);
@@ -1795,6 +1798,11 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
+static void sgtl5000_i2c_shutdown(struct i2c_client *client)
+{
+	sgtl5000_i2c_remove(client);
+}
+
 static const struct i2c_device_id sgtl5000_id[] = {
 	{"sgtl5000", 0},
 	{},
@@ -1815,6 +1823,7 @@ static struct i2c_driver sgtl5000_i2c_driver = {
 		   },
 	.probe = sgtl5000_i2c_probe,
 	.remove = sgtl5000_i2c_remove,
+	.shutdown = sgtl5000_i2c_shutdown,
 	.id_table = sgtl5000_id,
 };
 
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index 56ec5863f250..3a808c762299 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -80,6 +80,7 @@
 /*
  * SGTL5000_CHIP_DIG_POWER
  */
+#define SGTL5000_DIG_POWER_DEFAULT		0x0000
 #define SGTL5000_ADC_EN				0x0040
 #define SGTL5000_DAC_EN				0x0020
 #define SGTL5000_DAP_POWERUP			0x0010
-- 
2.35.1



