Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8791121919
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfLPRvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:51:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbfLPRvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:51:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EFEB206EC;
        Mon, 16 Dec 2019 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518704;
        bh=erO8LhwmHYx3npdBVv16b3/mLdZ9ho5gPtx775lkmY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lS4M5ik+OdDWHmVeIfKG4S71MmGf1YzEEyw2rXsV0jK4zJZHai581QUkhg56AZMJ6
         lYhTkqy0jGMsGvlm5qY83Ez3jlDMqRNOllb9tNEVHl5rEwz0AZFc+L8gZ9MWmL8wc/
         6mfIHlWcKwmczlHQhKU/fb33BSo6fMf6U0wYR2ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mitch Williams <mitch.a.williams@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 033/267] i40e: dont restart nway if autoneg not supported
Date:   Mon, 16 Dec 2019 18:45:59 +0100
Message-Id: <20191216174852.666955803@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

[ Upstream commit 7c3758f7839377ab67529cc50264a640636c47af ]

On link types that do not support autoneg, we cannot attempt to restart
nway negotiation. This results in a dead link that requires a power
cycle to remedy.

Fix this by saving off the autoneg state and checking this value before
we try to restart nway.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index ef22793d6a032..751ac56168843 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -969,6 +969,7 @@ static int i40e_set_pauseparam(struct net_device *netdev,
 	i40e_status status;
 	u8 aq_failures;
 	int err = 0;
+	u32 is_an;
 
 	/* Changing the port's flow control is not supported if this isn't the
 	 * port's controlling PF
@@ -981,15 +982,14 @@ static int i40e_set_pauseparam(struct net_device *netdev,
 	if (vsi != pf->vsi[pf->lan_vsi])
 		return -EOPNOTSUPP;
 
-	if (pause->autoneg != ((hw_link_info->an_info & I40E_AQ_AN_COMPLETED) ?
-	    AUTONEG_ENABLE : AUTONEG_DISABLE)) {
+	is_an = hw_link_info->an_info & I40E_AQ_AN_COMPLETED;
+	if (pause->autoneg != is_an) {
 		netdev_info(netdev, "To change autoneg please use: ethtool -s <dev> autoneg <on|off>\n");
 		return -EOPNOTSUPP;
 	}
 
 	/* If we have link and don't have autoneg */
-	if (!test_bit(__I40E_DOWN, pf->state) &&
-	    !(hw_link_info->an_info & I40E_AQ_AN_COMPLETED)) {
+	if (!test_bit(__I40E_DOWN, pf->state) && !is_an) {
 		/* Send message that it might not necessarily work*/
 		netdev_info(netdev, "Autoneg did not complete so changing settings may not result in an actual change.\n");
 	}
@@ -1040,7 +1040,7 @@ static int i40e_set_pauseparam(struct net_device *netdev,
 		err = -EAGAIN;
 	}
 
-	if (!test_bit(__I40E_DOWN, pf->state)) {
+	if (!test_bit(__I40E_DOWN, pf->state) && is_an) {
 		/* Give it a little more time to try to come back */
 		msleep(75);
 		if (!test_bit(__I40E_DOWN, pf->state))
-- 
2.20.1



