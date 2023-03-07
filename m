Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FED06AE86D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjCGRPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjCGRPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:15:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9644899248
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:10:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE18161508
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A09DC433EF;
        Tue,  7 Mar 2023 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209045;
        bh=rfz0WfQAWj+mBSA05ozqQ41PgBWc6mWX7nifUwdXYDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TssyLPkSuLVRlDvz0lMkSonIaRqnMVlAMNey6sjZNpnrdxTSPvtEViAzNbN6U7ahg
         RjhurGi4j4YrIX386DBnFxg/7O3jwCXCCyvAxPnpIH1jQ2ASl9JZKRh0z8sWMYvBO9
         fq2C4kWKxs0PMUhu3h4PQyOCM06weYpRRkS6/bhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen-Yu Tsai <wenst@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0063/1001] arm64: dts: mediatek: mt8192: Mark scp_adsp clock as broken
Date:   Tue,  7 Mar 2023 17:47:15 +0100
Message-Id: <20230307170024.851314929@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 089cd717e6ef03cf9cf7865777d67775de41339b ]

The scp_adsp clock controller is under the SCP_ADSP power domain. This
power domain is currently not supported nor defined.

Mark the clock controller as broken for now, to avoid the system from
trying to access it, and causing the CPU or bus to stall.

Fixes: 5d2b897bc6f5 ("arm64: dts: mediatek: Add mt8192 clock controllers")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20221229101202.1655924-1-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index 0d43a32734a37..46a1e457fab45 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -586,6 +586,8 @@ scp_adsp: clock-controller@10720000 {
 			compatible = "mediatek,mt8192-scp_adsp";
 			reg = <0 0x10720000 0 0x1000>;
 			#clock-cells = <1>;
+			/* power domain dependency not upstreamed */
+			status = "fail";
 		};
 
 		uart0: serial@11002000 {
-- 
2.39.2



