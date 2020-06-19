Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4574C201337
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392554AbgFSP6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392611AbgFSPTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D525621919;
        Fri, 19 Jun 2020 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579963;
        bh=mAFAOClf4WWgFlX0BM9kMf0E/FlsTg46DHwbqPKOSIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2PL57jQm2IysaDEqvxmF7lUrI4o8rVAYKdlgabVl1VV8nEQgK2mhUDonk+3VEkWZz
         QxxHTB+r9NSIVM0wvd+YLZxOCUYu5X3Ppg4CYNATxVC2EL+yNf5Qm/jgpWMgDgdB4S
         B2PqG8i8QrUBhHr3iSHIzlsC8Tm08duYokCc845Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marta Plantykow <marta.a.plantykow@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 070/376] ice: Change number of XDP TxQ to 0 when destroying rings
Date:   Fri, 19 Jun 2020 16:29:48 +0200
Message-Id: <20200619141713.667748045@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marta Plantykow <marta.a.plantykow@intel.com>

[ Upstream commit c8f135c6ee7851ad72bd4d877216950fcbd45fb6 ]

When XDP Tx rings are destroyed the number of XDP Tx queues
is not changing. This patch is changing this number to 0.

Signed-off-by: Marta Plantykow <marta.a.plantykow@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5b190c257124..599dab844034 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1898,6 +1898,9 @@ free_qmap:
 	for (i = 0; i < vsi->tc_cfg.numtc; i++)
 		max_txqs[i] = vsi->num_txq;
 
+	/* change number of XDP Tx queues to 0 */
+	vsi->num_xdp_txq = 0;
+
 	return ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
 			       max_txqs);
 }
-- 
2.25.1



