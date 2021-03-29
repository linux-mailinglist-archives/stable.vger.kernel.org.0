Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE44434CA6C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhC2Iif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234478AbhC2IgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:36:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 892236196F;
        Mon, 29 Mar 2021 08:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006945;
        bh=4TpIWM0Iw3OCYVJdAt9Issv49bFdkaG9NC/gB3Ax5Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrYNDf8zfPhmeXX6IUG6DEBzNrSLEAmUWie8dkEUSGAZYt8rSvepoo6wDvBv9Kq4e
         L3GhImU+1wCfq8WIg/qA+qRTxEp7rNjrDcqgDI4FUzG2BshgAi37749R9PSHsVORRy
         7cjIguNvQR5UFlQuiEr/E0vWva1ByNS5FUr6nmbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Malli C <mallikarjuna.chilakala@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 127/254] igc: Fix Supported Pause Frame Link Setting
Date:   Mon, 29 Mar 2021 09:57:23 +0200
Message-Id: <20210329075637.397781592@linuxfoundation.org>
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

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

[ Upstream commit 9a4a1cdc5ab52118c1f2b216f4240830b6528d32 ]

The Supported Pause Frame always display "No" even though the Advertised
pause frame showing the correct setting based on the pause parameters via
ethtool. Set bit in link_ksettings to "Supported" for Pause Frame.

Before output:
Supported pause frame use: No

Expected output:
Supported pause frame use: Symmetric

Fixes: 8c5ad0dae93c ("igc: Add ethtool support")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Reviewed-by: Malli C <mallikarjuna.chilakala@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 35c104a02bed..da259cd59add 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1695,6 +1695,9 @@ static int igc_ethtool_get_link_ksettings(struct net_device *netdev,
 						     Autoneg);
 	}
 
+	/* Set pause flow control settings */
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+
 	switch (hw->fc.requested_mode) {
 	case igc_fc_full:
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
-- 
2.30.1



