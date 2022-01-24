Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA21498E2F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354978AbiAXTjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:39:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33078 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348370AbiAXTeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:34:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0245D614DA;
        Mon, 24 Jan 2022 19:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132E2C340E5;
        Mon, 24 Jan 2022 19:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052853;
        bh=LrpabL+wuM/+nyKF87fxZioZKj1x5/6s1eLkOzRY2fU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TI8YxfgyLtVTpnlopVBY9o34bsZzUNfE8xgjfm0RlcUnM9Zc/989kFdzGFc1zjAXo
         0SIeF6MJE3DEBBhEUqo6QdlANhAMXSXQWJjBb53Jh1O0ktJiNPN8af8I1Ig0CtROcZ
         cf/FIhkomdfl5mxHecRUW4CVSJSwdwaV+Puak+5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/320] arm64: tegra: Adjust length of CCPLEX cluster MMIO region
Date:   Mon, 24 Jan 2022 19:42:59 +0100
Message-Id: <20220124184000.275002434@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 2b14cbd643feea5fc17c6e8bead4e71088c69acd ]

The Tegra186 CCPLEX cluster register region is 4 MiB is length, not 4
MiB - 1. This was likely presumed to be the "limit" rather than length.
Fix it up.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra186.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra186.dtsi b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
index 9abf0cb1dd67f..4457262750734 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -709,7 +709,7 @@
 
 	ccplex@e000000 {
 		compatible = "nvidia,tegra186-ccplex-cluster";
-		reg = <0x0 0x0e000000 0x0 0x3fffff>;
+		reg = <0x0 0x0e000000 0x0 0x400000>;
 
 		nvidia,bpmp = <&bpmp>;
 	};
-- 
2.34.1



