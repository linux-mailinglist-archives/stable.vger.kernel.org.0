Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A13C4F2C0B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbiDEI61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239006AbiDEIbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:31:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157C54B41D;
        Tue,  5 Apr 2022 01:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25B34B81B92;
        Tue,  5 Apr 2022 08:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DCEC385A1;
        Tue,  5 Apr 2022 08:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146990;
        bh=W6/FozryWmHJIOLVr6EslcB5S8a0evFD9y3rf1ZcPUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CernNq6LSlo/HOpjCew40Ha0GYCD/xQa0EIVficYntU8ZaFu1behV5dwFRF8VYqax
         Z50W6HBccBwx2P9krzruWrpphJUdl/B5a+y6kPFFvSWF/e+lNQdyDMUFBnhNI4oHE8
         kcVq8uws56qiY/wRpDSp2fDP6WYx+dJ7V7NsaS5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Svyatoslav Ryhel <clamor95@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0924/1126] ARM: tegra: transformer: Drop reg-shift for Tegra HS UART
Date:   Tue,  5 Apr 2022 09:27:51 +0200
Message-Id: <20220405070434.640507230@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 79b788bfc787b60699d46b9e273b42ebe18336b3 ]

When the Tegra High-Speed UART is used instead of the regular UART, the
reg-shift property is implied from the compatible string and should not
be explicitly listed.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra20-asus-tf101.dts               | 2 ++
 arch/arm/boot/dts/tegra30-asus-transformer-common.dtsi | 2 ++
 arch/arm/boot/dts/tegra30-pegatron-chagall.dts         | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-asus-tf101.dts b/arch/arm/boot/dts/tegra20-asus-tf101.dts
index 020172ee7340..e3267cda15cc 100644
--- a/arch/arm/boot/dts/tegra20-asus-tf101.dts
+++ b/arch/arm/boot/dts/tegra20-asus-tf101.dts
@@ -442,11 +442,13 @@
 
 	serial@70006040 {
 		compatible = "nvidia,tegra20-hsuart";
+		/delete-property/ reg-shift;
 		/* GPS BCM4751 */
 	};
 
 	serial@70006200 {
 		compatible = "nvidia,tegra20-hsuart";
+		/delete-property/ reg-shift;
 		status = "okay";
 
 		/* Azurewave AW-NH615 BCM4329B1 */
diff --git a/arch/arm/boot/dts/tegra30-asus-transformer-common.dtsi b/arch/arm/boot/dts/tegra30-asus-transformer-common.dtsi
index 85b43a86a26d..c662ab261ed5 100644
--- a/arch/arm/boot/dts/tegra30-asus-transformer-common.dtsi
+++ b/arch/arm/boot/dts/tegra30-asus-transformer-common.dtsi
@@ -1080,6 +1080,7 @@
 
 	serial@70006040 {
 		compatible = "nvidia,tegra30-hsuart";
+		/delete-property/ reg-shift;
 		status = "okay";
 
 		/* Broadcom GPS BCM47511 */
@@ -1087,6 +1088,7 @@
 
 	serial@70006200 {
 		compatible = "nvidia,tegra30-hsuart";
+		/delete-property/ reg-shift;
 		status = "okay";
 
 		nvidia,adjust-baud-rates = <0 9600 100>,
diff --git a/arch/arm/boot/dts/tegra30-pegatron-chagall.dts b/arch/arm/boot/dts/tegra30-pegatron-chagall.dts
index f4b2d4218849..8ce61035290b 100644
--- a/arch/arm/boot/dts/tegra30-pegatron-chagall.dts
+++ b/arch/arm/boot/dts/tegra30-pegatron-chagall.dts
@@ -1103,6 +1103,7 @@
 
 	uartb: serial@70006040 {
 		compatible = "nvidia,tegra30-hsuart";
+		/delete-property/ reg-shift;
 		status = "okay";
 
 		/* Broadcom GPS BCM47511 */
@@ -1110,6 +1111,7 @@
 
 	uartc: serial@70006200 {
 		compatible = "nvidia,tegra30-hsuart";
+		/delete-property/ reg-shift;
 		status = "okay";
 
 		nvidia,adjust-baud-rates = <0 9600 100>,
-- 
2.34.1



