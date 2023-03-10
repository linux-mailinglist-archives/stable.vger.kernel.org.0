Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC9A6B46BA
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbjCJOqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbjCJOpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:45:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF660F6C62
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:45:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F90BB822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECC8C4339B;
        Fri, 10 Mar 2023 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459535;
        bh=BBdswELO1+jBSebGBQ9QOp1E2AsN4i/wJRJc3OycqVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmsBXp9iUJS3GhEcdTXwc5bw4cyNqJz7cwW+qpiwYjJGggE3KgwHF1TUwUVRimvs5
         MBxj7fI8XH1MFWEbGUd9swUDgMaHI1Si/r15mhzQh45rTUd2FQdlEaBLHUKDd/nP8h
         uCnKJ6Z4cvtYy7DuW9eDkxwxXRDJE9TiUoLmtGNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/529] arm64: dts: qcom: ipq8074: correct Gen2 PCIe ranges
Date:   Fri, 10 Mar 2023 14:32:41 +0100
Message-Id: <20230310133805.851780936@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 2055cb7dccea16bafa3adf9c5e3216949512c34a ]

Current ranges property set in Gen2 PCIe node is incorrect, replace it
with the downstream 5.4 QCA kernel value.

Fixes: 33057e1672fe ("ARM: dts: ipq8074: Add pcie nodes")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230113164449.906002-3-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 98f0001fc7092..1dbae9c73c590 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -610,9 +610,9 @@ pcie1: pci@10000000 {
 			phy-names = "pciephy";
 
 			ranges = <0x81000000 0 0x10200000 0x10200000
-				  0 0x100000   /* downstream I/O */
-				  0x82000000 0 0x10300000 0x10300000
-				  0 0xd00000>; /* non-prefetchable memory */
+				  0 0x10000>,   /* downstream I/O */
+				 <0x82000000 0 0x10220000 0x10220000
+				  0 0xfde0000>; /* non-prefetchable memory */
 
 			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
-- 
2.39.2



