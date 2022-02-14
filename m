Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FB24B4AF2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348388AbiBNKfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:35:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348284AbiBNKem (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A29DD63;
        Mon, 14 Feb 2022 02:01:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A8B860C24;
        Mon, 14 Feb 2022 10:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC959C340EF;
        Mon, 14 Feb 2022 10:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832883;
        bh=KhUiQzWhj0GxiVPcv6HPZho3XJSPH5zYWYny4xePs4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KE36TMzHgJi2rwqpAKHVfAW0dgz4dy0UxzuXUp+/EegeH4HApCgR1qcwhDJNamSCp
         BKyDrJ4A7+aXxGJTgmDMqPAb67bPr2FI8O767KbNG1bwCNI39TNK/OxfwD4aqxgd2o
         p962z9i22EAYv+5VIPxNTd74fIOb8rtAtYxehntY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 156/203] ice: fix an error code in ice_cfg_phy_fec()
Date:   Mon, 14 Feb 2022 10:26:40 +0100
Message-Id: <20220214092515.546172227@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 21338d58736ef70eaae5fd75d567a358ff7902f9 ]

Propagate the error code from ice_get_link_default_override() instead
of returning success.

Fixes: ea78ce4dab05 ("ice: add link lenient and default override support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index b3066d0fea8ba..e9a0159cb8b92 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3321,7 +3321,8 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 	    !ice_fw_supports_report_dflt_cfg(hw)) {
 		struct ice_link_default_override_tlv tlv;
 
-		if (ice_get_link_default_override(&tlv, pi))
+		status = ice_get_link_default_override(&tlv, pi);
+		if (status)
 			goto out;
 
 		if (!(tlv.options & ICE_LINK_OVERRIDE_STRICT_MODE) &&
-- 
2.34.1



