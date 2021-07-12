Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121E63C4A11
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhGLGsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234896AbhGLGrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:47:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E872161159;
        Mon, 12 Jul 2021 06:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072196;
        bh=ExQlea7+zH1uu5AI0bjbn6rckuBhzHkzcdW7lBilDF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sY4DwbayuWDiXKck0FS3bYvOMsskCxuu/lveFZ9qbqoqRhO/TLjfH565qoZ7kufek
         SXRRJJ3fwGKxclNcvr9Jo20vRBSvLW5LqlwFn1iNhx2Ksat7DxW1o7cE/iaRFD6zaa
         p03MIRrfCGL872KGo3QdDnU5mqFf7Cgorp0U3bO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 396/593] i40e: Fix error handling in i40e_vsi_open
Date:   Mon, 12 Jul 2021 08:09:16 +0200
Message-Id: <20210712060931.036074763@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index f0edea7cdbcc..f2ba8ad9b6aa 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8347,6 +8347,8 @@ int i40e_vsi_open(struct i40e_vsi *vsi)
 			 dev_driver_string(&pf->pdev->dev),
 			 dev_name(&pf->pdev->dev));
 		err = i40e_vsi_request_irq(vsi, int_name);
+		if (err)
+			goto err_setup_rx;
 
 	} else {
 		err = -EINVAL;
-- 
2.30.2



