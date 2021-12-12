Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A3E471ABA
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhLLOY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:24:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57882 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhLLOYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:24:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C13A5B80D11
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED004C341C6;
        Sun, 12 Dec 2021 14:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639319093;
        bh=gBii1DhHs8ddUeJKQFbh5K1kT4wM1KD5n831bF9yZKQ=;
        h=Subject:To:Cc:From:Date:From;
        b=sPtXf+ZNnZSYsRS99yFEQAwpEPIa+GJ77E77GS3kHM081c9w3+bdh1lm7wYb7Hk8F
         TMnG46UBBSvLdd2Xo9iT66g4nCOZpNokSfAWuS+7nl0kfzQhRw1LFpQu+yfmX2ZOQU
         ItCarV9jhC0qlpsBUn6R3KubvjV79eWTlOj1sKhs=
Subject: FAILED: patch "[PATCH] ice: rearm other interrupt cause register after enabling VFs" failed to apply to 5.10-stable tree
To:     paul.greenwalt@intel.com, anthony.l.nguyen@intel.com,
        tony.brelinski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:24:50 +0100
Message-ID: <163931909015879@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

