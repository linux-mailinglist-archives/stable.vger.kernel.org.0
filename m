Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F4145C55A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348205AbhKXN46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:56:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352134AbhKXNyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C101C61265;
        Wed, 24 Nov 2021 13:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759171;
        bh=aTfY5c3c8ehatYi9dHUTmsamzQ4VrgR0m8+ZwGzvSII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+sqw8rEDFFSCJDtmXvFc8vMyf4i/zHhGNYUN6eIDjEmfgZU6yQnFyVVI3XscCtcP
         CXUCwZymtDPXKz1tOz+gNldU73oq6DUvpZo7g22Q49ELBfCkMcCuhuKRQnar0dnnOx
         35gjgO3uBChvi7TTgWIM6FBLEMG3rg1sviOKj06w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/279] iavf: Fix return of set the new channel count
Date:   Wed, 24 Nov 2021 12:56:50 +0100
Message-Id: <20211124115723.061093409@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit 4e5e6b5d9d1334d3490326b6922a2daaf56a867f ]

Fixed return correct code from set the new channel count.
Implemented by check if reset is done in appropriate time.
This solution give a extra time to pf for reset vf in case
when user want set new channel count for all vfs.
Without this patch it is possible to return misleading output
code to user and vf reset not to be correctly performed by pf.

Fixes: 5520deb15326 ("iavf: Enable support for up to 16 queues")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 5a359a0a20ecc..136c801f5584a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1776,6 +1776,7 @@ static int iavf_set_channels(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	u32 num_req = ch->combined_count;
+	int i;
 
 	if ((adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ADQ) &&
 	    adapter->num_tc) {
@@ -1798,6 +1799,20 @@ static int iavf_set_channels(struct net_device *netdev,
 	adapter->num_req_queues = num_req;
 	adapter->flags |= IAVF_FLAG_REINIT_ITR_NEEDED;
 	iavf_schedule_reset(adapter);
+
+	/* wait for the reset is done */
+	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
+		msleep(IAVF_RESET_WAIT_MS);
+		if (adapter->flags & IAVF_FLAG_RESET_PENDING)
+			continue;
+		break;
+	}
+	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
+		adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
+		adapter->num_active_queues = num_req;
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 
-- 
2.33.0



