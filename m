Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A0E328CB0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhCAS5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:57:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240506AbhCASvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:51:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F16A6521D;
        Mon,  1 Mar 2021 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619382;
        bh=BaMT1W2QKF/Ej5o8voNVnRg3XEAvWOyRn/mZhTTy/9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXFr7hbJHcnMEDHJXamUeftKFnI1yRLx1vEsrgx9NakUI+h4cqreEhO7HMyKrs1rw
         biZA5hzdgb0vF4Zy5H4x997Jmkpse8I7erH6g931cemv7ynz1umgdxN32NWePBERPd
         fQha7JWMnwaTMNXWg0Yl4C00Eke6Nfn5MjfSik+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andrzej=20Sawu=C5=82a?= <andrzej.sawula@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 435/663] i40e: Add zero-initialization of AQ command structures
Date:   Mon,  1 Mar 2021 17:11:23 +0100
Message-Id: <20210301161203.414581837@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit d2c788f739b6f68090e968a2ee31b543701e795f ]

Zero-initialize AQ command data structures to comply with
API specifications.

Fixes: 2f4b411a3d67 ("i40e: Enable cloud filters via tc-flower")
Fixes: f4492db16df8 ("i40e: Add NPAR BW get and set functions")
Signed-off-by: Andrzej Sawuła <andrzej.sawula@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1db482d310c2d..9b1251a710c09 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7667,6 +7667,8 @@ int i40e_add_del_cloud_filter(struct i40e_vsi *vsi,
 	if (filter->flags >= ARRAY_SIZE(flag_table))
 		return I40E_ERR_CONFIG;
 
+	memset(&cld_filter, 0, sizeof(cld_filter));
+
 	/* copy element needed to add cloud filter from filter */
 	i40e_set_cld_element(filter, &cld_filter);
 
@@ -7734,6 +7736,8 @@ int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 	    !ipv6_addr_any(&filter->ip.v6.src_ip6))
 		return -EOPNOTSUPP;
 
+	memset(&cld_filter, 0, sizeof(cld_filter));
+
 	/* copy element needed to add cloud filter from filter */
 	i40e_set_cld_element(filter, &cld_filter.element);
 
@@ -11709,6 +11713,8 @@ i40e_status i40e_set_partition_bw_setting(struct i40e_pf *pf)
 	struct i40e_aqc_configure_partition_bw_data bw_data;
 	i40e_status status;
 
+	memset(&bw_data, 0, sizeof(bw_data));
+
 	/* Set the valid bit for this PF */
 	bw_data.pf_valid_bits = cpu_to_le16(BIT(pf->hw.pf_id));
 	bw_data.max_bw[pf->hw.pf_id] = pf->max_bw & I40E_ALT_BW_VALUE_MASK;
-- 
2.27.0



