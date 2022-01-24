Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6304992A6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348128AbiAXUW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:22:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45116 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348294AbiAXUUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:20:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DDD261008;
        Mon, 24 Jan 2022 20:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621C1C340E5;
        Mon, 24 Jan 2022 20:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055650;
        bh=Dm1rBUKIAFcXxvuutpMut0aM2fwHRehNyKyaSmdh4gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUCtx2XwiniposdNcLbwkjaSZF5jPl1ECr84iLZ8ptKgB/qfQWKorOQThvhxVzKxC
         HfQJ42xw0FxrWZr+zTYs3yrM+yUXPeJBE2UKWnKUWadZkN1enyGwoetGvrSXXWJuS8
         d2xNRhPiN5wuh8sB247WVgcUI9c+/pbNi4blmjRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Nishanth Menon <nm@ti.com>, Pratyush Yadav <p.yadav@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/846] arm64: dts: ti: k3-am642: Fix the L2 cache sets
Date:   Mon, 24 Jan 2022 19:35:04 +0100
Message-Id: <20220124184107.421130003@linuxfoundation.org>
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

[ Upstream commit a27a93bf70045be54b594fa8482959ffb84166d7 ]

A53's L2 cache[1] on AM642[2] is 256KB. A53's L2 is fixed line length
of 64 bytes and 16-way set-associative cache structure.

256KB of L2 / 64 (line length) = 4096 ways
4096 ways / 16 = 256 sets

Fix the l2 cache-sets.

[1] https://developer.arm.com/documentation/ddi0500/j/Level-2-Memory-System/About-the-L2-memory-system?lang=en
[2] https://www.ti.com/lit/pdf/spruim2

Fixes: 8abae9389bdb ("arm64: dts: ti: Add support for AM642 SoC")
Reported-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20211113043635.4296-1-nm@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am642.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am642.dtsi b/arch/arm64/boot/dts/ti/k3-am642.dtsi
index e2b397c884018..8a76f4821b11b 100644
--- a/arch/arm64/boot/dts/ti/k3-am642.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am642.dtsi
@@ -60,6 +60,6 @@
 		cache-level = <2>;
 		cache-size = <0x40000>;
 		cache-line-size = <64>;
-		cache-sets = <512>;
+		cache-sets = <256>;
 	};
 };
-- 
2.34.1



