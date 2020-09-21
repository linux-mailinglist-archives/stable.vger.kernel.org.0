Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C7D272F0A
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgIUQqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgIUQqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D1923788;
        Mon, 21 Sep 2020 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706766;
        bh=KuQ7WsiQdU7W+wsv5xwC3uJiGeKES0h4kXV6+8tt670=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/tP1tpiZg15FcI6e5dg2Tjd8KZDKhzjf9+9fLRD42yIeFZaMpPJcQmyUqrxEiUwb
         ytABo8Wn/jFqElWMG1GKMppGX6PTNMuDtZuyAGb946CtysDyitlxLgDXvThgwFwhxn
         oPrfX8weu5rRapTdpsQ9jh4tr8Te/gipKnwyX6tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 058/118] MIPS: SNI: Fix MIPS_L1_CACHE_SHIFT
Date:   Mon, 21 Sep 2020 18:27:50 +0200
Message-Id: <20200921162039.045341333@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
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
index c43ad3b3cea4b..daa24f1e14831 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -876,6 +876,7 @@ config SNI_RM
 	select I8253
 	select I8259
 	select ISA
+	select MIPS_L1_CACHE_SHIFT_6
 	select SWAP_IO_SPACE if CPU_BIG_ENDIAN
 	select SYS_HAS_CPU_R4X00
 	select SYS_HAS_CPU_R5000
-- 
2.25.1



