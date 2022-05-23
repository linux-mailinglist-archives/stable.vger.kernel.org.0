Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3A8531925
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240970AbiEWRkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243626AbiEWRiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:38:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC2093996;
        Mon, 23 May 2022 10:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C97D5B81227;
        Mon, 23 May 2022 17:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93A6C385A9;
        Mon, 23 May 2022 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327105;
        bh=qSmR5E7RYaAZaARo/MP2Fh7BsQDVD2MLFAr7or8Gw0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RM3/KDte2kGxcg5Z7/TbM3wKSXB7amdjjhYKk5FECt8iJG8bfxUtZBgSfEYNHcVQU
         4GD5Ej8M/5swHpbxNZPyutJGezALppaMAYJsAsPO9dENZ8CUaHWFvuk41cw7CAsKon
         wFBFR7K6HH73dYHmcm5MTkyb5s6/e7nevzo2Znj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Stefan Roese <sr@denx.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 157/158] i2c: mt7621: fix missing clk_disable_unprepare() on error in mtk_i2c_probe()
Date:   Mon, 23 May 2022 19:05:14 +0200
Message-Id: <20220523165856.200911142@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a2537c98a8a3b57002e54a262d180b9490bc7190 ]

Fix the missing clk_disable_unprepare() before return
from mtk_i2c_probe() in the error handling case.

Fixes: d04913ec5f89 ("i2c: mt7621: Add MediaTek MT7621/7628/7688 I2C driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Stefan Roese <sr@denx.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt7621.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt7621.c b/drivers/i2c/busses/i2c-mt7621.c
index 45fe4a7fe0c0..901f0fb04fee 100644
--- a/drivers/i2c/busses/i2c-mt7621.c
+++ b/drivers/i2c/busses/i2c-mt7621.c
@@ -304,7 +304,8 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 
 	if (i2c->bus_freq == 0) {
 		dev_warn(i2c->dev, "clock-frequency 0 not supported\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_disable_clk;
 	}
 
 	adap = &i2c->adap;
@@ -322,10 +323,15 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 
 	ret = i2c_add_adapter(adap);
 	if (ret < 0)
-		return ret;
+		goto err_disable_clk;
 
 	dev_info(&pdev->dev, "clock %u kHz\n", i2c->bus_freq / 1000);
 
+	return 0;
+
+err_disable_clk:
+	clk_disable_unprepare(i2c->clk);
+
 	return ret;
 }
 
-- 
2.35.1



