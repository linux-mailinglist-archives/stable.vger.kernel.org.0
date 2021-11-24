Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36B645C34A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348404AbhKXNhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:37:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350112AbhKXNfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:35:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 737E8615E3;
        Wed, 24 Nov 2021 12:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758467;
        bh=fZ68254fYsGwuNOGEA0mD1duIjx67R5tJBFbLTLm0xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GsbjZwATSxcAXct/1SJ03sAH8nNURxDV3IRyp7P8iEDCEBKJLPCEUpCzjz+8a0r/3
         TLBDnHcVKz/dwGZAacPNmggRHgptLT6RJovLXY0AsF6vVr5/yQSY4+BZw2iLlwZzy/
         CKeWTKerc4CA3A91ljPm1gEEZy+pKx4EbbRfcQ08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/154] iavf: Fix return of set the new channel count
Date:   Wed, 24 Nov 2021 12:57:56 +0100
Message-Id: <20211124115704.911296463@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
index c93567f4d0f79..17ec36c4e6c19 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -892,6 +892,7 @@ static int iavf_set_channels(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	u32 num_req = ch->combined_count;
+	int i;
 
 	if ((adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ADQ) &&
 	    adapter->num_tc) {
@@ -914,6 +915,20 @@ static int iavf_set_channels(struct net_device *netdev,
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



