Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5D934CA36
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhC2Ifx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233919AbhC2IeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:34:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAC6E61990;
        Mon, 29 Mar 2021 08:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006864;
        bh=0lk667QrNTk1uGXBGMcmQArzTf7hHjurO3OmPT+KT2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgNiMfqHK/CzzcY087qzGQSSLkvVWMzrOvTUt03BsTlj3cBStkCn5XjwmEQWGBQL4
         x57Kh9lIyoyKNQFLahzMViXAF5rQi5x0B4rxighRiUEhCBIVRKpsgH/zkSMjRpTlbp
         vHH0TQdqHxEdXj3jkQdYewPA337b/gKvwbe0cfCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 130/254] e1000e: Fix error handling in e1000_set_d0_lplu_state_82571
Date:   Mon, 29 Mar 2021 09:57:26 +0200
Message-Id: <20210329075637.499939896@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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
index 88faf05e23ba..0b1e890dd583 100644
--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -899,6 +899,8 @@ static s32 e1000_set_d0_lplu_state_82571(struct e1000_hw *hw, bool active)
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



