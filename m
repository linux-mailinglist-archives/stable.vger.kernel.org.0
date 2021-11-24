Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72F145C55C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350000AbhKXN47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:56:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352391AbhKXNy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FC7361A57;
        Wed, 24 Nov 2021 13:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759178;
        bh=JwO+2/5VEb5ECDOg/hyi/c65C/AMFN87Dcm0W4Pg18g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRKRpdrJxLrCdwE8zhOzS3Q7Hsr/MunT9pOtDYLITvHLrym05rDOJRSR8TjCyJ4A4
         lb7x9umx4clrkRnKq8I1TTOo/ZLWPnHXIN9l7qKX1eeyrcpLt63HLHMT3gF1dCsBPq
         xXPXL/R3TFSBmxQpzBN8Ik4rti7I6+d/lCBJNp0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Nunley <nicholas.d.nunley@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/279] iavf: free q_vectors before queues in iavf_disable_vf
Date:   Wed, 24 Nov 2021 12:56:52 +0100
Message-Id: <20211124115723.122304047@linuxfoundation.org>
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
index 12976ccca1b6e..5664a1905e8bb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2074,8 +2074,8 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 
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



