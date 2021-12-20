Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9692247AF4B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbhLTPKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239975AbhLTPJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E415C08E853;
        Mon, 20 Dec 2021 06:55:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09C1FB80EF0;
        Mon, 20 Dec 2021 14:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593CBC36AE8;
        Mon, 20 Dec 2021 14:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012139;
        bh=Kz054QXRxPiD/AhIpjJ+D5AES3vo3xmzdjoV1hwes/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riRRgB+g0M/7jsyraAMKUzZaD/dVOcfugvfP811IRaSVGPiUNG0G2AejVw35skvo/
         ZZuq7CwvZkNWshk9L6c4vvvYgzhLcJhWS5BzHIZUQGPrLV9qKP6BjNyRYBcIqczM6z
         C4NwxekDBsLNh3/G1rRQxJuPKhTZeHYci/4kf8Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karen Sornek <karen.sornek@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/177] igb: Fix removal of unicast MAC filters of VFs
Date:   Mon, 20 Dec 2021 15:34:04 +0100
Message-Id: <20211220143043.267412153@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

[ Upstream commit 584af82154f56e6b2740160fcc84a2966d969e15 ]

Move checking condition of VF MAC filter before clearing
or adding MAC filter to VF to prevent potential blackout caused
by removal of necessary and working VF's MAC filter.

Fixes: 1b8b062a99dc ("igb: add VF trust infrastructure")
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 28 +++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 8f30577386b6f..533199d819501 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7641,6 +7641,20 @@ static int igb_set_vf_mac_filter(struct igb_adapter *adapter, const int vf,
 	struct vf_mac_filter *entry = NULL;
 	int ret = 0;
 
+	if ((vf_data->flags & IGB_VF_FLAG_PF_SET_MAC) &&
+	    !vf_data->trusted) {
+		dev_warn(&pdev->dev,
+			 "VF %d requested MAC filter but is administratively denied\n",
+			  vf);
+		return -EINVAL;
+	}
+	if (!is_valid_ether_addr(addr)) {
+		dev_warn(&pdev->dev,
+			 "VF %d attempted to set invalid MAC filter\n",
+			  vf);
+		return -EINVAL;
+	}
+
 	switch (info) {
 	case E1000_VF_MAC_FILTER_CLR:
 		/* remove all unicast MAC filters related to the current VF */
@@ -7654,20 +7668,6 @@ static int igb_set_vf_mac_filter(struct igb_adapter *adapter, const int vf,
 		}
 		break;
 	case E1000_VF_MAC_FILTER_ADD:
-		if ((vf_data->flags & IGB_VF_FLAG_PF_SET_MAC) &&
-		    !vf_data->trusted) {
-			dev_warn(&pdev->dev,
-				 "VF %d requested MAC filter but is administratively denied\n",
-				 vf);
-			return -EINVAL;
-		}
-		if (!is_valid_ether_addr(addr)) {
-			dev_warn(&pdev->dev,
-				 "VF %d attempted to set invalid MAC filter\n",
-				 vf);
-			return -EINVAL;
-		}
-
 		/* try to find empty slot in the list */
 		list_for_each(pos, &adapter->vf_macs.l) {
 			entry = list_entry(pos, struct vf_mac_filter, l);
-- 
2.33.0



