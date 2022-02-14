Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4E54B49AC
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347542AbiBNKaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:30:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347569AbiBNKaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:30:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9E799680;
        Mon, 14 Feb 2022 01:58:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89FEB60A69;
        Mon, 14 Feb 2022 09:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655E1C340E9;
        Mon, 14 Feb 2022 09:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832731;
        bh=o4neHMx2mJG77mYsmSI3U36Vmc1lgTCbnYGLWeoZyoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVrq17cDB35tvNaZxtQoNg2KRkalr7akVYBSjDo4N1F7EzNwyAsOIBKCz6+HWvUtr
         ADMLTpjOqjJs57KYkVu9h2Pn6Ts7uZDr9Uj8e/M4GkwHHEndaTOXbgutg/h71vfSrn
         fIulcQgXpL1WZTjOMGR1t158U1cr6MdeWAhc6Oa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 105/203] arm64: dts: imx8mq: fix mipi_csi bidirectional port numbers
Date:   Mon, 14 Feb 2022 10:25:49 +0100
Message-Id: <20220214092513.811692543@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kepplinger <martin.kepplinger@puri.sm>

[ Upstream commit 283d45145fbf460dbaf0229cacd7ed60ec52f364 ]

The port numbers for the imx8mq mipi csi controller are wrong and
the mipi driver can't find any media devices as port@1 is connected
to the CSI bridge, not port@0. And port@0 is connected to the
source - the sensor. Fix this.

Fixes: bcadd5f66c2a ("arm64: dts: imx8mq: add mipi csi phy and csi bridge descriptions")
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 71bf497f99c25..c222d93f5e649 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1123,8 +1123,8 @@ ports {
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					port@0 {
-						reg = <0>;
+					port@1 {
+						reg = <1>;
 
 						csi1_mipi_ep: endpoint {
 							remote-endpoint = <&csi1_ep>;
@@ -1175,8 +1175,8 @@ ports {
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					port@0 {
-						reg = <0>;
+					port@1 {
+						reg = <1>;
 
 						csi2_mipi_ep: endpoint {
 							remote-endpoint = <&csi2_ep>;
-- 
2.34.1



