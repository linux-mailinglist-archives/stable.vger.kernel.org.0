Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B052E3F2C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505613AbgL1Og6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504873AbgL1OdC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:33:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6763B2063A;
        Mon, 28 Dec 2020 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165967;
        bh=vxJLSJ059SiscfOtsXhu51ELAFTi6Fb31dlx00FjoX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4QLG8BWIfcVr0bqAYd5b2S6vyMgLX2Ym5SY9A9LXWxbd9w3eZDRQ3HRhAA02PmPX
         +Ehcunvb4r5qNzMR9+z6cP+4X5wf+GItsvWW2nJaYgXY6GqMxzQFBftMyN71l61Th1
         73raNAyuQr0jWH4N0F7Kt81QoG7I6BZCMFopsqi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DingHua Ma <dinghua.ma.sz@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 711/717] regulator: axp20x: Fix DLDO2 voltage control register mask for AXP22x
Date:   Mon, 28 Dec 2020 13:51:49 +0100
Message-Id: <20201228125055.061781230@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: DingHua Ma <dinghua.ma.sz@gmail.com>

commit 291de1d102fafef0798cdad9666cd4f8da7da7cc upstream.

When I use the axp20x chip to power my SDIO device on the 5.4 kernel,
the output voltage of DLDO2 is wrong. After comparing the register
manual and source code of the chip, I found that the mask bit of the
driver register of the port was wrong. I fixed this error by modifying
the mask register of the source code. This error seems to be a copy
error of the macro when writing the code. Now the voltage output of
the DLDO2 port of axp20x is correct. My development environment is
Allwinner A40I of arm architecture, and the kernel version is 5.4.

Signed-off-by: DingHua Ma <dinghua.ma.sz@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Cc: <stable@vger.kernel.org>
Fixes: db4a555f7c4c ("regulator: axp20x: use defines for masks")
Link: https://lore.kernel.org/r/20201201001000.22302-1-dinghua.ma.sz@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/axp20x-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -594,7 +594,7 @@ static const struct regulator_desc axp22
 		 AXP22X_DLDO1_V_OUT, AXP22X_DLDO1_V_OUT_MASK,
 		 AXP22X_PWR_OUT_CTRL2, AXP22X_PWR_OUT_DLDO1_MASK),
 	AXP_DESC(AXP22X, DLDO2, "dldo2", "dldoin", 700, 3300, 100,
-		 AXP22X_DLDO2_V_OUT, AXP22X_PWR_OUT_DLDO2_MASK,
+		 AXP22X_DLDO2_V_OUT, AXP22X_DLDO2_V_OUT_MASK,
 		 AXP22X_PWR_OUT_CTRL2, AXP22X_PWR_OUT_DLDO2_MASK),
 	AXP_DESC(AXP22X, DLDO3, "dldo3", "dldoin", 700, 3300, 100,
 		 AXP22X_DLDO3_V_OUT, AXP22X_DLDO3_V_OUT_MASK,


