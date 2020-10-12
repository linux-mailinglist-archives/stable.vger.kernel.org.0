Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56FB28B7C6
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389888AbgJLNqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389826AbgJLNqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:46:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B63DF208B8;
        Mon, 12 Oct 2020 13:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510364;
        bh=O5T9Ct9Nrnv2/BVbazjDi0vqF7MOyTIwCtxmL/Jb+Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQlpyjd/sh8du2DS7N8ffdlJfefjxLgfb4oK6rni+CuLsMtxpbxBd24RIdmxnjJXB
         9SXx9VU+Go6gGvcwoXOmWQMyAoI9iKiYEAxuADrtSIXzioq6KXyJPfNjIOwEwMGiUT
         l7UnchdyTZfSEu+AzZQPoPO/Ykg2YYvCzL8weumY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 068/124] ice: fix memory leak in ice_vsi_setup
Date:   Mon, 12 Oct 2020 15:31:12 +0200
Message-Id: <20201012133150.144025578@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit f6a07271bb1535d9549380461437cc48d9e19958 ]

During ice_vsi_setup, if ice_cfg_vsi_lan fails, it does not properly
release memory associated with the VSI rings. If we had used devres
allocations for the rings, this would be ok. However, we use kzalloc and
kfree_rcu for these ring structures.

Using the correct label to cleanup the rings during ice_vsi_setup
highlights an issue in the ice_vsi_clear_rings function: it can leave
behind stale ring pointers in the q_vectors structure.

When releasing rings, we must also ensure that no q_vector associated
with the VSI will point to this ring again. To resolve this, loop over
all q_vectors and release their ring mapping. Because we are about to
free all rings, no q_vector should remain pointing to any of the rings
in this VSI.

Fixes: 5513b920a4f7 ("ice: Update Tx scheduler tree for VSI multi-Tx queue support")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 133ba6f08e574..4c5845a0965a9 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1190,6 +1190,18 @@ static void ice_vsi_clear_rings(struct ice_vsi *vsi)
 {
 	int i;
 
+	/* Avoid stale references by clearing map from vector to ring */
+	if (vsi->q_vectors) {
+		ice_for_each_q_vector(vsi, i) {
+			struct ice_q_vector *q_vector = vsi->q_vectors[i];
+
+			if (q_vector) {
+				q_vector->tx.ring = NULL;
+				q_vector->rx.ring = NULL;
+			}
+		}
+	}
+
 	if (vsi->tx_rings) {
 		for (i = 0; i < vsi->alloc_txq; i++) {
 			if (vsi->tx_rings[i]) {
@@ -2254,7 +2266,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	if (status) {
 		dev_err(dev, "VSI %d failed lan queue config, error %s\n",
 			vsi->vsi_num, ice_stat_str(status));
-		goto unroll_vector_base;
+		goto unroll_clear_rings;
 	}
 
 	/* Add switch rule to drop all Tx Flow Control Frames, of look up
-- 
2.25.1



