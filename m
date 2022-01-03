Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5183448322A
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiACOZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:25:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55790 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiACOZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:25:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FA1461115;
        Mon,  3 Jan 2022 14:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA01DC36AEB;
        Mon,  3 Jan 2022 14:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219913;
        bh=nH09yIs0wax0PiA9uNlgRbWcT4YBReLap6tdfJiFY6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4/FpnkQJXRTk2RjmCYviBj0ZGNYEk1JbMD53CxcSLXekZUzP2XfezSvza39NeBV7
         pw/vSnHM+oRxdtk+g5nGUCwJDn75QZObZlz0nqsiMB/dVJgzmZjgH9nEyVdVc93r1m
         c/rO7il8SCyKYj5z/Aaae8768V6jFSlzLReFgJFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/27] fsl/fman: Fix missing put_device() call in fman_port_probe
Date:   Mon,  3 Jan 2022 15:23:56 +0100
Message-Id: <20220103142052.702175502@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit bf2b09fedc17248b315f80fb249087b7d28a69a6 ]

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the and error handling paths.

Fixes: 18a6c85fcc78 ("fsl/fman: Add FMan Port Support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/fman_port.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index 47f6fee1f3964..1812434cda847 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1791,7 +1791,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	fman = dev_get_drvdata(&fm_pdev->dev);
 	if (!fman) {
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	err = of_property_read_u32(port_node, "cell-index", &val);
@@ -1799,7 +1799,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: reading cell-index for %pOF failed\n",
 			__func__, port_node);
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 	port_id = (u8)val;
 	port->dts_params.id = port_id;
@@ -1833,7 +1833,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	}  else {
 		dev_err(port->dev, "%s: Illegal port type\n", __func__);
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	port->dts_params.type = port_type;
@@ -1847,7 +1847,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 			dev_err(port->dev, "%s: incorrect qman-channel-id\n",
 				__func__);
 			err = -EINVAL;
-			goto return_err;
+			goto put_device;
 		}
 		port->dts_params.qman_channel_id = qman_channel_id;
 	}
@@ -1857,7 +1857,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: of_address_to_resource() failed\n",
 			__func__);
 		err = -ENOMEM;
-		goto return_err;
+		goto put_device;
 	}
 
 	port->dts_params.fman = fman;
@@ -1882,6 +1882,8 @@ static int fman_port_probe(struct platform_device *of_dev)
 
 	return 0;
 
+put_device:
+	put_device(&fm_pdev->dev);
 return_err:
 	of_node_put(port_node);
 free_port:
-- 
2.34.1



