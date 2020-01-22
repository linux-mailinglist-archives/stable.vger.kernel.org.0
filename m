Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12AE14565E
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgAVN0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730479AbgAVN0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:24 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B6852467F;
        Wed, 22 Jan 2020 13:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699584;
        bh=g0EywqsErMlZhWqCuMVaf+0EEvdJwfS1RpONnYrFQBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvcVHtHPWTLjkdDHDCOF/MqM6LTdUJWd6ejs05/a62ZFYojOQnRTXzVvqeiy5oz0G
         +hcgbCymI7/x88EW8FsG8LXv2sQNs7lwY+5aFCZEOa/pmtAqRct6pb6PyeJOddmQBg
         s3Xq6DBx5gxpzcjdPG5KBEE1v7knrMLJ3BFcOBuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Andy Gross <agross@kernel.org>
Subject: [PATCH 5.4 186/222] arm64: dts: qcom: sdm845-cheza: delete zap-shader
Date:   Wed, 22 Jan 2020 10:29:32 +0100
Message-Id: <20200122092847.005621971@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

commit 43b0a4b482478aa4fe7240230be74a79dee95679 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi |    2 ++
 arch/arm64/boot/dts/qcom/sdm845.dtsi       |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

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
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2824,7 +2824,7 @@
 
 			qcom,gmu = <&gmu>;
 
-			zap-shader {
+			zap_shader: zap-shader {
 				memory-region = <&gpu_mem>;
 			};
 


