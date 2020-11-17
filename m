Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17D02B668C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgKQOEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 09:04:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728942AbgKQNJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:09:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 161EE24698;
        Tue, 17 Nov 2020 13:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618593;
        bh=QEBM97sDOsOYGVJv2sJ0AfHyKIxvJh92X0hN957cl6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6eS9R3qrIEI5pBT7Wl6ThyeBKAXat5pLihBndypuRdx2PaOjOUXQEvIM2AHjNF9e
         v/GCMyUMM8+i828y0cJCdcwqeuW9xHVoAhHLo2O2CIEcbi7qT7Dtum2tZOmXMoOIOf
         x57mT5wYYyY8KQ4TDRqbagELBiLPAgaPxeQxtgWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Nemov <sergey.nemov@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/78] i40e: add num_vectors checker in iwarp handler
Date:   Tue, 17 Nov 2020 14:04:46 +0100
Message-Id: <20201117122110.095164212@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Nemov <sergey.nemov@intel.com>

commit 7015ca3df965378bcef072cca9cd63ed098665b5 upstream.

Field num_vectors from struct virtchnl_iwarp_qvlist_info should not be
larger than num_msix_vectors_vf in the hw struct.  The iwarp uses the
same set of vectors as the LAN VF driver.

Signed-off-by: Sergey Nemov <sergey.nemov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 0f54269ffc463..0ac09c9e4aaac 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -418,6 +418,16 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
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
 	size = sizeof(struct i40e_virtchnl_iwarp_qvlist_info) +
 	       (sizeof(struct i40e_virtchnl_iwarp_qv_info) *
 						(qvlist_info->num_vectors - 1));
-- 
2.27.0



