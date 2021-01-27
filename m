Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBCF3062EB
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 19:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344101AbhA0SCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 13:02:39 -0500
Received: from mail.v3.sk ([167.172.186.51]:48220 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344098AbhA0SCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 13:02:38 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 0D0D8DF5E5;
        Wed, 27 Jan 2021 17:57:49 +0000 (UTC)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id gvktt2hGF6tH; Wed, 27 Jan 2021 17:57:48 +0000 (UTC)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 9A24FE0AE3;
        Wed, 27 Jan 2021 17:57:48 +0000 (UTC)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hr2dETXlABTL; Wed, 27 Jan 2021 17:57:48 +0000 (UTC)
Received: from localhost (unknown [109.183.109.54])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 5FC65DF5E5;
        Wed, 27 Jan 2021 17:57:48 +0000 (UTC)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>, stable@vger.kernel.org
Subject: [PATCH] media: marvell-ccic: power up the device on mclk enable
Date:   Wed, 27 Jan 2021 19:01:43 +0100
Message-Id: <20210127180143.43437-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Writing to REG_CLKCTRL with the power off causes a hang. Enable the
device first.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/me=
dia/platform/marvell-ccic/mcam-core.c
index c012fd2e1d291..34266fba824f2 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -931,6 +931,7 @@ static int mclk_enable(struct clk_hw *hw)
 		mclk_div =3D 2;
 	}
=20
+	pm_runtime_get_sync(cam->dev);
 	clk_enable(cam->clk[0]);
 	mcam_reg_write(cam, REG_CLKCTRL, (mclk_src << 29) | mclk_div);
 	mcam_ctlr_power_up(cam);
@@ -944,6 +945,7 @@ static void mclk_disable(struct clk_hw *hw)
=20
 	mcam_ctlr_power_down(cam);
 	clk_disable(cam->clk[0]);
+	pm_runtime_put(cam->dev);
 }
=20
 static unsigned long mclk_recalc_rate(struct clk_hw *hw,
--=20
2.29.2

