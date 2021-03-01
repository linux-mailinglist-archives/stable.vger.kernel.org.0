Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2ED3290F0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243026AbhCAURt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:17:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242731AbhCAUH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:07:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A202653AD;
        Mon,  1 Mar 2021 17:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621575;
        bh=5TRILHPSNQSwrpi3C8zRzh0O7vUD3+hc0Itf3G1ZPko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=li2oKnL/RA2CSaV42ZbPl76GBy6ZHsbe9R24h54zo3d1UQqwPKfVyVOacycOlRps8
         kf0R5Q0wOVGChecw1zy6s81TCXk4kCW0Spd0wZQAbQuGWDS0tGWHicL2N0elbS0pZy
         ZtRxIFV6L/5e7WJ+5YPO4vNseW3OcbuG0z0lZuwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 527/775] i40e: Fix VFs not created
Date:   Mon,  1 Mar 2021 17:11:35 +0100
Message-Id: <20210301161227.555368731@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

[ Upstream commit dc8812626440fa6a27f1f3f654f6dc435e042e42 ]

When creating VFs they were sometimes not getting resources.
It was caused by not executing i40e_reset_all_vfs due to
flag __I40E_VF_DISABLE being set on PF. Because of this
IAVF was never able to finish setup sequence never
getting reset indication from PF.
Changed test_and_set_bit __I40E_VF_DISABLE in
i40e_sync_filters_subtask to test_bit and removed clear_bit.
This function should not set this bit it should only check
if it hasn't been already set.

Fixes: a7542b876075 ("i40e: check __I40E_VF_DISABLE bit in i40e_sync_filters_subtask")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b268adb3e1d44..3ca5644785556 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2616,7 +2616,7 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 		return;
 	if (!test_and_clear_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state))
 		return;
-	if (test_and_set_bit(__I40E_VF_DISABLE, pf->state)) {
+	if (test_bit(__I40E_VF_DISABLE, pf->state)) {
 		set_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state);
 		return;
 	}
@@ -2634,7 +2634,6 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 			}
 		}
 	}
-	clear_bit(__I40E_VF_DISABLE, pf->state);
 }
 
 /**
-- 
2.27.0



