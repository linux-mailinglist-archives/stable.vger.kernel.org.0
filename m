Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2F324BFC3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgHTNxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgHTJZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:25:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14EE722CA1;
        Thu, 20 Aug 2020 09:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915517;
        bh=v0dwlY5SBRqPHG9bP2zvvxz+zgQcDfU5lnL0b2EymNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOw8DsafumJwOZScOs7ez460REee9hzAdxESB+A/5zFeLCKv3r68iDHBZdycRAUlU
         xRg//4oRa0GpCQIdHkG3r8HEzoMbQ3Dn6DvdUvJ0/Af4ecjLBc+q3orXvM2Xdseev3
         ZNQHvW/FlGucKUtMgkAC25AkmE2hzuBbLLbgM+T4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.8 042/232] arm64: dts: qcom: sc7180: Drop the unused non-MSA SID
Date:   Thu, 20 Aug 2020 11:18:13 +0200
Message-Id: <20200820091614.821682067@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

commit 08257610302159e08fd4f5d33787807374ea63c7 upstream.

Having a non-MSA (Modem Self-Authentication) SID bypassed breaks modem
sandboxing i.e if a transaction were to originate from it, the hardware
memory protections units (XPUs) would fail to flag them (any transaction
originating from modem are historically termed as an MSA transaction).
Drop the unused non-MSA modem SID on SC7180 SoCs and cheza so that SMMU
continues to block them.

Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Fixes: bec71ba243e95 ("arm64: dts: qcom: sc7180: Update Q6V5 MSS node")
Fixes: 68aee4af5f620 ("arm64: dts: qcom: sdm845-cheza: Add iommus property")
Cc: stable@vger.kernel.org
Reported-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200630081938.8131-1-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/qcom/sc7180-idp.dts    |    2 +-
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc7180-idp.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
@@ -312,7 +312,7 @@
 &remoteproc_mpss {
 	status = "okay";
 	compatible = "qcom,sc7180-mss-pil";
-	iommus = <&apps_smmu 0x460 0x1>, <&apps_smmu 0x444 0x3>;
+	iommus = <&apps_smmu 0x461 0x0>, <&apps_smmu 0x444 0x3>;
 	memory-region = <&mba_mem &mpss_mem>;
 };
 
--- a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
@@ -634,7 +634,7 @@ ap_ts_i2c: &i2c14 {
 };
 
 &mss_pil {
-	iommus = <&apps_smmu 0x780 0x1>,
+	iommus = <&apps_smmu 0x781 0x0>,
 		 <&apps_smmu 0x724 0x3>;
 };
 


