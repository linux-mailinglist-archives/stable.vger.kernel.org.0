Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF4E35C06E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbhDLJNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240307AbhDLJKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98FA361390;
        Mon, 12 Apr 2021 09:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218315;
        bh=bWtIJWzJV7iRmjmXVIM3jac31huCm0fbc3wewGW2BE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bp7IUbAsTNHwMLr6K9cvVqylQlwxhWwUXcS+o1u0cKC3nfWGdoVB5Mj+PpFE7i6DW
         J8cvZ6sAS/28e97Rs3dwGCvjoUsnah5LdS1y5QXIDNGjFwVGcZAGwT3GFFtCSDKh9A
         OYaRpf5E3go44KSkcWIDa5EM9HL8rwi+jOhtRDLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sreedevi Joshi <sreedevi.joshi@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 151/210] i40e: fix receiving of single packets in xsk zero-copy mode
Date:   Mon, 12 Apr 2021 10:40:56 +0200
Message-Id: <20210412084021.019967102@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 528060ef3e1105c5c3eba66ffbfc80e0825e2cce ]

Fix so that single packets are received immediately instead of in
batches of 8. If you sent 1 pps to a system, you received 8 packets
every 8 seconds instead of 1 packet every second. The problem behind
this was that the work_done reporting from the Tx part of the driver
was broken. The work_done reporting in i40e controls not only the
reporting back to the napi logic but also the setting of the interrupt
throttling logic. When Tx or Rx reports that it has more to do,
interrupts are throttled or coalesced and when they both report that
they are done, interrupts are armed right away. If the wrong work_done
value is returned, the logic will start to throttle interrupts in a
situation where it should have just enabled them. This leads to the
undesired batching behavior seen in user-space.

Fix this by returning the correct boolean value from the Tx xsk
zero-copy path. Return true if there is nothing to do or if we got
fewer packets to process than we asked for. Return false if we got as
many packets as the budget since there might be more packets we can
process.

Fixes: 3106c580fb7c ("i40e: Use batched xsk Tx interfaces to increase performance")
Reported-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 37a21fb99922..7949f6b79f92 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -462,7 +462,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 
 	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, descs, budget);
 	if (!nb_pkts)
-		return false;
+		return true;
 
 	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
 		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
@@ -479,7 +479,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 
 	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
 
-	return true;
+	return nb_pkts < budget;
 }
 
 /**
-- 
2.30.2



