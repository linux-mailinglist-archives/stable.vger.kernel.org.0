Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A8914E15A
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgA3Sno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730669AbgA3Snm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5351220702;
        Thu, 30 Jan 2020 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409821;
        bh=xBAQKyC0AsVCHmL2t4Iz7axXC042L292E53iu+qs9zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6fKpJ+Q3s6Gi6kAx9RNaOXTY6M3kgn87cZsMZS/kRUciicU0iF6uf3hAIJgy5LTS
         wMt+zDf33cRPAUcOsIAigPC6070Sb9EnnFT6qiIptEB0c0F4OceFXuTNhVPBvUJt6X
         DVqnIK6HiFOqaq0Ty0epe0b1U4d7iWzr7hjp4E44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Ofer Levi <oferle@mellanox.com>,
        linux-snps-arc@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/110] arc: eznps: fix allmodconfig kconfig warning
Date:   Thu, 30 Jan 2020 19:38:21 +0100
Message-Id: <20200130183620.661346897@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1928b36cfa4df1aeedf5f2644d0c33f3a1fcfd7b ]

Fix kconfig warning for arch/arc/plat-eznps/Kconfig allmodconfig:

WARNING: unmet direct dependencies detected for CLKSRC_NPS
  Depends on [n]: GENERIC_CLOCKEVENTS [=y] && !PHYS_ADDR_T_64BIT [=y]
  Selected by [y]:
  - ARC_PLAT_EZNPS [=y]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Ofer Levi <oferle@mellanox.com>
Cc: linux-snps-arc@lists.infradead.org
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/plat-eznps/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/plat-eznps/Kconfig b/arch/arc/plat-eznps/Kconfig
index a376a50d3fea8..a931d0a256d01 100644
--- a/arch/arc/plat-eznps/Kconfig
+++ b/arch/arc/plat-eznps/Kconfig
@@ -7,7 +7,7 @@
 menuconfig ARC_PLAT_EZNPS
 	bool "\"EZchip\" ARC dev platform"
 	select CPU_BIG_ENDIAN
-	select CLKSRC_NPS
+	select CLKSRC_NPS if !PHYS_ADDR_T_64BIT
 	select EZNPS_GIC
 	select EZCHIP_NPS_MANAGEMENT_ENET if ETHERNET
 	help
-- 
2.20.1



