Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C44328CF9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240928AbhCATCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:02:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240704AbhCAS4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:56:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EC376511D;
        Mon,  1 Mar 2021 17:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618960;
        bh=6QsqnqnjmOxLUlPsvlC6bQ7rf8487dlOe1i/yMnOgRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fg7mfgxM7e0O5t0ZZkUruPgoEApNIVjHkiv+3qAJboXoBujlCNrjhBOxm3KJcAmWU
         9hpQASX2Esu87TsHc6H1uxlcn6vPlAU1gc7FphQxF1HL4+LZoRxT2906Xo9mxv6Tvm
         66gvY1kUUQOpT5qZR/9et33/VSpl50Sux81+E+fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 280/663] mfd: bd9571mwv: Use devm_mfd_add_devices()
Date:   Mon,  1 Mar 2021 17:08:48 +0100
Message-Id: <20210301161155.672320447@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit c58ad0f2b052b5675d6394e03713ee41e721b44c ]

To remove mfd devices when unload this driver, should use
devm_mfd_add_devices() instead.

Fixes: d3ea21272094 ("mfd: Add ROHM BD9571MWV-M MFD PMIC driver")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/bd9571mwv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/bd9571mwv.c b/drivers/mfd/bd9571mwv.c
index fab3cdc27ed64..19d57a45134c6 100644
--- a/drivers/mfd/bd9571mwv.c
+++ b/drivers/mfd/bd9571mwv.c
@@ -185,9 +185,9 @@ static int bd9571mwv_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	ret = mfd_add_devices(bd->dev, PLATFORM_DEVID_AUTO, bd9571mwv_cells,
-			      ARRAY_SIZE(bd9571mwv_cells), NULL, 0,
-			      regmap_irq_get_domain(bd->irq_data));
+	ret = devm_mfd_add_devices(bd->dev, PLATFORM_DEVID_AUTO,
+				   bd9571mwv_cells, ARRAY_SIZE(bd9571mwv_cells),
+				   NULL, 0, regmap_irq_get_domain(bd->irq_data));
 	if (ret) {
 		regmap_del_irq_chip(bd->irq, bd->irq_data);
 		return ret;
-- 
2.27.0



