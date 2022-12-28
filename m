Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47267657837
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiL1Osj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiL1OsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:48:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D25BB7F1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:48:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9A50B816E6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D3FC433D2;
        Wed, 28 Dec 2022 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238890;
        bh=HHnuR2CQJJcJP8FB0b81W1ndd+dBLZajujaLjrsmtEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BN1BgsVWJuGa8bgzfqkJq9nUxzgU3YRGH5mwmWp+TCNXReSveAP8ZLyBIqnvNfJ0F
         NsCxxkxynIgM9+GjZaQl1wrrPRc55Iuk+vldK0WJOv8mqBLs2F2RabkAs5gcMwfB+u
         RS9REs8N9SJXPV8YDe51zO7Wo74zfFnqYjDJfvA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/731] arm64: dts: qcom: sm8250: fix UFS PHY registers
Date:   Wed, 28 Dec 2022 15:32:08 +0100
Message-Id: <20221228144257.152012369@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 7f8b37dd4e7bf50160529530d9789b846153df71 ]

The sizes of the UFS PHY register regions are too small and does
specifically not cover all registers used by the Linux driver.

As Linux maps these regions as full pages this is currently not an issue
on Linux, but let's update the sizes to match the vendor driver.

Fixes: b7e2fba06622 ("arm64: dts: qcom: sm8250: Add UFS controller and PHY")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221024091507.20342-3-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index bcc948f6f326..e4ba998d0c6e 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1757,11 +1757,11 @@ ufs_mem_phy: phy@1d87000 {
 			status = "disabled";
 
 			ufs_mem_phy_lanes: phy@1d87400 {
-				reg = <0 0x01d87400 0 0x108>,
-				      <0 0x01d87600 0 0x1e0>,
-				      <0 0x01d87c00 0 0x1dc>,
-				      <0 0x01d87800 0 0x108>,
-				      <0 0x01d87a00 0 0x1e0>;
+				reg = <0 0x01d87400 0 0x16c>,
+				      <0 0x01d87600 0 0x200>,
+				      <0 0x01d87c00 0 0x200>,
+				      <0 0x01d87800 0 0x16c>,
+				      <0 0x01d87a00 0 0x200>;
 				#phy-cells = <0>;
 			};
 		};
-- 
2.35.1



