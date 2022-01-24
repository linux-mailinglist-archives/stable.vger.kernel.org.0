Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A7649970B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351679AbiAXVIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:08:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56860 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359775AbiAXVDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:03:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 037DCB8121C;
        Mon, 24 Jan 2022 21:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078DAC340E5;
        Mon, 24 Jan 2022 21:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058232;
        bh=VKX05wfh6KhMj0LJnraims849/IJbL0sepFPZ7AWILw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnFhl39v3Wx9Uo/TM9zcXZiiyG7R1roaw8hH6kMuMDqDnxEwVbCLMePeLsVLyZbkj
         2KZQPKtbCDoXdrTT2Y/Jt11mPM8m9Wx0sWnmvE/YKSf7QDuh6dv+yGp//1hSTvNyXJ
         8hKxg5RSmzMvwV2ilnPlGcAgJZeGw3qKoN5fe+Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Nishanth Menon <nm@ti.com>, Pratyush Yadav <p.yadav@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0221/1039] arm64: dts: ti: k3-j7200: Correct the d-cache-sets info
Date:   Mon, 24 Jan 2022 19:33:30 +0100
Message-Id: <20220124184132.769976712@linuxfoundation.org>
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

[ Upstream commit a172c86931709d6663318609d71a811333bdf4b0 ]

A72 Cluster (chapter 1.3.1 [1]) has 48KB Icache, 32KB Dcache and 1MB L2 Cache
 - ICache is 3-way set-associative
 - Dcache is 2-way set-associative
 - Line size are 64bytes

32KB (Dcache)/64 (fixed line length of 64 bytes) = 512 ways
512 ways / 2 (Dcache is 2-way per set) = 256 sets.

So, correct the d-cache-sets info.

[1] https://www.ti.com/lit/pdf/spruiu1

Fixes: d361ed88455f ("arm64: dts: ti: Add support for J7200 SoC")
Reported-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Reviewed-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20211113042640.30955-1-nm@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200.dtsi b/arch/arm64/boot/dts/ti/k3-j7200.dtsi
index a99a4d305b7ec..64fef4e67d76a 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200.dtsi
@@ -62,7 +62,7 @@
 			i-cache-sets = <256>;
 			d-cache-size = <0x8000>;
 			d-cache-line-size = <64>;
-			d-cache-sets = <128>;
+			d-cache-sets = <256>;
 			next-level-cache = <&L2_0>;
 		};
 
@@ -76,7 +76,7 @@
 			i-cache-sets = <256>;
 			d-cache-size = <0x8000>;
 			d-cache-line-size = <64>;
-			d-cache-sets = <128>;
+			d-cache-sets = <256>;
 			next-level-cache = <&L2_0>;
 		};
 	};
-- 
2.34.1



