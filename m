Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEF7499FCB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842179AbiAXXBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382818AbiAXWjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D962C055A8C;
        Mon, 24 Jan 2022 13:03:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E24C4611C8;
        Mon, 24 Jan 2022 21:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6783C340E5;
        Mon, 24 Jan 2022 21:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058220;
        bh=Dm1rBUKIAFcXxvuutpMut0aM2fwHRehNyKyaSmdh4gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPZGN+QbNie/GxxdVxZaWaBRlIEYzW0Z0erW1cAS29Mj99XJXOBC/9cvZv80K7R9/
         ul4CfSXLf38YzfYED++vNZUnsQ06c+1SpwrQ2icDm/RyxA8Zb9f3+NG26AzG6a05/o
         OlsY2Uk3z7vJjvIklIH8I+PhvcWVfcD0AS4ONULY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Nishanth Menon <nm@ti.com>, Pratyush Yadav <p.yadav@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0218/1039] arm64: dts: ti: k3-am642: Fix the L2 cache sets
Date:   Mon, 24 Jan 2022 19:33:27 +0100
Message-Id: <20220124184132.668442862@linuxfoundation.org>
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



