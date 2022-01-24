Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB007499707
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377514AbiAXVIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:08:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54560 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349038AbiAXVDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:03:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE630B80FA3;
        Mon, 24 Jan 2022 21:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC72C340E5;
        Mon, 24 Jan 2022 21:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058223;
        bh=ADv0iZs0sl/IyTkiljN2Vy1lVQBg5V8EIXUeP+R8lTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qu8GIGKZytjBZtEBlqLmYN/tvgl2A0Qev16GrrXBo89CwM7yamIJM7ELBU7M4o12+
         j6L8yzUiFMtSIakoNPuSHMPiYKb0eOsvNKIoN+7CJZgZhOTU16X3ZKiWniwK7P7geD
         T4Uxh1MsPAEa6EbAxl5hkqjaZPehEg1VMnmGWj4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Nishanth Menon <nm@ti.com>, Pratyush Yadav <p.yadav@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0219/1039] arm64: dts: ti: k3-j7200: Fix the L2 cache sets
Date:   Mon, 24 Jan 2022 19:33:28 +0100
Message-Id: <20220124184132.698679219@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 47567cb260c2b..a99a4d305b7ec 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200.dtsi
@@ -86,7 +86,7 @@
 		cache-level = <2>;
 		cache-size = <0x100000>;
 		cache-line-size = <64>;
-		cache-sets = <2048>;
+		cache-sets = <1024>;
 		next-level-cache = <&msmc_l3>;
 	};
 
-- 
2.34.1



