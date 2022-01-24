Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEE6499466
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389518AbiAXUld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:41:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40570 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351907AbiAXUhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:37:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3330BB81061;
        Mon, 24 Jan 2022 20:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A7AC340E5;
        Mon, 24 Jan 2022 20:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056669;
        bh=9al30aZ+w+f56itTZnfhDZfSCut72/YNcJcpvw4L33c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8KJmpyiWA6Zp1GiLOR1MDcvlrMi3ILb/u0No92GlemAKqhN8RJ7oZiTRz2/bzc+l
         XWIp/8iNDQFJkt6vtsflmadm3BZJ9MSr++W5LZnKf2QQWvHhjplLE6+2uUkJwLC1wY
         XVtqCoH8j+iEN7C+PpTO1W3hmbvyoAK1tE4UCt2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 561/846] arm64: tegra: Adjust length of CCPLEX cluster MMIO region
Date:   Mon, 24 Jan 2022 19:41:18 +0100
Message-Id: <20220124184120.376492793@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index e94f8add1a400..062e87e893316 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -1079,7 +1079,7 @@
 
 	ccplex@e000000 {
 		compatible = "nvidia,tegra186-ccplex-cluster";
-		reg = <0x0 0x0e000000 0x0 0x3fffff>;
+		reg = <0x0 0x0e000000 0x0 0x400000>;
 
 		nvidia,bpmp = <&bpmp>;
 	};
-- 
2.34.1



