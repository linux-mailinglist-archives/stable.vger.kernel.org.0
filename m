Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4483C3288FD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbhCARsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:48:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238417AbhCARmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:42:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEE4064FCF;
        Mon,  1 Mar 2021 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617847;
        bh=tiCmN2hUDlB2iBgkmcX6Q9Kgmp4ySAenv89f/6cdMIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kuqq6u89T5sBV4H8h85x1OsTuzoES/zTs+XbOYQRCQlZi8oU7bYeYlaKoY6XcQi29
         Q4y6eBALal35S+Qu95Ms4jKoGjIn+O+VaTvnilRc+iRkPo0jheEswarqYQpyZ+UIDa
         lSIwdtHmZSeUUciLNCVEYZmncrqwtiSeKYV7CCLM=
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
Subject: [PATCH 5.4 217/340] i40e: Add zero-initialization of AQ command structures
Date:   Mon,  1 Mar 2021 17:12:41 +0100
Message-Id: <20210301161058.981017795@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index c19b45a90fcd2..e41f7acc0e1fa 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7612,6 +7612,8 @@ int i40e_add_del_cloud_filter(struct i40e_vsi *vsi,
 	if (filter->flags >= ARRAY_SIZE(flag_table))
 		return I40E_ERR_CONFIG;
 
+	memset(&cld_filter, 0, sizeof(cld_filter));
+
 	/* copy element needed to add cloud filter from filter */
 	i40e_set_cld_element(filter, &cld_filter);
 
@@ -7679,6 +7681,8 @@ int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 	    !ipv6_addr_any(&filter->ip.v6.src_ip6))
 		return -EOPNOTSUPP;
 
+	memset(&cld_filter, 0, sizeof(cld_filter));
+
 	/* copy element needed to add cloud filter from filter */
 	i40e_set_cld_element(filter, &cld_filter.element);
 
@@ -11770,6 +11774,8 @@ i40e_status i40e_set_partition_bw_setting(struct i40e_pf *pf)
 	struct i40e_aqc_configure_partition_bw_data bw_data;
 	i40e_status status;
 
+	memset(&bw_data, 0, sizeof(bw_data));
+
 	/* Set the valid bit for this PF */
 	bw_data.pf_valid_bits = cpu_to_le16(BIT(pf->hw.pf_id));
 	bw_data.max_bw[pf->hw.pf_id] = pf->max_bw & I40E_ALT_BW_VALUE_MASK;
-- 
2.27.0



