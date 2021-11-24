Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755C745C356
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351445AbhKXNhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352288AbhKXNff (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:35:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FE2261B4B;
        Wed, 24 Nov 2021 12:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758473;
        bh=6ty9rLCnhH8o5+9gMPu8apQxSiefw+PP4Rok9Gl3zTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJZmlk+2Ku/b7pdDRWSH/tzcP/HjsdQ1I7Gt6dG+ifVZNHvSnDx4H+B7WyuyA69mn
         o9GZ1NnZc0yGEoY32W42T2tU5zGJyAOL1o4y1+5Xlza2afBaoXq3L/8W0fg50r4tdK
         CshXgn6gqtLgdjS0oSZhHLDvlF8esPmzbTlsKDfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Nunley <nicholas.d.nunley@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/154] iavf: free q_vectors before queues in iavf_disable_vf
Date:   Wed, 24 Nov 2021 12:57:58 +0100
Message-Id: <20211124115704.971201801@linuxfoundation.org>
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

From: Nicholas Nunley <nicholas.d.nunley@intel.com>

[ Upstream commit 89f22f129696ab53cfbc608e0a2184d0fea46ac1 ]

iavf_free_queues() clears adapter->num_active_queues, which
iavf_free_q_vectors() relies on, so swap the order of these two function
calls in iavf_disable_vf(). This resolves a panic encountered when the
interface is disabled and then later brought up again after PF
communication is restored.

Fixes: 65c7006f234c ("i40evf: assign num_active_queues inside i40evf_alloc_queues")
Signed-off-by: Nicholas Nunley <nicholas.d.nunley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index ef0103a216d1e..3e4bf3559d13b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2047,8 +2047,8 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 
 	iavf_free_misc_irq(adapter);
 	iavf_reset_interrupt_capability(adapter);
-	iavf_free_queues(adapter);
 	iavf_free_q_vectors(adapter);
+	iavf_free_queues(adapter);
 	memset(adapter->vf_res, 0, IAVF_VIRTCHNL_VF_RESOURCE_SIZE);
 	iavf_shutdown_adminq(&adapter->hw);
 	adapter->netdev->flags &= ~IFF_UP;
-- 
2.33.0



