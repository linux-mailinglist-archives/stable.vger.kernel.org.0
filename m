Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5482A520F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbgKCUqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731186AbgKCUqX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 487F420719;
        Tue,  3 Nov 2020 20:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436382;
        bh=xvYuqG/nqQCnqPp65IkugOL6wIjSVb3Do3e6ftfhyx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZYS1cEHgaV8UDlsy3bCMvBTeWlecrUFS1EpmYhSsJphwIWm+TspVb3YuZc/hiCSg
         cEnSE/cEPBSRhpeqyT6LtVUhgf1h3c8p5sD+pzhjX+/Mif64xdS8bnmqXrgH0JL7TE
         87ZgpXIgjGeR4CGfGHmOafwn/btaT/YccXhcGAJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Konrad Dybcio <konradybcio@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 178/391] arm64: dts: qcom: kitakami: Temporarily disable SDHCI1
Date:   Tue,  3 Nov 2020 21:33:49 +0100
Message-Id: <20201103203358.883649659@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konradybcio@gmail.com>

[ Upstream commit e884fb6cc89dce1debeae33704edd7735a3d6d9c ]

There is an issue with Kitakami eMMCs dying when a quirk
isn't addressed. Until that happens, disable it.

Signed-off-by: Konrad Dybcio <konradybcio@gmail.com>
Link: https://lore.kernel.org/r/20200814154749.257837-1-konradybcio@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi b/arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi
index 4032b7478f044..791f254ac3f87 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi
@@ -221,7 +221,12 @@
 };
 
 &sdhc1 {
-	status = "okay";
+	/* There is an issue with the eMMC causing permanent
+	 * damage to the card if a quirk isn't addressed.
+	 * Until it's fixed, disable the MMC so as not to brick
+	 * devices.
+	 */
+	status = "disabled";
 
 	/* Downstream pushes 2.95V to the sdhci device,
 	 * but upstream driver REALLY wants to make vmmc 1.8v
-- 
2.27.0



