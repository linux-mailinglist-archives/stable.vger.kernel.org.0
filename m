Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1D0579C4A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbiGSMiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240779AbiGSMh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:37:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A58422DD;
        Tue, 19 Jul 2022 05:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55D3AB81B21;
        Tue, 19 Jul 2022 12:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5F3C341C6;
        Tue, 19 Jul 2022 12:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232871;
        bh=gTAyIIWfVvcGQ/wzA1TZPu6SnMzXCc/djoWkchmhfY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUv9p1FIxRDxWif2nVysvSCr3ytsW1rHYrHAk6QV4IKuzFGxzgOvomyLIUoaws1RI
         wPkSB+f5ev2HquSlsjNKIke4QvVDYI04jsDDjkKb+I1XAAxDjaHkJhdMdQW8baz6Co
         235E4htzo51AoRaWj4eeza0ajICiWtTrXLLDN6DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Zhang <william.zhang@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/167] arm64: dts: broadcom: bcm4908: Fix timer node for BCM4906 SoC
Date:   Tue, 19 Jul 2022 13:53:17 +0200
Message-Id: <20220719114702.822782094@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Zhang <william.zhang@broadcom.com>

[ Upstream commit b4a544e415e9be33b37d9bfa9d9f9f4d13f553d6 ]

The cpu mask value in interrupt property inherits from bcm4908.dtsi
which sets to four cpus. Correct the value to two cpus for dual core
BCM4906 SoC.

Fixes: c8b404fb05dc ("arm64: dts: broadcom: bcm4908: add BCM4906 Netgear R8000P DTS files")
Signed-off-by: William Zhang <william.zhang@broadcom.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi
index 66023d553524..d084c33d5ca8 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi
@@ -9,6 +9,14 @@ cpus {
 		/delete-node/ cpu@3;
 	};
 
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>;
+	};
+
 	pmu {
 		compatible = "arm,cortex-a53-pmu";
 		interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.35.1



