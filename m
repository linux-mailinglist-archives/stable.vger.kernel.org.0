Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8423D61F3
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhGZPdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233709AbhGZPca (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B44260C40;
        Mon, 26 Jul 2021 16:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315978;
        bh=UsJYPCPZQLfe7l2y4KyHT7GmHNFhTrk+m/Ll3+7jyjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pg2TnxB/hC9jzsK19n9f5QZz5h16LkIRIBJ+jqHT3ioFH/PdjZVI4pI6cc20Vn/NA
         NVE0meDRWEHsv7U/MPkXI7pDGElVrEIhMkzn2j+8sNHO4WCfye2IliwUAzKJv8pJ2R
         /9eB0nqfjG9Ni92yj5za7w5wav7J6qmvL69zDMTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 139/223] dpaa2-switch: seed the buffer pool after allocating the swp
Date:   Mon, 26 Jul 2021 17:38:51 +0200
Message-Id: <20210726153850.786429482@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 7aaa0f311e2df2704fa8ddb8ed681a3b5841d0bf ]

Any interraction with the buffer pool (seeding a buffer, acquire one) is
made through a software portal (SWP, a DPIO object).
There are circumstances where the dpaa2-switch driver probes on a DPSW
before any DPIO devices have been probed. In this case, seeding of the
buffer pool will lead to a panic since no SWPs are initialized.

To fix this, seed the buffer pool after making sure that the software
portals have been probed and are ready to be used.

Fixes: 0b1b71370458 ("staging: dpaa2-switch: handle Rx path on control interface")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c  | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 05de37c3b64c..87321b7239cf 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2770,32 +2770,32 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	if (err)
 		return err;
 
-	err = dpaa2_switch_seed_bp(ethsw);
-	if (err)
-		goto err_free_dpbp;
-
 	err = dpaa2_switch_alloc_rings(ethsw);
 	if (err)
-		goto err_drain_dpbp;
+		goto err_free_dpbp;
 
 	err = dpaa2_switch_setup_dpio(ethsw);
 	if (err)
 		goto err_destroy_rings;
 
+	err = dpaa2_switch_seed_bp(ethsw);
+	if (err)
+		goto err_deregister_dpio;
+
 	err = dpsw_ctrl_if_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	if (err) {
 		dev_err(ethsw->dev, "dpsw_ctrl_if_enable err %d\n", err);
-		goto err_deregister_dpio;
+		goto err_drain_dpbp;
 	}
 
 	return 0;
 
+err_drain_dpbp:
+	dpaa2_switch_drain_bp(ethsw);
 err_deregister_dpio:
 	dpaa2_switch_free_dpio(ethsw);
 err_destroy_rings:
 	dpaa2_switch_destroy_rings(ethsw);
-err_drain_dpbp:
-	dpaa2_switch_drain_bp(ethsw);
 err_free_dpbp:
 	dpaa2_switch_free_dpbp(ethsw);
 
-- 
2.30.2



