Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60EF5938C1
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbiHOSjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243531AbiHOSiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:38:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5D43C8FA;
        Mon, 15 Aug 2022 11:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C83CB81062;
        Mon, 15 Aug 2022 18:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22A8C43470;
        Mon, 15 Aug 2022 18:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587817;
        bh=Kuj2M50v7Es9mL0wqjafMAdtgSOCl8NrfZFfG2xdwaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhluwB92tWLvpwfm7XHdHZ2rq/no9z8wA1i5ICXrKqiwhgSL2ICrLlp7EISW1XGRk
         L2bz0eApZdzI8lfPy2SUq/wD2krtrng6GF8xuM8KWSHEMCluCkhndtc0VlUR45x5QT
         DeshPXzI0w6ZmRlepAEpU+Cny9c4SDqHjltjCVx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Yousaf Kaukab <ykaukab@suse.de>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/779] arm64: tegra: Mark BPMP channels as no-memory-wc
Date:   Mon, 15 Aug 2022 19:57:29 +0200
Message-Id: <20220815180346.035505502@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 61192a9d8a6367ae1b8234876941b037910a2459 ]

The Tegra SYSRAM contains regions access to which is restricted to
certain hardware blocks on the system, and speculative accesses to
those will cause issues.

Patch 'misc: sram: Only map reserved areas in Tegra SYSRAM' attempted
to resolve this by only mapping the regions specified in the device
tree on the assumption that there are no such restricted areas within
the 64K-aligned area of memory that contains the memory we wish to map.

Turns out this assumption is wrong, as there are such areas above the
4K pages described in the device trees. As such, we need to use the
bigger hammer that is no-memory-wc, which causes the memory to be
mapped as Device memory to which speculative accesses are disallowed.

As such, the previous patch in the series,
  'firmware: tegra: bpmp: do only aligned access to IPC memory area',
is required with this patch to make the BPMP driver only issue aligned
memory accesses as those are also required with Device memory.

Fixes: fec29bf04994 ("misc: sram: Only map reserved areas in Tegra SYSRAM")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Reviewed-by: Yousaf Kaukab <ykaukab@suse.de>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra186.dtsi | 1 +
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 1 +
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra186.dtsi b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
index 8354512d7b1c..5b0bc9aa1a42 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -1583,6 +1583,7 @@ sram@30000000 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0x30000000 0x50000>;
+		no-memory-wc;
 
 		cpu_bpmp_tx: sram@4e000 {
 			reg = <0x4e000 0x1000>;
diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index a56fb83839a4..ca71b71d801a 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -2249,6 +2249,7 @@ sram@40000000 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0x40000000 0x50000>;
+		no-memory-wc;
 
 		cpu_bpmp_tx: sram@4e000 {
 			reg = <0x4e000 0x1000>;
diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 144a7eb699a7..2b4784572220 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -128,6 +128,7 @@ sram@40000000 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0x40000000 0x80000>;
+		no-memory-wc;
 
 		cpu_bpmp_tx: sram@70000 {
 			reg = <0x70000 0x1000>;
-- 
2.35.1



