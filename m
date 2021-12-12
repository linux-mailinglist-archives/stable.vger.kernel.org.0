Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75BA471AD7
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhLLOhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhLLOhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:37:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4119C061714
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 06:37:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1F36B80D12
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42A5C341CA;
        Sun, 12 Dec 2021 14:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639319850;
        bh=NMXKWOTlf9peAVnB69Uzvj6wkSC1yzp/xMD7pbLroFQ=;
        h=Subject:To:Cc:From:Date:From;
        b=RmRCJsRRUYarKHZxfYLaroUGWw29is2BEJuWiiUCDSB2tceinHN9ZnTqOpaYC7oLL
         QsYZmmqzg1t2Guylgi1gX3M3vPYfM43zBzXjcLxXP+t2L9GYOILvg5pj0xk1r9e/9j
         mai7vzxl61CmspIFV7epU19mLKPten9oMzFcXi6s=
Subject: FAILED: patch "[PATCH] i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc" failed to apply to 4.4-stable tree
To:     norbertx.zulinski@intel.com, anthony.l.nguyen@intel.com,
        gurucharanx.g@intel.com, mateusz.palczewski@intel.com,
        sylwesterx.dziedziuch@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:37:27 +0100
Message-ID: <1639319847204179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

