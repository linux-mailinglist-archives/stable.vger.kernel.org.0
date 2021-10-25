Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7D343A228
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhJYTpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236060AbhJYTmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 471C5610CF;
        Mon, 25 Oct 2021 19:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190623;
        bh=tLQR3kIlCCUY9tUmxvmulJo6p2DgAf40TFgNZm1SCUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gq2HJ2LP5ODTdnfHIxmDg76Kyw2R68oWVXUVAvGeozjwSMze/proICdwYp60pRmiv
         fVZpZuPzP9z0ieODqaZCXBS7IItop0VlmJVLmOTbTmIKB8qCOKsPIuhfkdLgL0pgZz
         GknCkDAQWuO6CKsuHvNVpzOgyQq9oqNT0aFCVkOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Miao <jun.miao@windriver.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 029/169] ice: Avoid crash from unnecessary IDA free
Date:   Mon, 25 Oct 2021 21:13:30 +0200
Message-Id: <20211025191021.681112925@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit 73e30a62b19b9fbb4e6a3465c59da186630d5f2e ]

In the remove path, there is an attempt to free the aux_idx IDA whether
it was allocated or not.  This can potentially cause a crash when
unloading the driver on systems that do not initialize support for RDMA.
But, this free cannot be gated by the status bit for RDMA, since it is
allocated if the driver detects support for RDMA at probe time, but the
driver can enter into a state where RDMA is not supported after the IDA
has been allocated at probe time and this would lead to a memory leak.

Initialize aux_idx to an invalid value and check for a valid value when
unloading to determine if an IDA free is necessary.

Fixes: d25a0fc41c1f9 ("ice: Initialize RDMA support")
Reported-by: Jun Miao <jun.miao@windriver.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a8bd512d5b45..3a47b03310f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4224,6 +4224,9 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	if (!pf)
 		return -ENOMEM;
 
+	/* initialize Auxiliary index to invalid value */
+	pf->aux_idx = -1;
+
 	/* set up for high or low DMA */
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (err)
@@ -4615,7 +4618,8 @@ static void ice_remove(struct pci_dev *pdev)
 
 	ice_aq_cancel_waiting_tasks(pf);
 	ice_unplug_aux_dev(pf);
-	ida_free(&ice_aux_ida, pf->aux_idx);
+	if (pf->aux_idx >= 0)
+		ida_free(&ice_aux_ida, pf->aux_idx);
 	set_bit(ICE_DOWN, pf->state);
 
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
-- 
2.33.0



