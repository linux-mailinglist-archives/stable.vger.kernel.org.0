Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37359411C62
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345124AbhITRI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344970AbhITRG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:06:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C04596137D;
        Mon, 20 Sep 2021 16:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156920;
        bh=z9Z8xzahhB/bShdXyaFQfx79MMuSCyy/encvtEXFn4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRM1b/6gKmvIN2RsNpEu2At2d7/bkDh6Meqq/ED6E7MtReZBX1nFp7w5kYMK7DLjr
         wZri88h1EP/isyOotjKIqgHVvJEd7UlaaIzNGHDcXJViRCQJm8Ci/nJ9QU0ShZv/Tv
         EJzAqD0wXxlh46bQYljAgkIT5CklDySsFV5VQyzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 104/175] MIPS: Malta: fix alignment of the devicetree buffer
Date:   Mon, 20 Sep 2021 18:42:33 +0200
Message-Id: <20210920163921.476718337@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
index c398582c316f..4fc73ee2ca9d 100644
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



