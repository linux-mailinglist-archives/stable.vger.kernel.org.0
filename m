Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444FC35C08C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240257AbhDLJOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240826AbhDLJLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5837461373;
        Mon, 12 Apr 2021 09:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218406;
        bh=QxmsrCTn/9n1/8aQBFIoSviyTKNO6UzZHOjKMK600qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVJn95rcgv3CDVn4pFKkmEcsWPrNBPFN3t0AjOFNQKpplxJ8i0xLVht1FakjIlu6R
         dEK+PX4xfg6ZoH7QUpHmyuiN4n7EbmgP/ciA0h0BpWfV+5A5iQNY9LXjQBVkHpwF/b
         7F1xA3AacNqTBvtoHQ00Ym8NZW8Bspg12rUPI/zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 186/210] i40e: Fix parameters in aq_get_phy_register()
Date:   Mon, 12 Apr 2021 10:41:31 +0200
Message-Id: <20210412084022.194581946@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

[ Upstream commit b2d0efc4be7ed320e33eaa9b6dd6f3f6011ffb8e ]

Change parameters order in aq_get_phy_register() due to wrong
statistics in PHY reported by ethtool. Previously all PHY statistics were
exactly the same for all interfaces
Now statistics are reported correctly - different for different interfaces

Fixes: 0514db37dd78 ("i40e: Extend PHY access with page change flag")
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 849e38be69ff..31d48a85cfaf 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5285,7 +5285,7 @@ static int i40e_get_module_eeprom(struct net_device *netdev,
 
 		status = i40e_aq_get_phy_register(hw,
 				I40E_AQ_PHY_REG_ACCESS_EXTERNAL_MODULE,
-				true, addr, offset, &value, NULL);
+				addr, true, offset, &value, NULL);
 		if (status)
 			return -EIO;
 		data[i] = value;
-- 
2.30.2



