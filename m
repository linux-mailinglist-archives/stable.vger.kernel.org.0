Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF139272DA4
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbgIUQmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgIUQlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 637D723A03;
        Mon, 21 Sep 2020 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706505;
        bh=uVq9Nx2RABCHIQ8YWyLk4Ps/+0C6uuO8kjrxm/L2hd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oX+15TjmdMX5fowKV9+LUBE/tsbX+D5OwVeXahmPEoqZMwYe3rrXie0eyCfBxOuUI
         z2wkddFhGUXQVIHsAO+uoDqo/k5AGYArL9ahN7OSLlgKHi8JjmEET5Em9RnX75oOfa
         U5izAgPvZBrvvoLDODA4j5HU+83q3/8wr2oJWrx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/49] MIPS: SNI: Fix MIPS_L1_CACHE_SHIFT
Date:   Mon, 21 Sep 2020 18:28:15 +0200
Message-Id: <20200921162036.027407105@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit 564c836fd945a94b5dd46597d6b7adb464092650 ]

Commit 930beb5ac09a ("MIPS: introduce MIPS_L1_CACHE_SHIFT_<N>") forgot
to select the correct MIPS_L1_CACHE_SHIFT for SNI RM. This breaks non
coherent DMA because of a wrong allocation alignment.

Fixes: 930beb5ac09a ("MIPS: introduce MIPS_L1_CACHE_SHIFT_<N>")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index a830a9701e501..cc8c8d22afaf5 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -852,6 +852,7 @@ config SNI_RM
 	select I8253
 	select I8259
 	select ISA
+	select MIPS_L1_CACHE_SHIFT_6
 	select SWAP_IO_SPACE if CPU_BIG_ENDIAN
 	select SYS_HAS_CPU_R4X00
 	select SYS_HAS_CPU_R5000
-- 
2.25.1



