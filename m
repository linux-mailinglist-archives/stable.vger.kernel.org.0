Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC1034C8AD
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhC2IXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233983AbhC2IWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:22:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AC9E61481;
        Mon, 29 Mar 2021 08:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006168;
        bh=OwXO/HiN+vWFBMyr5p8yncZ3dYdxBpPbHIb7UfnZ9O4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSHVMgHn9vfOjLu8IKUZJFcxcgksmlxA9WXcyrWf5h9EZ80B8Yma6SUmHgxzuE+xd
         d7f9+mGhmKEHvD6gqktOYx3lKDNQCBROn7KGQzVU1QDo0IZTVd/UiXyNsxzzQTkw4P
         J1QUTR7Lvxsa/o7aqSZZAefQQIhRgW06RobsClhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Malli C <mallikarjuna.chilakala@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/221] igc: Fix Pause Frame Advertising
Date:   Mon, 29 Mar 2021 09:57:17 +0200
Message-Id: <20210329075632.753359677@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

[ Upstream commit 8876529465c368beafd51a70f79d7a738f2aadf4 ]

Fix Pause Frame Advertising when getting the advertisement via ethtool.
Remove setting the "advertising" bit in link_ksettings during default
case when Tx and Rx are in off state with Auto Negotiate off.

Below is the original output of advertisement link during Tx and Rx off:
Advertised pause frame use: Symmetric Receive-only

Expected output:
Advertised pause frame use: No

Fixes: 8c5ad0dae93c ("igc: Add ethtool support")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Reviewed-by: Malli C <mallikarjuna.chilakala@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index ec8cd69d4992..35c104a02bed 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1709,9 +1709,7 @@ static int igc_ethtool_get_link_ksettings(struct net_device *netdev,
 						     Asym_Pause);
 		break;
 	default:
-		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     Asym_Pause);
+		break;
 	}
 
 	status = pm_runtime_suspended(&adapter->pdev->dev) ?
-- 
2.30.1



