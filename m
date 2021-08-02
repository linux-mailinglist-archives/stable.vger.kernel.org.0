Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EE43DD844
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhHBNu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234274AbhHBNuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:50:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE05160F6D;
        Mon,  2 Aug 2021 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912191;
        bh=SXYD7DBPDhotxtPZFnmB6vkXbSq1xAhm7fYPelEdZlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKH0SA0jdYzbOflV0Ouy4GnVaoJ2hpe6kIlBBgl3NsRDQUzHgGb12+YpD9UdEnDY/
         3tdAP9GB1hUklcLcW5GJ0UO3ZnkzJMG/8Bby6GAVODXYzQoVihVdSSJ4pzhm5mr4vL
         V0l1UBt6nsE1ZC3hBBWGMpA5bY8sIw+letwcqIsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/30] i40e: Fix log TC creation failure when max num of queues is exceeded
Date:   Mon,  2 Aug 2021 15:44:57 +0200
Message-Id: <20210802134334.682579970@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.081433902@linuxfoundation.org>
References: <20210802134334.081433902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit ea52faae1d17cd3048681d86d2e8641f44de484d ]

Fix missing failed message if driver does not have enough queues to
complete TC command. Without this fix no message is displayed in dmesg.

Fixes: a9ce82f744dc ("i40e: Enable 'channel' mode in mqprio for TC configs")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index a35445ea7064..246734be5177 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6762,6 +6762,8 @@ static int i40e_validate_mqprio_qopt(struct i40e_vsi *vsi,
 	}
 	if (vsi->num_queue_pairs <
 	    (mqprio_qopt->qopt.offset[i] + mqprio_qopt->qopt.count[i])) {
+		dev_err(&vsi->back->pdev->dev,
+			"Failed to create traffic channel, insufficient number of queues.\n");
 		return -EINVAL;
 	}
 	if (sum_max_rate > i40e_get_link_speed(vsi)) {
-- 
2.30.2



