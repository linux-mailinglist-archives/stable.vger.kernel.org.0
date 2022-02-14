Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40734B483F
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343502AbiBNJw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344040AbiBNJva (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:51:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D017D77A8F;
        Mon, 14 Feb 2022 01:42:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E78861190;
        Mon, 14 Feb 2022 09:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36ACAC340EF;
        Mon, 14 Feb 2022 09:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831745;
        bh=HplwvKpp5VJPeBLdS9DXxmGhlP/ITLAVomu1IwBK4Xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAeraOBIbdZiBF8hT2m+1ipKbgM9EUgQFtcYj54utCUNeEcAytMCTjH/4zRoYkjaq
         qPaENcuufEgXe51oH1Eyql3ONDX/kOGaIi0Wev5H6LgYRDIMxQ7PSRml8FhbOo3Zn7
         MuLR4EtpLE/FGUJ7rpliuLb4coMXOyJjvSNNZh28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/116] ice: fix an error code in ice_cfg_phy_fec()
Date:   Mon, 14 Feb 2022 10:26:22 +0100
Message-Id: <20220214092501.633966186@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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
index 64714757bd4f4..2b0d0373ab2c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3032,7 +3032,8 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 	if (fec == ICE_FEC_AUTO && ice_fw_supports_link_override(pi->hw)) {
 		struct ice_link_default_override_tlv tlv;
 
-		if (ice_get_link_default_override(&tlv, pi))
+		status = ice_get_link_default_override(&tlv, pi);
+		if (status)
 			goto out;
 
 		if (!(tlv.options & ICE_LINK_OVERRIDE_STRICT_MODE) &&
-- 
2.34.1



