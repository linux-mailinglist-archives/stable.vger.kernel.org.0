Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23579272D63
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbgIUQjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728881AbgIUQjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:39:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEF41206DC;
        Mon, 21 Sep 2020 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706385;
        bh=FZM8Vgi0E2GJqrVyTjlJqYUYBD/goa7fKzGFyyL0sKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrSUpLtp6bI5xRSf+6R46DhU54z/oxQQ6kx+KVkz9LT8bRznZHnqFB18+Ub1gpzSc
         kXn20f94U0b7ibSEe2ooHkXgsR0LiWnWcCOWzi+2c44TOCvP7KGs5mEg9sdrP7w5nM
         oKxQAecizjD4ezPA39O1GFcsFtGXqxKCBB7Wj/MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 78/94] MIPS: SNI: Fix MIPS_L1_CACHE_SHIFT
Date:   Mon, 21 Sep 2020 18:28:05 +0200
Message-Id: <20200921162039.105517490@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
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
index 7e267d657c561..49c540790fd2d 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -856,6 +856,7 @@ config SNI_RM
 	select I8253
 	select I8259
 	select ISA
+	select MIPS_L1_CACHE_SHIFT_6
 	select SWAP_IO_SPACE if CPU_BIG_ENDIAN
 	select SYS_HAS_CPU_R4X00
 	select SYS_HAS_CPU_R5000
-- 
2.25.1



