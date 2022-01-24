Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AB249A946
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322395AbiAYDVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58004 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381446AbiAXUVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:21:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 614F8B8122C;
        Mon, 24 Jan 2022 20:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7D1C340E5;
        Mon, 24 Jan 2022 20:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055656;
        bh=ZV5HV4yIdtV5ntz4t1mdryE/e6V6+2VSPr1fY2mhDGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dgHmPs+mmlSJ4JCJ7wR6fWJnB1ZQ8saalYn0lv+IsaoIelxWQE0wVEEytj499mBCu
         Lh/hzwRZ8ufEE7b6Wiv4eSc5iJgCKv8nQnHGd5NN9D6FdmiR3TaE5ywNgmYXxqloTK
         kCqvImFEc0wtqbg/WAhbwfIjwLpo/kpHu5UojAJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Nishanth Menon <nm@ti.com>, Pratyush Yadav <p.yadav@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/846] arm64: dts: ti: k3-j721e: Fix the L2 cache sets
Date:   Mon, 24 Jan 2022 19:35:06 +0100
Message-Id: <20220124184107.482522621@linuxfoundation.org>
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

From: Nishanth Menon <nm@ti.com>

[ Upstream commit e9ba3a5bc6fdc2c796c69fdaf5ed6c9957cf9f9d ]

A72's L2 cache[1] on J721e[2] is 1MB. A72's L2 is fixed line length of
64 bytes and 16-way set-associative cache structure.

1MB of L2 / 64 (line length) = 16384 ways
16384 ways / 16 = 1024 sets

Fix the l2 cache-sets.

[1] https://developer.arm.com/documentation/100095/0003/Level-2-Memory-System/About-the-L2-memory-system
[2] http://www.ti.com/lit/pdf/spruil1

Fixes: 2d87061e70de ("arm64: dts: ti: Add Support for J721E SoC")
Reported-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20211113043639.4413-1-nm@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e.dtsi b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
index 9f1d25d57a693..69ce048a2136e 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
@@ -85,7 +85,7 @@
 		cache-level = <2>;
 		cache-size = <0x100000>;
 		cache-line-size = <64>;
-		cache-sets = <2048>;
+		cache-sets = <1024>;
 		next-level-cache = <&msmc_l3>;
 	};
 
-- 
2.34.1



