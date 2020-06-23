Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43073205D6F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388087AbgFWUNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389077AbgFWUNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:13:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9976F20707;
        Tue, 23 Jun 2020 20:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943202;
        bh=Bv/vyaWA2VbHx5NcZWftjxFnx87M5TP/+lO8vxz4B+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2UUupfJsl1lsvM83KBjRZZk/ouvsyjLPYRAUVYQ4hH/RvGB2g187x4O4Pt2e/cKV
         T28pylk5nMoALmEyHHKsuZk9w0VV+jhJDYNLFTCGPWE6cEqF7vUL2cXbvN9BFqxFoA
         SuEZZ4INIPTkWmPl3kacBgr6PiE3yPGeyJc+Quos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yue Wang <yue.wang@amlogic.com>,
        Hanjie Lin <hanjie.lin@amlogic.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 298/477] usb: dwc3: meson-g12a: fix error path when fetching the reset line fails
Date:   Tue, 23 Jun 2020 21:54:55 +0200
Message-Id: <20200623195421.636373360@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit be8c1001a7e681e8813882a42ed51c8dbffd8800 ]

Disable and unprepare the clocks when devm_reset_control_get_shared()
fails. This fixes the error path as this must disable the clocks which
were previously enabled.

Fixes: 1e355f21d3fb96 ("usb: dwc3: Add Amlogic A1 DWC3 glue")
Cc: Yue Wang <yue.wang@amlogic.com>
Cc: Hanjie Lin <hanjie.lin@amlogic.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20200526202943.715220-2-martin.blumenstingl@googlemail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-meson-g12a.c b/drivers/usb/dwc3/dwc3-meson-g12a.c
index 2d257bdfe8485..eabb3bb6fcaa1 100644
--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -505,7 +505,7 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->reset)) {
 		ret = PTR_ERR(priv->reset);
 		dev_err(dev, "failed to get device reset, err=%d\n", ret);
-		return ret;
+		goto err_disable_clks;
 	}
 
 	ret = reset_control_reset(priv->reset);
-- 
2.25.1



