Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE7A1C16C9
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgEANxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730897AbgEANgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72CFD216FD;
        Fri,  1 May 2020 13:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340207;
        bh=VzIi27zHtCFvQBF4AgI2T1BoOw7V/A9AHibylt2E0mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSBHTtJ40GcbLtOzYrTmWqCy0zYXukWIA/f10CGuh6jO3aDon34FuJvnYxMNNULSa
         tg1H3ZTAXYrnFOjcA2nKZKvIOE5zQQ64w3OWxsFkWvefH3W+M6WysgU5d1WDJYC/uU
         FtAlKnYnQdTywoT5gJq1LWDvxg7jLB8XMzqppnUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Puschmann <p.puschmann@pironex.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 09/46] ASoC: tas571x: disable regulators on failed probe
Date:   Fri,  1 May 2020 15:22:34 +0200
Message-Id: <20200501131502.366728597@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Puschmann <p.puschmann@pironex.de>

commit 9df8ba7c63073508e5aa677dade48fcab6a6773e upstream.

If probe fails after enabling the regulators regulator_put is called for
each supply without having them disabled before. This produces some
warnings like

WARNING: CPU: 0 PID: 90 at drivers/regulator/core.c:2044 _regulator_put.part.0+0x154/0x15c
[<c010f7a8>] (unwind_backtrace) from [<c010c544>] (show_stack+0x10/0x14)
[<c010c544>] (show_stack) from [<c012b640>] (__warn+0xd0/0xf4)
[<c012b640>] (__warn) from [<c012b9b4>] (warn_slowpath_fmt+0x64/0xc4)
[<c012b9b4>] (warn_slowpath_fmt) from [<c04c4064>] (_regulator_put.part.0+0x154/0x15c)
[<c04c4064>] (_regulator_put.part.0) from [<c04c4094>] (regulator_put+0x28/0x38)
[<c04c4094>] (regulator_put) from [<c04c40cc>] (regulator_bulk_free+0x28/0x38)
[<c04c40cc>] (regulator_bulk_free) from [<c0579b2c>] (release_nodes+0x1d0/0x22c)
[<c0579b2c>] (release_nodes) from [<c05756dc>] (really_probe+0x108/0x34c)
[<c05756dc>] (really_probe) from [<c0575aec>] (driver_probe_device+0xb8/0x16c)
[<c0575aec>] (driver_probe_device) from [<c0575d40>] (device_driver_attach+0x58/0x60)
[<c0575d40>] (device_driver_attach) from [<c0575da0>] (__driver_attach+0x58/0xcc)
[<c0575da0>] (__driver_attach) from [<c0573978>] (bus_for_each_dev+0x78/0xc0)
[<c0573978>] (bus_for_each_dev) from [<c0574b5c>] (bus_add_driver+0x188/0x1e0)
[<c0574b5c>] (bus_add_driver) from [<c05768b0>] (driver_register+0x74/0x108)
[<c05768b0>] (driver_register) from [<c061ab7c>] (i2c_register_driver+0x3c/0x88)
[<c061ab7c>] (i2c_register_driver) from [<c0102df8>] (do_one_initcall+0x58/0x250)
[<c0102df8>] (do_one_initcall) from [<c01a91bc>] (do_init_module+0x60/0x244)
[<c01a91bc>] (do_init_module) from [<c01ab5a4>] (load_module+0x2180/0x2540)
[<c01ab5a4>] (load_module) from [<c01abbd4>] (sys_finit_module+0xd0/0xe8)
[<c01abbd4>] (sys_finit_module) from [<c01011e0>] (__sys_trace_return+0x0/0x20)

Fixes: 3fd6e7d9a146 (ASoC: tas571x: New driver for TI TAS571x power amplifiers)
Signed-off-by: Philipp Puschmann <p.puschmann@pironex.de>
Link: https://lore.kernel.org/r/20200414112754.3365406-1-p.puschmann@pironex.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tas571x.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/tas571x.c
+++ b/sound/soc/codecs/tas571x.c
@@ -824,8 +824,10 @@ static int tas571x_i2c_probe(struct i2c_
 
 	priv->regmap = devm_regmap_init(dev, NULL, client,
 					priv->chip->regmap_config);
-	if (IS_ERR(priv->regmap))
-		return PTR_ERR(priv->regmap);
+	if (IS_ERR(priv->regmap)) {
+		ret = PTR_ERR(priv->regmap);
+		goto disable_regs;
+	}
 
 	priv->pdn_gpio = devm_gpiod_get_optional(dev, "pdn", GPIOD_OUT_LOW);
 	if (IS_ERR(priv->pdn_gpio)) {
@@ -849,7 +851,7 @@ static int tas571x_i2c_probe(struct i2c_
 
 	ret = regmap_write(priv->regmap, TAS571X_OSC_TRIM_REG, 0);
 	if (ret)
-		return ret;
+		goto disable_regs;
 
 	usleep_range(50000, 60000);
 
@@ -865,12 +867,20 @@ static int tas571x_i2c_probe(struct i2c_
 		 */
 		ret = regmap_update_bits(priv->regmap, TAS571X_MVOL_REG, 1, 0);
 		if (ret)
-			return ret;
+			goto disable_regs;
 	}
 
-	return devm_snd_soc_register_component(&client->dev,
+	ret = devm_snd_soc_register_component(&client->dev,
 				      &priv->component_driver,
 				      &tas571x_dai, 1);
+	if (ret)
+		goto disable_regs;
+
+	return ret;
+
+disable_regs:
+	regulator_bulk_disable(priv->chip->num_supply_names, priv->supplies);
+	return ret;
 }
 
 static int tas571x_i2c_remove(struct i2c_client *client)


