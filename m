Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA0F412018
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349125AbhITRsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343789AbhITRqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C155617E3;
        Mon, 20 Sep 2021 17:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157831;
        bh=X7FP2Fj0bKKDeKQlga/svbnU86ocAnDdN+DJdKh3Y4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Imy6g277kqaivpiZQlL92q+jzteAUf9Zx9/tmPA2v60wIsW2yhHriGVrX5Ev2C/Os
         a+btJ78kXTvyBDFfWc3r+7wni77aIxAPxPlkcXMN6tsUiGC+OvEIBtr+rdizmPl4Yi
         TGO+zdGc/XBWUI4nj9vpfAJST799nmXcKZ92Y7SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 170/293] MIPS: Malta: fix alignment of the devicetree buffer
Date:   Mon, 20 Sep 2021 18:42:12 +0200
Message-Id: <20210920163939.105755190@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index 7859b6e49863..5b5d78a7882a 100644
--- a/arch/mips/mti-malta/malta-dtshim.c
+++ b/arch/mips/mti-malta/malta-dtshim.c
@@ -26,7 +26,7 @@
 #define  ROCIT_CONFIG_GEN1_MEMMAP_SHIFT	8
 #define  ROCIT_CONFIG_GEN1_MEMMAP_MASK	(0xf << 8)
 
-static unsigned char fdt_buf[16 << 10] __initdata;
+static unsigned char fdt_buf[16 << 10] __initdata __aligned(8);
 
 /* determined physical memory size, not overridden by command line args	 */
 extern unsigned long physical_memsize;
-- 
2.30.2



