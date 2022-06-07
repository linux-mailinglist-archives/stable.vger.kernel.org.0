Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C5C541307
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357579AbiFGTzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358934AbiFGTxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:53:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35DB15FC9;
        Tue,  7 Jun 2022 11:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33964611F3;
        Tue,  7 Jun 2022 18:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F6BC3411C;
        Tue,  7 Jun 2022 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626188;
        bh=/InOPiu2XYNxPR18RxUQfT0MYUGAQP/jnNaUcz1M8Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9y3aWYuqdkFuFEO/R87PYwtBAqnW85BuKH/qEXQ4VmhBSvr+f2LOZZrELwu1V7R6
         UwmWpkRK5myp3VCPtNPgVU+nxC5PJvThPR6nC+NdbVL4EZw00CSVRmzwe7SJp54dsj
         Hl3xF3lDipB12StfE+OocueRyOlyWHH9M03J8t+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 287/772] media: i2c: max9286: fix kernel oops when removing module
Date:   Tue,  7 Jun 2022 18:57:59 +0200
Message-Id: <20220607164957.482427004@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>

[ Upstream commit 365ab7ebc24eebb42b9e020aeb440d51af8960cd ]

When removing the max9286 module we get a kernel oops:

Unable to handle kernel paging request at virtual address 000000aa00000094
Mem abort info:
  ESR = 0x96000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000880d85000
[000000aa00000094] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in: fsl_jr_uio caam_jr rng_core libdes caamkeyblob_desc caamhash_desc caamalg_desc crypto_engine max9271 authenc crct10dif_ce mxc_jpeg_encdec
CPU: 2 PID: 713 Comm: rmmod Tainted: G         C        5.15.5-00057-gaebcd29c8ed7-dirty #5
Hardware name: Freescale i.MX8QXP MEK (DT)
pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : i2c_mux_del_adapters+0x24/0xf0
lr : max9286_remove+0x28/0xd0 [max9286]
sp : ffff800013a9bbf0
x29: ffff800013a9bbf0 x28: ffff00080b6da940 x27: 0000000000000000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: ffff000801a5b970 x22: ffff0008048b0890 x21: ffff800009297000
x20: ffff0008048b0f70 x19: 000000aa00000064 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000014 x13: 0000000000000000 x12: ffff000802da49e8
x11: ffff000802051918 x10: ffff000802da4920 x9 : ffff000800030098
x8 : 0101010101010101 x7 : 7f7f7f7f7f7f7f7f x6 : fefefeff6364626d
x5 : 8080808000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : ffffffffffffffff x1 : ffff00080b6da940 x0 : 0000000000000000
Call trace:
 i2c_mux_del_adapters+0x24/0xf0
 max9286_remove+0x28/0xd0 [max9286]
 i2c_device_remove+0x40/0x110
 __device_release_driver+0x188/0x234
 driver_detach+0xc4/0x150
 bus_remove_driver+0x60/0xe0
 driver_unregister+0x34/0x64
 i2c_del_driver+0x58/0xa0
 max9286_i2c_driver_exit+0x1c/0x490 [max9286]
 __arm64_sys_delete_module+0x194/0x260
 invoke_syscall+0x48/0x114
 el0_svc_common.constprop.0+0xd4/0xfc
 do_el0_svc+0x2c/0x94
 el0_svc+0x28/0x80
 el0t_64_sync_handler+0xa8/0x130
 el0t_64_sync+0x1a0/0x1a4

The Oops happens because the I2C client data does not point to
max9286_priv anymore but to v4l2_subdev. The change happened in
max9286_init() which calls v4l2_i2c_subdev_init() later on...

Besides fixing the max9286_remove() function, remove the call to
i2c_set_clientdata() in max9286_probe(), to avoid confusion, and make
the necessary changes to max9286_init() so that it doesn't have to use
i2c_get_clientdata() in order to fetch the pointer to priv.

Fixes: 66d8c9d2422d ("media: i2c: Add MAX9286 driver")
Signed-off-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max9286.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
index c572eec54044..07e98d57e323 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -1142,22 +1142,18 @@ static int max9286_poc_enable(struct max9286_priv *priv, bool enable)
 	return ret;
 }
 
-static int max9286_init(struct device *dev)
+static int max9286_init(struct max9286_priv *priv)
 {
-	struct max9286_priv *priv;
-	struct i2c_client *client;
+	struct i2c_client *client = priv->client;
 	int ret;
 
-	client = to_i2c_client(dev);
-	priv = i2c_get_clientdata(client);
-
 	ret = max9286_poc_enable(priv, true);
 	if (ret)
 		return ret;
 
 	ret = max9286_setup(priv);
 	if (ret) {
-		dev_err(dev, "Unable to setup max9286\n");
+		dev_err(&client->dev, "Unable to setup max9286\n");
 		goto err_poc_disable;
 	}
 
@@ -1167,13 +1163,13 @@ static int max9286_init(struct device *dev)
 	 */
 	ret = max9286_v4l2_register(priv);
 	if (ret) {
-		dev_err(dev, "Failed to register with V4L2\n");
+		dev_err(&client->dev, "Failed to register with V4L2\n");
 		goto err_poc_disable;
 	}
 
 	ret = max9286_i2c_mux_init(priv);
 	if (ret) {
-		dev_err(dev, "Unable to initialize I2C multiplexer\n");
+		dev_err(&client->dev, "Unable to initialize I2C multiplexer\n");
 		goto err_v4l2_register;
 	}
 
@@ -1328,7 +1324,6 @@ static int max9286_probe(struct i2c_client *client)
 	mutex_init(&priv->mutex);
 
 	priv->client = client;
-	i2c_set_clientdata(client, priv);
 
 	priv->gpiod_pwdn = devm_gpiod_get_optional(&client->dev, "enable",
 						   GPIOD_OUT_HIGH);
@@ -1364,7 +1359,7 @@ static int max9286_probe(struct i2c_client *client)
 	if (ret)
 		goto err_powerdown;
 
-	ret = max9286_init(&client->dev);
+	ret = max9286_init(priv);
 	if (ret < 0)
 		goto err_cleanup_dt;
 
@@ -1380,7 +1375,7 @@ static int max9286_probe(struct i2c_client *client)
 
 static int max9286_remove(struct i2c_client *client)
 {
-	struct max9286_priv *priv = i2c_get_clientdata(client);
+	struct max9286_priv *priv = sd_to_max9286(i2c_get_clientdata(client));
 
 	i2c_mux_del_adapters(priv->mux);
 
-- 
2.35.1



