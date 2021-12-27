Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C80480173
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 17:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhL0QOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 11:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhL0QOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 11:14:19 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3365C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 08:14:18 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id v22so13854962qtx.8
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 08:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1HUsw0Y7fAlFhVHuLx6Tz+kFtR47XolHKASPW06R/oc=;
        b=f4jXOMhvKi58FsB0/0ZPoDYT8STvfEJzyIV8hd1Q3e2LPmCTpfs8ShPfYJpy/DbCVt
         Mv7UuWa/VOUcUbabj9c2MyznDv0aYZCx1pv/Pl8APmUHcfRJ5HChsK/NDUPmYzDL8KjR
         KuSKH+FXzHDi9/DMh9+mARj2i7isT6JlU+MesAweVktzQDJAGGbAju/e+Wsz4ScBsAW+
         sLGSW669kvL6qJIW4XUtKiw6w6jh9o9jh9zK1o32PdFFO360hRFPgOBiKqPxPfvS6zCX
         lPo1zSEFoSceXdJqXHIEnvNpb4hFWr/R6I4AdfznZslBTike5LcmE+1sChThPFkw8nE7
         8IvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1HUsw0Y7fAlFhVHuLx6Tz+kFtR47XolHKASPW06R/oc=;
        b=6ndUICJE3RjBXXPUBKiE+FJ7JLjQFENgGp37/huDqFaFEZ7iGWgI1Ue8o0+7sC27di
         zncW5FpiwvmuZlkdK7L2a0HDkwg7zxLwk4j7l2d2Cot6bwjFkLoF4HtQTEouWN2yId8S
         NfHuvZfjh5imAeyq/E9wQbx/fZUOBa9CaF6xEO4hTLiMS8yQ6yQvbOpMJq49gBuOB0MU
         JKzj34jqybScZpMcRy8p9Tlfr9juZNbz9OWZTh9pm/jVdBy5mMsFkkE1ngPJN4OgkI4a
         RReUnsa9kUxLCdzUh4vFzp6pu6kdzP/CPrtgKei5ELBvnW+RxUb0SbmCsGZyWfNv8xyU
         RKYg==
X-Gm-Message-State: AOAM5301Sw/XinQX1RtlqAhnCtv7xBdRZTnFCoAMzmveiC4ppYMZB6xv
        b8V3OjP/aF4BPgtivtkuWHA=
X-Google-Smtp-Source: ABdhPJzqLDzrg9sTfx+LDmYWrJoM345CRQx9hMM05hH3otr/qPYaSGcg6dSbJYIYn5UGEd/WqkdysA==
X-Received: by 2002:ac8:5ad1:: with SMTP id d17mr15290072qtd.23.1640621658073;
        Mon, 27 Dec 2021 08:14:18 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:485:504a:9e4d:7b75:ee5a:c500])
        by smtp.gmail.com with ESMTPSA id d4sm13765731qkn.79.2021.12.27.08.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 08:14:17 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     shawnguo@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] ARM: dts: imx23-evk: Remove MX23_PAD_SSP1_DETECT from hog group
Date:   Mon, 27 Dec 2021 13:14:02 -0300
Message-Id: <20211227161402.2523009-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, SD card fails to mount due to the following pinctrl error:

[   11.170000] imx23-pinctrl 80018000.pinctrl: pin SSP1_DETECT already requested by 80018000.pinctrl; cannot claim for 80010000.spi
[   11.180000] imx23-pinctrl 80018000.pinctrl: pin-65 (80010000.spi) status -22
[   11.190000] imx23-pinctrl 80018000.pinctrl: could not request pin 65 (SSP1_DETECT) from group mmc0-pins-fixup.0  on device 80018000.pinctrl
[   11.200000] mxs-mmc 80010000.spi: Error applying setting, reverse things back

Fix it by removing the MX23_PAD_SSP1_DETECT pin from the hog group as it
is already been used by the mmc0-pins-fixup pinctrl group.

With this change the rootfs can be mounted and the imx23-evk board can
boot successfully.

Cc: <stable@vger.kernel.org>
Fixes: bc3875f1a61e ("ARM: dts: mxs: modify mx23/mx28 dts files to use pinctrl headers")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/boot/dts/imx23-evk.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx23-evk.dts b/arch/arm/boot/dts/imx23-evk.dts
index 8cbaf1c81174..3b609d987d88 100644
--- a/arch/arm/boot/dts/imx23-evk.dts
+++ b/arch/arm/boot/dts/imx23-evk.dts
@@ -79,7 +79,6 @@ hog_pins_a: hog@0 {
 						MX23_PAD_LCD_RESET__GPIO_1_18
 						MX23_PAD_PWM3__GPIO_1_29
 						MX23_PAD_PWM4__GPIO_1_30
-						MX23_PAD_SSP1_DETECT__SSP1_DETECT
 					>;
 					fsl,drive-strength = <MXS_DRIVE_4mA>;
 					fsl,voltage = <MXS_VOLTAGE_HIGH>;
-- 
2.25.1

