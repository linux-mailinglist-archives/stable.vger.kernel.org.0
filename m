Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5DD1070B1
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKVKkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:40:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728829AbfKVKj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:39:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFED02071F;
        Fri, 22 Nov 2019 10:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419197;
        bh=fp4JUvyBejBKU6QRe+D7+l2nCEkoKaaJfl7XBKfJXvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpOct5KkIfyxSWJ/vrlkgdCqi7iGewGtCrphLTOOCR1SQ98dZsEzyqEjjJr3DkMyO
         M8W5NV3F46ijLbkpK2J6pJzlVBLn48FvL1XbfGikNPbF9YGTc93knFEY+NwiHi0bvY
         //NzyP8sAfBJ8mPjqL7huC92IIwFQJr83vcVMCSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Patryk=20Ma=C5=82ek?= <patryk.malek@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 031/222] i40e: Prevent deleting MAC address from VF when set by PF
Date:   Fri, 22 Nov 2019 11:26:11 +0100
Message-Id: <20191122100842.982289419@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patryk Małek <patryk.malek@intel.com>

[ Upstream commit 5907cf6c5bbe78be2ed18b875b316c6028b20634 ]

To prevent VF from deleting MAC address that was assigned by the
PF we need to check for that scenario when we try to delete a MAC
address from a VF.

Signed-off-by: Patryk Małek <patryk.malek@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 54b8ee2583f14..7484ad3c955db 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2000,6 +2000,16 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg, u16 msglen)
 			ret = I40E_ERR_INVALID_MAC_ADDR;
 			goto error_param;
 		}
+
+		if (vf->pf_set_mac &&
+		    ether_addr_equal(al->list[i].addr,
+				     vf->default_lan_addr.addr)) {
+			dev_err(&pf->pdev->dev,
+				"MAC addr %pM has been set by PF, cannot delete it for VF %d, reset VF to change MAC addr\n",
+				vf->default_lan_addr.addr, vf->vf_id);
+			ret = I40E_ERR_PARAM;
+			goto error_param;
+		}
 	}
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
-- 
2.20.1



