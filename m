Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEBB8CA801
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393043AbfJCQ6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405357AbfJCQr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:47:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D586020865;
        Thu,  3 Oct 2019 16:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121278;
        bh=Q08OWC47QjTSZ3AcIhY2hiw8/byQe913VO0iicauhN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOx2ptJk8GagePc6Nf/177PFFt/ONyF8pF89Ucla3a9e7p3EetuEuLS4LGd1+LxWL
         8dHQlKDKLOa7Ijj7kv7rkSp4gynJxyrLQlAvsCd81MmB2mQs9hsvkIyK9ZGPpY4Omn
         A14GRxkjE4mqfl7SmnW/1VywPpKw2vE+DCvZCwWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 219/344] e1000e: add workaround for possible stalled packet
Date:   Thu,  3 Oct 2019 17:53:04 +0200
Message-Id: <20191003154601.951208105@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit e5e9a2ecfe780975820e157b922edee715710b66 ]

This works around a possible stalled packet issue, which may occur due to
clock recovery from the PCH being too slow, when the LAN is transitioning
from K1 at 1G link speed.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204057

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 10 ++++++++++
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 395b057014809..a1fab77b2096a 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1429,6 +1429,16 @@ static s32 e1000_check_for_copper_link_ich8lan(struct e1000_hw *hw)
 			else
 				phy_reg |= 0xFA;
 			e1e_wphy_locked(hw, I217_PLL_CLOCK_GATE_REG, phy_reg);
+
+			if (speed == SPEED_1000) {
+				hw->phy.ops.read_reg_locked(hw, HV_PM_CTRL,
+							    &phy_reg);
+
+				phy_reg |= HV_PM_CTRL_K1_CLK_REQ;
+
+				hw->phy.ops.write_reg_locked(hw, HV_PM_CTRL,
+							     phy_reg);
+			}
 		}
 		hw->phy.ops.release(hw);
 
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index eb09c755fa172..1502895eb45dd 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -210,7 +210,7 @@
 
 /* PHY Power Management Control */
 #define HV_PM_CTRL		PHY_REG(770, 17)
-#define HV_PM_CTRL_PLL_STOP_IN_K1_GIGA	0x100
+#define HV_PM_CTRL_K1_CLK_REQ		0x200
 #define HV_PM_CTRL_K1_ENABLE		0x4000
 
 #define I217_PLL_CLOCK_GATE_REG	PHY_REG(772, 28)
-- 
2.20.1



