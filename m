Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EA76AE83A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCGROX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjCGRNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:13:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC2276B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:08:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BC6661509
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BC5C433EF;
        Tue,  7 Mar 2023 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208917;
        bh=XjvrCQwQamrfGufxM8l94IqEUrbzK7jzjOUTChV4hpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDxqOsHZyBQ4PL/2Av1r9SjfslKC1UmL2VUGlXbB7Oog2ksq5olswqmqZHFC9zByd
         mGiziTKruRaslWbQN7herjzLPpcG1zhFi2ECl9rrpN4sMkZ94xh5ecJrNO8qlLRyEZ
         2fpWUbVbQehwEVh0fFBDpIUSL/fzM1ffSGdJfDG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0051/1001] arm64: tegra: Fix duplicate regulator on Jetson TX1
Date:   Tue,  7 Mar 2023 17:47:03 +0100
Message-Id: <20230307170024.336548031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 29bcc1eaca315326d1cc883fbe9b451d1f9e3fa5 ]

When the top-level regulators were renamed, the 1.2V camera regulator
accidentally ended up with the same DT node name as the 1.8V camera
regulator.

Fixes: 097e01c61015 ("arm64: tegra: Rename top-level regulators")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
index dd9a17922fe5c..a87e103f3828d 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1667,7 +1667,7 @@ vdd_hdmi: regulator-vdd-hdmi {
 		vin-supply = <&vdd_5v0_sys>;
 	};
 
-	vdd_cam_1v2: regulator-vdd-cam-1v8 {
+	vdd_cam_1v2: regulator-vdd-cam-1v2 {
 		compatible = "regulator-fixed";
 		regulator-name = "vdd-cam-1v2";
 		regulator-min-microvolt = <1200000>;
-- 
2.39.2



