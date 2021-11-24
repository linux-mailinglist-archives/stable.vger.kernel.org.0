Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF4B45BC0B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245051AbhKXMZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244120AbhKXMWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:22:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA1E6611AD;
        Wed, 24 Nov 2021 12:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756024;
        bh=OikdgyYJ2IXfsnpsoUdSgNReQWnXuIpVHowJ6wfCcbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNLzZGES5m2/4aLGbZQELarUS87dicY++0YPSz/wkkdzNx7Xjeqf064AI/YEgeyYK
         2IG5o5KUde8xCvBIoakDGXEuX3LlAHf1cvLcpJwpWq21AyFzhv+D2RJNL/a/MK8Ckl
         Aajd0u+oR4xh4w/tUVdk1ltybwwo+MimwtypbSaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 143/207] i2c: xlr: Fix a resource leak in the error handling path of xlr_i2c_probe()
Date:   Wed, 24 Nov 2021 12:56:54 +0100
Message-Id: <20211124115708.647362993@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 7f98960c046ee1136e7096aee168eda03aef8a5d ]

A successful 'clk_prepare()' call should be balanced by a corresponding
'clk_unprepare()' call in the error handling path of the probe, as already
done in the remove function.

More specifically, 'clk_prepare_enable()' is used, but 'clk_disable()' is
also already called. So just the unprepare step has still to be done.

Update the error handling path accordingly.

Fixes: 75d31c2372e4 ("i2c: xlr: add support for Sigma Designs controller variant")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xlr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xlr.c b/drivers/i2c/busses/i2c-xlr.c
index ad17d88d85736..63f47e07345c0 100644
--- a/drivers/i2c/busses/i2c-xlr.c
+++ b/drivers/i2c/busses/i2c-xlr.c
@@ -434,11 +434,15 @@ static int xlr_i2c_probe(struct platform_device *pdev)
 	i2c_set_adapdata(&priv->adap, priv);
 	ret = i2c_add_numbered_adapter(&priv->adap);
 	if (ret < 0)
-		return ret;
+		goto err_unprepare_clk;
 
 	platform_set_drvdata(pdev, priv);
 	dev_info(&priv->adap.dev, "Added I2C Bus.\n");
 	return 0;
+
+err_unprepare_clk:
+	clk_unprepare(clk);
+	return ret;
 }
 
 static int xlr_i2c_remove(struct platform_device *pdev)
-- 
2.33.0



