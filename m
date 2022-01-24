Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EBC49941A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388524AbiAXUjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385588AbiAXUdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EB2C07E2AE;
        Mon, 24 Jan 2022 11:47:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 542DB61551;
        Mon, 24 Jan 2022 19:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3BFC340E7;
        Mon, 24 Jan 2022 19:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053626;
        bh=07SQja4q26FSn9m5TJNZ35JcTZjsRPx9B2FJoLg8HXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+CUE/la9GPjxvhKLIjDFwtv4v85g749Sn7EX/X4WrKvjNzLTpz0xsfrtjjQLWRWu
         g77j9caucFu2zVdc3GETub1T3/AzNTENh+Zuh+yKyEzLiBWwV/vRZ2mCoC7y2hUYpW
         WceG5qQ9z1oEDxdvC3F1fWLBMgH35RrzFk3cAWUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Nishanth Menon <nm@ti.com>, Pratyush Yadav <p.yadav@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/563] arm64: dts: ti: k3-j7200: Fix the L2 cache sets
Date:   Mon, 24 Jan 2022 19:38:10 +0100
Message-Id: <20220124184028.727668425@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

[ Upstream commit d0c826106f3fc11ff97285102b576b65576654ae ]

A72's L2 cache[1] on J7200[2] is 1MB. A72's L2 is fixed line length of
64 bytes and 16-way set-associative cache structure.

1MB of L2 / 64 (line length) = 16384 ways
16384 ways / 16 = 1024 sets

Fix the l2 cache-sets.

[1] https://developer.arm.com/documentation/100095/0003/Level-2-Memory-System/About-the-L2-memory-system
[2] https://www.ti.com/lit/pdf/spruiu1

Fixes: d361ed88455f ("arm64: dts: ti: Add support for J7200 SoC")
Reported-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20211113043638.4358-1-nm@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200.dtsi b/arch/arm64/boot/dts/ti/k3-j7200.dtsi
index 66169bcf7c9a4..081b8f3d44c44 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200.dtsi
@@ -84,7 +84,7 @@
 		cache-level = <2>;
 		cache-size = <0x100000>;
 		cache-line-size = <64>;
-		cache-sets = <2048>;
+		cache-sets = <1024>;
 		next-level-cache = <&msmc_l3>;
 	};
 
-- 
2.34.1



