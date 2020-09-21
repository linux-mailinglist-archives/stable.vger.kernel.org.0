Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC26272E70
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbgIUQtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728998AbgIUQtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:49:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E0892223E;
        Mon, 21 Sep 2020 16:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706951;
        bh=sk+xlE6R8/f9hRtD9WFQpvPiTGRh/U7VGSF0/fUvumA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1dJbfsPk7DAUxuOsGSAEGVD3l/T82iipK4ZQStjsatdxloovy4zYnetNQOyBPJOB
         eIzmOloF5aDuvNnzlJW9yBl8OTqJik3JT7rI8uYoIW+xd0uA2s72tAdpR25yRWHwFd
         cHXgcsyNjX4eY6zvWfT7cmUTZCzKaSAPNyWVLMs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/72] MIPS: SNI: Fix MIPS_L1_CACHE_SHIFT
Date:   Mon, 21 Sep 2020 18:31:18 +0200
Message-Id: <20200921163123.727601600@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
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
index e5c2d47608feb..6ecdc690f7336 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -862,6 +862,7 @@ config SNI_RM
 	select I8253
 	select I8259
 	select ISA
+	select MIPS_L1_CACHE_SHIFT_6
 	select SWAP_IO_SPACE if CPU_BIG_ENDIAN
 	select SYS_HAS_CPU_R4X00
 	select SYS_HAS_CPU_R5000
-- 
2.25.1



