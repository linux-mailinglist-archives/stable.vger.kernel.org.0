Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87E635BF48
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237687AbhDLJDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237520AbhDLJBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F095161372;
        Mon, 12 Apr 2021 09:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218017;
        bh=DFRvUnFTyzk1sEmVzBwFnTa4aMnH5h0NfRgOJoeX2Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pp1Km87lkUWFQSkfDc5/QYKfi1YKy1zkOFZxtjcPmqYgMdhAUphgApHhmcvYojoG8
         QxDVvHudUyyWCwXeAav6JdLXLacb6L+djNMxNklI+SqwdKdIywAR+o5JpTeyCShdFs
         4neuNlta5zwCaMuPy1Jrh3PZl1eygeiC16ToSlDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 040/210] ice: Continue probe on link/PHY errors
Date:   Mon, 12 Apr 2021 10:39:05 +0200
Message-Id: <20210412084017.347990613@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

commit 08771bce330036d473be6ce851cd00bcd351ebf6 upstream.

An incorrect NVM update procedure can result in the driver failing probe.
In this case, the recommended resolution method is to update the NVM
using the right procedure. However, if the driver fails probe, the user
will not be able to update the NVM. So do not fail probe on link/PHY
errors.

Fixes: 1a3571b5938c ("ice: restore PHY settings on media insertion")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4167,28 +4167,25 @@ ice_probe(struct pci_dev *pdev, const st
 		goto err_send_version_unroll;
 	}
 
+	/* not a fatal error if this fails */
 	err = ice_init_nvm_phy_type(pf->hw.port_info);
-	if (err) {
+	if (err)
 		dev_err(dev, "ice_init_nvm_phy_type failed: %d\n", err);
-		goto err_send_version_unroll;
-	}
 
+	/* not a fatal error if this fails */
 	err = ice_update_link_info(pf->hw.port_info);
-	if (err) {
+	if (err)
 		dev_err(dev, "ice_update_link_info failed: %d\n", err);
-		goto err_send_version_unroll;
-	}
 
 	ice_init_link_dflt_override(pf->hw.port_info);
 
 	/* if media available, initialize PHY settings */
 	if (pf->hw.port_info->phy.link_info.link_info &
 	    ICE_AQ_MEDIA_AVAILABLE) {
+		/* not a fatal error if this fails */
 		err = ice_init_phy_user_cfg(pf->hw.port_info);
-		if (err) {
+		if (err)
 			dev_err(dev, "ice_init_phy_user_cfg failed: %d\n", err);
-			goto err_send_version_unroll;
-		}
 
 		if (!test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, pf->flags)) {
 			struct ice_vsi *vsi = ice_get_main_vsi(pf);


