Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F19C611098
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiJ1MHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiJ1MHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:07:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B539D148FEA
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:07:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E438627FF
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A3DC433C1;
        Fri, 28 Oct 2022 12:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958820;
        bh=PzNHI3g0Q55PYBrcSnOd02+jdbk95bvg3BuYXKvgvbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdjohKn9gLzYmpZSP2mzkMWjhf92gjafS4gFd1j1SdR8S1jvxvT6zmuTTXaPx6ByA
         UTeM1jEv1NmIfQIxx6ycBZIEQj/ONBaIASsZfb3nNUvXqXaSqo8KN8yjxjIXSL8O8Y
         KF31y24ZduMOTPa/AkEkUbrY42YxWXO6SkhlwxZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Green <evgreen@chromium.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alex Elder <elder@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.10 63/73] arm64: dts: qcom: sc7180-trogdor: Fixup modem memory region
Date:   Fri, 28 Oct 2022 14:04:00 +0200
Message-Id: <20221028120235.115155698@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

commit ef9a5d188d663753e73a3c8e8910ceab8e9305c4 upstream.

The modem firmware memory requirements vary between 32M/140M on
no-lte/lte skus respectively, so fixup the modem memory region
to reflect the requirements.

Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/1602786476-27833-1-git-send-email-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Alex Elder <elder@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi |    4 ++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi         |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi
@@ -9,6 +9,10 @@
 	label = "proximity-wifi-lte";
 };
 
+&mpss_mem {
+	reg = <0x0 0x86000000 0x0 0x8c00000>;
+};
+
 &remoteproc_mpss {
 	firmware-name = "qcom/sc7180-trogdor/modem/mba.mbn",
 			"qcom/sc7180-trogdor/modem/qdsp6sw.mbn";
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -39,7 +39,7 @@
 		};
 
 		mpss_mem: memory@86000000 {
-			reg = <0x0 0x86000000 0x0 0x8c00000>;
+			reg = <0x0 0x86000000 0x0 0x2000000>;
 			no-map;
 		};
 


