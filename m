Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF0D240973
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgHJPcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728906AbgHJPay (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:30:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E24B020791;
        Mon, 10 Aug 2020 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073454;
        bh=GdpXVV8DMlKmH9TVZ8I3srjFaDu0mJ60QwCti/S4+20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHBQ6lp/t61vspWIyPtRIcwL0xCP9SIrYw2XdBXbfUSxnA9irHdZ5pH/Xk8B7/qKR
         vIF3N4ZHrtPfp1PrsTJY12CqCpezGDXRoK/l7yPlVLg7SpN7ivXL5BwCFQLqJkDyDw
         pBOUDEcc8sYNCHcoaxTkxkviavTGgmlSRkvs6am4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergey Nemov <sergey.nemov@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH 4.19 44/48] i40e: add num_vectors checker in iwarp handler
Date:   Mon, 10 Aug 2020 17:22:06 +0200
Message-Id: <20200810151806.389164727@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Nemov <sergey.nemov@intel.com>

[ Upstream commit 7015ca3df965378bcef072cca9cd63ed098665b5 ]

Field num_vectors from struct virtchnl_iwarp_qvlist_info should not be
larger than num_msix_vectors_vf in the hw struct.  The iwarp uses the
same set of vectors as the LAN VF driver.

Fixes: e3219ce6a7754 ("i40e: Add support for client interface for IWARP driver")
Signed-off-by: Sergey Nemov <sergey.nemov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -442,6 +442,16 @@ static int i40e_config_iwarp_qvlist(stru
 	u32 next_q_idx, next_q_type;
 	u32 msix_vf, size;
 
+	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
+
+	if (qvlist_info->num_vectors > msix_vf) {
+		dev_warn(&pf->pdev->dev,
+			 "Incorrect number of iwarp vectors %u. Maximum %u allowed.\n",
+			 qvlist_info->num_vectors,
+			 msix_vf);
+		goto err;
+	}
+
 	size = sizeof(struct virtchnl_iwarp_qvlist_info) +
 	       (sizeof(struct virtchnl_iwarp_qv_info) *
 						(qvlist_info->num_vectors - 1));


