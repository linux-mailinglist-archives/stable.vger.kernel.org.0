Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950CE34C58B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhC2IBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231513AbhC2IAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:00:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7613761969;
        Mon, 29 Mar 2021 08:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004849;
        bh=Xyq1iw2ZoZ1AeWPBrtp0JAGNybiaIz6RS3ZngnT7IqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2lbuEkLVPg2Rk/85cZNm1TWk9tmiLcemNLfmlq1bWlovAuiikWoifcWvICbwdoLv
         e1h4aPwFBziXjRoC4a3e7VrLHhcH0/zMyiKiqhHSIFyaqnli7/oelVvMCcjmYkhBe7
         FCtjqXMm9JYNFccXLeydOjOHLIyzx8CPk8HwHKSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 22/33] e1000e: Fix error handling in e1000_set_d0_lplu_state_82571
Date:   Mon, 29 Mar 2021 09:58:07 +0200
Message-Id: <20210329075605.977615447@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
References: <20210329075605.290845195@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit b52912b8293f2c496f42583e65599aee606a0c18 ]

There is one e1e_wphy() call in e1000_set_d0_lplu_state_82571
that we have caught its return value but lack further handling.
Check and terminate the execution flow just like other e1e_wphy()
in this function.

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/82571.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethernet/intel/e1000e/82571.c
index 5f7016442ec4..e486f351a54a 100644
--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -917,6 +917,8 @@ static s32 e1000_set_d0_lplu_state_82571(struct e1000_hw *hw, bool active)
 	} else {
 		data &= ~IGP02E1000_PM_D0_LPLU;
 		ret_val = e1e_wphy(hw, IGP02E1000_PHY_POWER_MGMT, data);
+		if (ret_val)
+			return ret_val;
 		/* LPLU and SmartSpeed are mutually exclusive.  LPLU is used
 		 * during Dx states where the power conservation is most
 		 * important.  During driver activity we should enable
-- 
2.30.1



