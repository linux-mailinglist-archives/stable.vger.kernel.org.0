Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8523740E2C4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244224AbhIPQl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244574AbhIPQjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:39:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08ED06141B;
        Thu, 16 Sep 2021 16:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809391;
        bh=xy6Pskwf2LsTKup1sy1FUidV65P0qDqckPExucv4B0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K89IifLbRF6Clmxdp1MNFIjAa0JhcGdOBr3kXWxrRw/GH/w7E4ce99lVhw1i0JTeQ
         1FAy2g1rbBQUb3DMUzBFl8nbi25SDSRM8uXKa7uKK/N/IMKZ3lTd9K3WFqlFK7EPh6
         GlyKwgqVcIMeRJrhfQdQ0IxDOwNxVaSXptDEbgqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 136/380] MIPS: Malta: fix alignment of the devicetree buffer
Date:   Thu, 16 Sep 2021 17:58:13 +0200
Message-Id: <20210916155808.664885362@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit bea6a94a279bcbe6b2cde348782b28baf12255a5 ]

Starting with following patch MIPS Malta is not able to boot:
| commit 79edff12060fe7772af08607eff50c0e2486c5ba
| Author: Rob Herring <robh@kernel.org>
| scripts/dtc: Update to upstream version v1.6.0-51-g183df9e9c2b9

The reason is the alignment test added to the fdt_ro_probe_(). To fix
this issue, we need to make sure that fdt_buf is aligned.

Since the dtc patch was designed to uncover potential issue, I handle
initial MIPS Malta patch as initial bug.

Fixes: e81a8c7dabac ("MIPS: Malta: Setup RAM regions via DT")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mti-malta/malta-dtshim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/mti-malta/malta-dtshim.c b/arch/mips/mti-malta/malta-dtshim.c
index 0ddf03df6268..f451268f6c38 100644
--- a/arch/mips/mti-malta/malta-dtshim.c
+++ b/arch/mips/mti-malta/malta-dtshim.c
@@ -22,7 +22,7 @@
 #define  ROCIT_CONFIG_GEN1_MEMMAP_SHIFT	8
 #define  ROCIT_CONFIG_GEN1_MEMMAP_MASK	(0xf << 8)
 
-static unsigned char fdt_buf[16 << 10] __initdata;
+static unsigned char fdt_buf[16 << 10] __initdata __aligned(8);
 
 /* determined physical memory size, not overridden by command line args	 */
 extern unsigned long physical_memsize;
-- 
2.30.2



