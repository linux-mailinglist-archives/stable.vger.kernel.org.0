Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8DE471ABD
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhLLOZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhLLOZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:25:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F591C061714
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 06:25:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DBFABCE0B1E
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A135C341C6;
        Sun, 12 Dec 2021 14:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639319102;
        bh=N9ybYYEAQNURyqFMO8wbQed8Iyh4Yr0JiME+cxVXB7Y=;
        h=Subject:To:Cc:From:Date:From;
        b=1rdqsdCPX8E93JgydA818UNb0HqAuejXU2sK1BBTX5KUYyMoSRcuPs8pvYn73r7dS
         rz5NGS11jeTxF3t24FHZ5Yrv+wl2OroVEWRepjUbU+wfAt9C0UnQyvxWc5+EhycJPG
         xwxRO6HEZ7WfNLj0h3y7WWYjwcOpVCX7Xf4NPK44=
Subject: FAILED: patch "[PATCH] ice: rearm other interrupt cause register after enabling VFs" failed to apply to 5.15-stable tree
To:     paul.greenwalt@intel.com, anthony.l.nguyen@intel.com,
        tony.brelinski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:24:51 +0100
Message-ID: <1639319091244232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2657e16d8c52fb6ffc7250b0b6536f93886e32d6 Mon Sep 17 00:00:00 2001
From: Paul Greenwalt <paul.greenwalt@intel.com>
Date: Mon, 12 Jul 2021 07:54:25 -0400
Subject: [PATCH] ice: rearm other interrupt cause register after enabling VFs

The other interrupt cause register (OICR), global interrupt 0, is
disabled when enabling VFs to prevent handling VFLR. If the OICR is
not rearmed then the VF cannot communicate with the PF.

Rearm the OICR after enabling VFs.

Fixes: 916c7fdf5e93 ("ice: Separate VF VSI initialization/creation from reset flow")
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index c2431bc9d9ce..6427e7ec93de 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2023,6 +2023,10 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 	if (ret)
 		goto err_unroll_sriov;
 
+	/* rearm global interrupts */
+	if (test_and_clear_bit(ICE_OICR_INTR_DIS, pf->state))
+		ice_irq_dynamic_ena(hw, NULL, NULL);
+
 	return 0;
 
 err_unroll_sriov:

