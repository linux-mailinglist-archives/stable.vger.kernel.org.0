Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487DB47AE55
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239202AbhLTPAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239040AbhLTO61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF92DC0698CD;
        Mon, 20 Dec 2021 06:49:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EA54611A1;
        Mon, 20 Dec 2021 14:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5367CC36AE7;
        Mon, 20 Dec 2021 14:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011769;
        bh=QwAQ/I2JpIyzbiYLOJ8xIt3QY6cIWDwJRl4RzhOeZZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INtoyCARA71pDKT4CFR0qpySdd5OlylX2akJObNcu3XTmOYCQyRTk/8Fm7ZGhunjO
         FgMFsTdhkmC66+SAaVtBEzmYQ5jWMR21dzvPo/PMRLUiOWZTiJqSeqbaJexnA8m4ic
         WVM8n2+Jxz1/jbuadesthmZIlj2wycaG72dFPyrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karen Sornek <karen.sornek@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/99] igb: Fix removal of unicast MAC filters of VFs
Date:   Mon, 20 Dec 2021 15:34:23 +0100
Message-Id: <20211220143031.059639784@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
index d5432d1448c05..1662c0985eca4 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7654,6 +7654,20 @@ static int igb_set_vf_mac_filter(struct igb_adapter *adapter, const int vf,
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
@@ -7667,20 +7681,6 @@ static int igb_set_vf_mac_filter(struct igb_adapter *adapter, const int vf,
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



