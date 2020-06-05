Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F00C1EFA6C
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgFEORZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728454AbgFEORY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:17:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9F4620835;
        Fri,  5 Jun 2020 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366644;
        bh=apuCjmo26NYIkrsmBlJnUuWxCVNtEFStOXDpG99cVcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lFU3I7iqACAD6E7uxSCTK7EgfFzqeINtr4IRtQMMxVk+LjsZQ20f4V0fFm0kyXAF
         vO+zG2ud79c2nZpudrnqUht5vpFy1TeGa/T4aic43Avj2XRobgzcF66AY2N4wZOdhq
         mb1Y5QNBzV75pcx9NjfzvTaPGw+/TUBEAa1/G+tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 04/43] ARC: [plat-eznps]: Restrict to CONFIG_ISA_ARCOMPACT
Date:   Fri,  5 Jun 2020 16:14:34 +0200
Message-Id: <20200605140152.737938994@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit 799587d5731db9dcdafaac4002463aa7d9cd6cf7 ]

Elide invalid configuration EZNPS + ARCv2, triggered by a
make allyesconfig build.

Granted the root cause is in source code (asm/barrier.h) where we check
for ARCv2 before PLAT_EZNPS, but it is better to avoid such combinations
at onset rather then baking subtle nuances into code.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/plat-eznps/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/plat-eznps/Kconfig b/arch/arc/plat-eznps/Kconfig
index a931d0a256d0..a645bca5899a 100644
--- a/arch/arc/plat-eznps/Kconfig
+++ b/arch/arc/plat-eznps/Kconfig
@@ -6,6 +6,7 @@
 
 menuconfig ARC_PLAT_EZNPS
 	bool "\"EZchip\" ARC dev platform"
+	depends on ISA_ARCOMPACT
 	select CPU_BIG_ENDIAN
 	select CLKSRC_NPS if !PHYS_ADDR_T_64BIT
 	select EZNPS_GIC
-- 
2.25.1



