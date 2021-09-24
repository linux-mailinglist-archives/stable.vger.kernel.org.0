Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23519417410
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345775AbhIXNCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345264AbhIXNAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:00:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E185F6128E;
        Fri, 24 Sep 2021 12:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488021;
        bh=yR7i2vPpuJOZKQF1r18UGjDnhdFcH20ce3w5vWdmXo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EidnCE0bhYMuCzrIzy3igOyVwE45rkqkzYSqLoEAX3qMmqCQUyEKf3eCeRO4+SpvE
         P1rM3fhG+TXS90xiDXG1q9mD2s0J8WVft9fT7BLqIYEOJOWlzBtIFzW44AxVZzI6Cs
         I9UEvOdPc7LJkVuxYGQEJQW+Z3A7bzPqPis8Fv8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Bin Meng <bmeng.cn@gmail.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 053/100] riscv: dts: microchip: mpfs-icicle: Fix serial console
Date:   Fri, 24 Sep 2021 14:44:02 +0200
Message-Id: <20210924124343.212634492@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit cbba17870881cd17bca24673ccb72859431da5bd ]

Currently, nothing is output on the serial console, unless
"console=ttyS0,115200n8" or "earlycon" are appended to the kernel
command line.  Enable automatic console selection using
chosen/stdout-path by adding a proper alias, and configure the expected
serial rate.

While at it, add aliases for the other three serial ports, which are
provided on the same micro-USB connector as the first one.

Fixes: 0fa6107eca4186ad ("RISC-V: Initial DTS for Microchip ICICLE board")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Bin Meng <bmeng.cn@gmail.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
index baea7d204639..b254c60589a1 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
@@ -16,10 +16,14 @@
 
 	aliases {
 		ethernet0 = &emac1;
+		serial0 = &serial0;
+		serial1 = &serial1;
+		serial2 = &serial2;
+		serial3 = &serial3;
 	};
 
 	chosen {
-		stdout-path = &serial0;
+		stdout-path = "serial0:115200n8";
 	};
 
 	cpus {
-- 
2.33.0



