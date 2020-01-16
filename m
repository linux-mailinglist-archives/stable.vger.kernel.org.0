Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C425913E133
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbgAPQsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729165AbgAPQsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:48:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F33242081E;
        Thu, 16 Jan 2020 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193300;
        bh=xFQ1TY2O7jmGgWqGg6Fdp/3dyc3nfW0IkOm+JatatA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bL7xFort8+3XdTHshSIfZ6mttOxwCDgLPlA8MS261EPR0YplPoQJqZWwcI8rlPy74
         tnJK4LNo9UAjmNibvXTGx/4mqObYO2tXpYw90IrqYjr3CbJZSC8qvJRTgZT3tM6XJ7
         R52hLM6nZbayrYw9w0/u2YCHiqiIg+HE6eX3Pu7c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Andy Gross <agross@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 069/205] arm64: dts: qcom: sdm845-cheza: delete zap-shader
Date:   Thu, 16 Jan 2020 11:40:44 -0500
Message-Id: <20200116164300.6705-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 43b0a4b482478aa4fe7240230be74a79dee95679 ]

This is unused on cheza.  Delete the node to get ride of the reserved-
memory section, and to avoid the driver from attempting to load a zap
shader that doesn't exist every time it powers up the GPU.

This also avoids a massive amount of dmesg spam about missing zap fw:
  msm ae00000.mdss: [drm:adreno_request_fw] *ERROR* failed to load
qcom/a630_zap.mdt: -2
  adreno 5000000.gpu: [drm:adreno_zap_shader_load] *ERROR* Unable to
load a630_zap.mdt

Signed-off-by: Rob Clark <robdclark@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Fixes: 3fdeaee951aa ("arm64: dts: sdm845: Add zap shader region for GPU")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Andy Gross <agross@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi | 2 ++
 arch/arm64/boot/dts/qcom/sdm845.dtsi       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
index 34881c0113cb..99a28d64ee62 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
@@ -165,6 +165,8 @@
 /delete-node/ &venus_mem;
 /delete-node/ &cdsp_mem;
 /delete-node/ &cdsp_pas;
+/delete-node/ &zap_shader;
+/delete-node/ &gpu_mem;
 
 /* Increase the size from 120 MB to 128 MB */
 &mpss_region {
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index f406a4340b05..2287354fef86 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2824,7 +2824,7 @@
 
 			qcom,gmu = <&gmu>;
 
-			zap-shader {
+			zap_shader: zap-shader {
 				memory-region = <&gpu_mem>;
 			};
 
-- 
2.20.1

