Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51054471ADA
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhLLOhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhLLOhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:37:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFC0C061714
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 06:37:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B502CE0B70
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E01C341C5;
        Sun, 12 Dec 2021 14:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639319864;
        bh=iT8Y/IgH/XqmOq+T8Jk5g2WLnDQwxeVs2P+DBjJ/UBs=;
        h=Subject:To:Cc:From:Date:From;
        b=1es3Du6IuBN29CFTZ1FbJa060YRj8q1+eTKF60ox0ATrCXa+lmj+nzLBC0Yce2Ham
         aLhR3d9AlBjwNUpsnx6S1O+3p6mcQ9+d2PvAF6GcCrCdM3f23sUg4gMFAgXruiFOfO
         xP5KSBDJSGr3Z3pqRUFQ4vfJjZLK/drAAN2Yqfv8=
Subject: FAILED: patch "[PATCH] i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc" failed to apply to 4.9-stable tree
To:     norbertx.zulinski@intel.com, anthony.l.nguyen@intel.com,
        gurucharanx.g@intel.com, mateusz.palczewski@intel.com,
        sylwesterx.dziedziuch@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:37:28 +0100
Message-ID: <16393198485071@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 23ec111bf3549aae37140330c31a16abfc172421 Mon Sep 17 00:00:00 2001
From: Norbert Zulinski <norbertx.zulinski@intel.com>
Date: Mon, 22 Nov 2021 12:29:05 +0100
Subject: [PATCH] i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc

When trying to dump VFs VSI RX/TX descriptors
using debugfs there was a crash
due to NULL pointer dereference in i40e_dbg_dump_desc.
Added a check to i40e_dbg_dump_desc that checks if
VSI type is correct for dumping RX/TX descriptors.

Fixes: 02e9c290814c ("i40e: debugfs interface")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 291e61ac3e44..2c1b1da1220e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -553,6 +553,14 @@ static void i40e_dbg_dump_desc(int cnt, int vsi_seid, int ring_id, int desc_n,
 		dev_info(&pf->pdev->dev, "vsi %d not found\n", vsi_seid);
 		return;
 	}
+	if (vsi->type != I40E_VSI_MAIN &&
+	    vsi->type != I40E_VSI_FDIR &&
+	    vsi->type != I40E_VSI_VMDQ2) {
+		dev_info(&pf->pdev->dev,
+			 "vsi %d type %d descriptor rings not available\n",
+			 vsi_seid, vsi->type);
+		return;
+	}
 	if (type == RING_TYPE_XDP && !i40e_enabled_xdp_vsi(vsi)) {
 		dev_info(&pf->pdev->dev, "XDP not enabled on VSI %d\n", vsi_seid);
 		return;

