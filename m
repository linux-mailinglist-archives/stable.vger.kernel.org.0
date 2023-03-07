Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695D76AEDC1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjCGSHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjCGSG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:06:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5907A8E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:59:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05D2B6150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A12C433A0;
        Tue,  7 Mar 2023 17:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211990;
        bh=Y/q+L145BE+93JeqeN9PBSno8SHhBtY7FoLrqxecr58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxboxKVnCGx21mLSqs3Xzfhcosjrc/aFZHn9I36+i81ScexNVrwlm7CPOttzEl0xN
         CR0b9v1G3jEfdC/m0mz86PjNTJKQcwpGZPPLIdRPmA6px0DItO/BPSFzH2nYCqHve+
         aQIiSmPPA9d8I7DmJt5BhuPNI3kmxUDvLe/bEXAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/885] arm64: dts: mediatek: mt8195: Add power domain to U3PHY1 T-PHY
Date:   Tue,  7 Mar 2023 17:49:08 +0100
Message-Id: <20230307170002.257023304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit a9f6721a3c92764582ed12296292fda4a7f2dd25 ]

Assign power domain to the U3PHY1 T-PHY in otder to keep this PHY
alive after unused PD shutdown and to be able to completely cut
and restore power to it, for example, to save some power during
system suspend/sleep.

Fixes: 2b515194bf0c ("arm64: dts: mt8195: Add power domains controller")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221214131117.108008-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 6f5fa7ca49013..350d6c2ea622a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1410,6 +1410,7 @@ u3phy1: t-phy@11e30000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0 0 0x11e30000 0xe00>;
+			power-domains = <&spm MT8195_POWER_DOMAIN_SSUSB_PCIE_PHY>;
 			status = "disabled";
 
 			u2port1: usb-phy@0 {
-- 
2.39.2



