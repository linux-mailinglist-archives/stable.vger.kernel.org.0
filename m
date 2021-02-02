Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7943C30C07A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhBBN7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233445AbhBBN5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:57:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C40BE64FE6;
        Tue,  2 Feb 2021 13:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273538;
        bh=/lLlyxXowQpB/M6WztW+zCZJBN6fW1vr/XvfWBHPnww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nl4voCFWEpxdw0UyK+JjcB09yKra2zKAo0tr2v+5dA7ZDks6qnU18Ish+jvxJTjZK
         ccddMFfD6CVuRzJce21YIR+az/Z4y+duhCy/0IVJOQiOQhf7Bwcd8y1Mx2m0jtTd/a
         jGQE7qSW4JPWwB3slgc3n8d9B6epcTalcHKMjUHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Assmann <sassmann@kpanic.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/142] i40e: acquire VSI pointer only after VF is initialized
Date:   Tue,  2 Feb 2021 14:37:55 +0100
Message-Id: <20210202133002.326802141@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 67a3c6b3cc40bb217c3ff947a55053151a00fea0 ]

This change simplifies the VF initialization check and also minimizes
the delay between acquiring the VSI pointer and using it. As known by
the commit being fixed, there is a risk of the VSI pointer getting
changed. Therefore minimize the delay between getting and using the
pointer.

Fixes: 9889707b06ac ("i40e: Fix crash caused by stress setting of VF MAC addresses")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 61968e9174dab..2872c4dc77f07 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4046,20 +4046,16 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		goto error_param;
 
 	vf = &pf->vf[vf_id];
-	vsi = pf->vsi[vf->lan_vsi_idx];
 
 	/* When the VF is resetting wait until it is done.
 	 * It can take up to 200 milliseconds,
 	 * but wait for up to 300 milliseconds to be safe.
-	 * If the VF is indeed in reset, the vsi pointer has
-	 * to show on the newly loaded vsi under pf->vsi[id].
+	 * Acquire the VSI pointer only after the VF has been
+	 * properly initialized.
 	 */
 	for (i = 0; i < 15; i++) {
-		if (test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
-			if (i > 0)
-				vsi = pf->vsi[vf->lan_vsi_idx];
+		if (test_bit(I40E_VF_STATE_INIT, &vf->vf_states))
 			break;
-		}
 		msleep(20);
 	}
 	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
@@ -4068,6 +4064,7 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		ret = -EAGAIN;
 		goto error_param;
 	}
+	vsi = pf->vsi[vf->lan_vsi_idx];
 
 	if (is_multicast_ether_addr(mac)) {
 		dev_err(&pf->pdev->dev,
-- 
2.27.0



