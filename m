Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6783CDD53
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240323AbhGSO5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239985AbhGSO4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:56:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B624F61364;
        Mon, 19 Jul 2021 15:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708847;
        bh=X5WCt2+VvPTr1LN3XxUNNmVWcLys7tVurz16Vjww6s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2s23NqLs2wKbITs39htY9VqNdrCBPO2aReWbxEHQ4pZore/wmkpt73UdFK4K63+s
         0QV20W5rYpSDJ7zINILEASl1giUEEF464HunpA3DnAIWBrlCvuNw7phkGeOLG6WOiw
         aKZ84L+PX71kCdc7AdpWvual+xhoXp6MNP7VS0HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 154/421] i40e: Fix error handling in i40e_vsi_open
Date:   Mon, 19 Jul 2021 16:49:25 +0200
Message-Id: <20210719144951.807487949@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 9c04cfcd4aad232e36306cdc5c74cd9fc9148a7e ]

When vsi->type == I40E_VSI_FDIR, we have caught the return value of
i40e_vsi_request_irq() but without further handling. Check and execute
memory clean on failure just like the other i40e_vsi_request_irq().

Fixes: 8a9eb7d3cbcab ("i40e: rework fdir setup and teardown")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index fa0e7582159f..1b101b526ed3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7743,6 +7743,8 @@ int i40e_vsi_open(struct i40e_vsi *vsi)
 			 dev_driver_string(&pf->pdev->dev),
 			 dev_name(&pf->pdev->dev));
 		err = i40e_vsi_request_irq(vsi, int_name);
+		if (err)
+			goto err_setup_rx;
 
 	} else {
 		err = -EINVAL;
-- 
2.30.2



