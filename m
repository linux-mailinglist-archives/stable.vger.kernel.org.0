Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EDD2E646A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403998AbgL1Nlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391674AbgL1NlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:41:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EB6B21D94;
        Mon, 28 Dec 2020 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162858;
        bh=a3VtAI9EWvHTMsREjZvzqzchoZk68QqwDXfiu3G1nnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBz+AcTO8mI8C1uDfKJdbkn+zOzfdVFVeP56YQCCYIFWG+GpE7Ut3jNOTALeHt1vn
         XvUJBzR7tzAo4eUDk9zEOEQwvuQ0Ubk6oYOGu5Oc2xzsjsfq/DPvzLXT4fD4NSKcFa
         Bd1HziZHLbhpNgEcASdM1AriwQv44fvy+1fP3yuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Wang <wangzhiqiang.bj@bytedance.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/453] ARM: dts: aspeed: s2600wf: Fix VGA memory region location
Date:   Mon, 28 Dec 2020 13:45:22 +0100
Message-Id: <20201228124941.369267197@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 9e1cc9679776f5b9e42481d392b1550753ebd084 ]

The VGA memory region is always from the top of RAM. On this board, that
is 0x80000000 + 0x20000000 - 0x01000000 = 0x9f000000.

This was not an issue in practice as the region is "reserved" by the
vendor's u-boot reducing the amount of available RAM, and the only user
is the host VGA device poking at RAM over PCIe. That is, nothing from
the ARM touches it.

It is worth fixing as developers copy existing device trees when
building their machines, and the XDMA driver does use the memory region
from the ARM side.

Fixes: c4043ecac34a ("ARM: dts: aspeed: Add S2600WF BMC Machine")
Reported-by: John Wang <wangzhiqiang.bj@bytedance.com>
Link: https://lore.kernel.org/r/20200922064234.163799-1-joel@jms.id.au
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts b/arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts
index 22dade6393d06..d1dbe3b6ad5a7 100644
--- a/arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts
@@ -22,9 +22,9 @@
 		#size-cells = <1>;
 		ranges;
 
-		vga_memory: framebuffer@7f000000 {
+		vga_memory: framebuffer@9f000000 {
 			no-map;
-			reg = <0x7f000000 0x01000000>;
+			reg = <0x9f000000 0x01000000>; /* 16M */
 		};
 	};
 
-- 
2.27.0



