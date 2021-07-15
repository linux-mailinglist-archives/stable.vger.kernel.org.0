Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069C03CA70D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbhGOSwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237613AbhGOSvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:51:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 205E0613E0;
        Thu, 15 Jul 2021 18:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374903;
        bh=w7kenwY7PebtwpXn8xTDysd2hrle34h33eXN5aBA4Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUzaNbR2G8ghfRdCOrrYsUnuj9RLwjkm3MTkF86lum6YWLrYOWyDVGVHzl9FmFBGX
         zkIpjrlLm6ZOovdPbvS+eF0j3g4vqQO6Z2t/yYuo42+on2JdizAJWm9sp1xX0evKTG
         IrIXKTydwyhk4F+lxquKRQk+RdTevQIBF+d14l1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Koba Ko <koba.ko@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/215] r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM
Date:   Thu, 15 Jul 2021 20:37:27 +0200
Message-Id: <20210715182612.722383322@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 1ee8856de82faec9bc8bd0f2308a7f27e30ba207 ]

It has been reported that on RTL8106e the link-up interrupt may be
significantly delayed if the user enables ASPM L1. Per default ASPM
is disabled. The change leaves L1 enabled on the PCIe link (thus still
allowing to reach higher package power saving states), but the
NIC won't actively trigger it.

Reported-by: Koba Ko <koba.ko@canonical.com>
Tested-by: Koba Ko <koba.ko@canonical.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a6bf80b52967..9010aabd9782 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3547,7 +3547,6 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 
 	rtl_pcie_state_l2l3_disable(tp);
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)
-- 
2.30.2



