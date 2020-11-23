Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182EA2C09F3
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgKWNOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733293AbgKWMpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E75BA20888;
        Mon, 23 Nov 2020 12:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135511;
        bh=44Uiu1GUEtXfKu+p2pVas5QFqW1xtqZAcsv9wE2M27Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALJcUwfs+wmxcZKw9T6qKsfn74Ou56CfozRzsVEyBptgvI1bzCEvWDPUtL9nrd9CM
         3qZ10JVEfXZuykyBYoV56CD80BRzNZSFS7pvXo52DxN3ZJedkSCaPfea7vhDEqOKdP
         JuLjyW7DLE/yMz6vH7O9Jzm/F+XJ77JKt6T5Q8Sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biwen Li <biwen.li@nxp.com>,
        Ran Wang <ran.wang_1@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 095/252] arm64: dts: fsl: fix endianness issue of rcpm
Date:   Mon, 23 Nov 2020 13:20:45 +0100
Message-Id: <20201123121840.175401451@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biwen Li <biwen.li@nxp.com>

[ Upstream commit d92454287ee25d78f1caac3734a1864f8a5a5275 ]

Add little-endian property to RCPM node (for ls1028a,ls1088a,ls208xa),
otherwise RCPM driver will program hardware with incorrect setting,
causing system (such as LS1028ARDB) failed to be waked by wakeup source.

Fixes: 791c88ca5713 (“arm64: dts: ls1028a: Add ftm_alarm0 DT node”)
Fixes: f4fe3a8665495 (“arm64: dts: layerscape: add ftm_alarm0 node”)
Signed-off-by: Biwen Li <biwen.li@nxp.com>
Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
Acked-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 1 +
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi | 1 +
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 0efeb8fa773e7..651bfe1040ba3 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -1012,6 +1012,7 @@
 			compatible = "fsl,ls1028a-rcpm", "fsl,qoriq-rcpm-2.1+";
 			reg = <0x0 0x1e34040 0x0 0x1c>;
 			#fsl,rcpm-wakeup-cells = <7>;
+			little-endian;
 		};
 
 		ftm_alarm0: timer@2800000 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index 169f4742ae3b2..2ef812dd29ebc 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -787,6 +787,7 @@
 			compatible = "fsl,ls1088a-rcpm", "fsl,qoriq-rcpm-2.1+";
 			reg = <0x0 0x1e34040 0x0 0x18>;
 			#fsl,rcpm-wakeup-cells = <6>;
+			little-endian;
 		};
 
 		ftm_alarm0: timer@2800000 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 41102dacc2e10..141b3d23b1552 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -769,6 +769,7 @@
 			compatible = "fsl,ls208xa-rcpm", "fsl,qoriq-rcpm-2.1+";
 			reg = <0x0 0x1e34040 0x0 0x18>;
 			#fsl,rcpm-wakeup-cells = <6>;
+			little-endian;
 		};
 
 		ftm_alarm0: timer@2800000 {
-- 
2.27.0



