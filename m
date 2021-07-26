Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6F63D6016
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbhGZPUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237059AbhGZPUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C74A860230;
        Mon, 26 Jul 2021 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315269;
        bh=N40JcgCPP9hvMeVyaarL3PU5o/XNejtRD/tFbQNUwAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPJPl9jl1p52/aaSRCadDpduM2PzdxOiMoepUkSyJkbphR8AeE7LN+aUxPG76Mt66
         tZQWD1/sgeLk2OOy9SznOJ86OKnbS+rHXKZpDnT3Kt8EUOOulZzPfEIHVaV+YIb2PV
         Cx6+SDYfoxQaDLLH4wXlm9ftcnEm/Tg/kOnkPqto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/167] igc: change default return of igc_read_phy_reg()
Date:   Mon, 26 Jul 2021 17:37:16 +0200
Message-Id: <20210726153839.489237324@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 05682a0a61b6cbecd97a0f37f743b2cbfd516977 ]

Static analysis reports this problem

igc_main.c:4944:20: warning: The left operand of '&'
  is a garbage value
    if (!(phy_data & SR_1000T_REMOTE_RX_STATUS) &&
          ~~~~~~~~ ^

phy_data is set by the call to igc_read_phy_reg() only if
there is a read_reg() op, else it is unset and a 0 is
returned.  Change the return to -EOPNOTSUPP.

Fixes: 208983f099d9 ("igc: Add watchdog")
Signed-off-by: Tom Rix <trix@redhat.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 6dca67d9c25d..a97bf7a5f1d6 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -532,7 +532,7 @@ static inline s32 igc_read_phy_reg(struct igc_hw *hw, u32 offset, u16 *data)
 	if (hw->phy.ops.read_reg)
 		return hw->phy.ops.read_reg(hw, offset, data);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 void igc_reinit_locked(struct igc_adapter *);
-- 
2.30.2



