Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C4F4B4B49
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243598AbiBNKFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:05:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344378AbiBNKEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:04:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F42247560;
        Mon, 14 Feb 2022 01:49:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01D88B80DBF;
        Mon, 14 Feb 2022 09:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DF5C340EF;
        Mon, 14 Feb 2022 09:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832139;
        bh=gXpCHYrOjOny7QSLw3KgjTUxqmcYC8PtqM/5JhrOeiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qH2k8bE4le2a8Xrzs4pynLj1iBngUSDPKyS7KfHUTDe6FR/U7PeneYI1Wjlj3EtjR
         REAcy3XH6HUsqEdCrOIsBiADpzNc1pjwB3xlYGA2c5jB4pMcp8oliqOJJSf2eo/06g
         n3B/Am9CcVilRziaN1SyjWPaC6N+4Do4KbPCrhiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/172] arm64: dts: imx8mq: fix mipi_csi bidirectional port numbers
Date:   Mon, 14 Feb 2022 10:25:48 +0100
Message-Id: <20220214092509.517785259@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
index 2bc57d8f29c7f..1a7039bc0b37c 100644
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



