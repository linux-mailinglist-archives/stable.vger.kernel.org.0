Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41D1390E9
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbfFGPzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730611AbfFGPpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 299582146E;
        Fri,  7 Jun 2019 15:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922315;
        bh=gbnX3ywF0e3V1x5CbjGk84uFpatjER0sEXlbfyLEBoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzPuMVGB9yk+OvPv3lwS6dVnWJ6AMVXY38F2mBdPKL8vhf2/OGGS5dKoRuv79Q6Ip
         m325kbRGbRSZ3GMfH2aYvnTPhz8AJE8/29Q5xXc40JO5apqjKhgo5dvZPiXtpKma84
         9nPPb1ghbp8bF4nfSX2k58Xq6Qq3yGBTpf5EJfvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@mellanox.com>,
        Wolfram Sang <wsa@the-dreams.de>, stable@kernel.org
Subject: [PATCH 4.19 36/73] i2c: mlxcpld: Fix wrong initialization order in probe
Date:   Fri,  7 Jun 2019 17:39:23 +0200
Message-Id: <20190607153853.136918240@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

commit 13067ef73f337336e3149f5bb9f3fd05fe7f87a0 upstream.

Fix wrong order in probing routine initialization - field `base_addr'
is used before it's initialized. Move assignment of 'priv->base_addr`
to the beginning, prior the call to mlxcpld_i2c_read_comm().
Wrong order caused the first read of capability register to be executed
at wrong offset 0x0 instead of 0x2000. By chance it was a "good
garbage" at 0x0 offset.

Fixes: 313ce648b5a4 ("i2c: mlxcpld: Add support for extended transaction length for i2c-mlxcpld")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-mlxcpld.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-mlxcpld.c
+++ b/drivers/i2c/busses/i2c-mlxcpld.c
@@ -503,6 +503,7 @@ static int mlxcpld_i2c_probe(struct plat
 	platform_set_drvdata(pdev, priv);
 
 	priv->dev = &pdev->dev;
+	priv->base_addr = MLXPLAT_CPLD_LPC_I2C_BASE_ADDR;
 
 	/* Register with i2c layer */
 	mlxcpld_i2c_adapter.timeout = usecs_to_jiffies(MLXCPLD_I2C_XFER_TO);
@@ -518,7 +519,6 @@ static int mlxcpld_i2c_probe(struct plat
 		mlxcpld_i2c_adapter.nr = pdev->id;
 	priv->adap = mlxcpld_i2c_adapter;
 	priv->adap.dev.parent = &pdev->dev;
-	priv->base_addr = MLXPLAT_CPLD_LPC_I2C_BASE_ADDR;
 	i2c_set_adapdata(&priv->adap, priv);
 
 	err = i2c_add_numbered_adapter(&priv->adap);


