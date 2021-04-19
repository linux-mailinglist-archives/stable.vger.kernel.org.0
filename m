Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2083643BB
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240475AbhDSNVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241177AbhDSNUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3FED61364;
        Mon, 19 Apr 2021 13:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838149;
        bh=7PY6OMJnkhtmg0tNFTHExLJErkYAJZaxF0rAj5BVbJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loN05J39B4Ogl10VDbVOz/G8Cy56D8UCth9/o/JVVpxev1PLUSXoKtaz8kxtt/bHZ
         0U07zfABH2DEDhWX+gvBvKYR31m2baLu/xo+GydTxD4fDOS18saVkt1IKeVqsPNGB3
         QCRmdnLFi7alu2XbyDiwXvKgj7uvO5TahBfsTSm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 060/103] ice: Fix potential infinite loop when using u8 loop counter
Date:   Mon, 19 Apr 2021 15:06:11 +0200
Message-Id: <20210419130529.864426068@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit ef963ae427aa4669905e0a96b3bd9d44dc85db32 upstream.

A for-loop is using a u8 loop counter that is being compared to
a u32 cmp_dcbcfg->numapp to check for the end of the loop. If
cmp_dcbcfg->numapp is larger than 255 then the counter j will wrap
around to zero and hence an infinite loop occurs. Fix this by making
counter j the same type as cmp_dcbcfg->numapp.

Addresses-Coverity: ("Infinite loop")
Fixes: aeac8ce864d9 ("ice: Recognize 860 as iSCSI port in CEE mode")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -747,8 +747,8 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_ce
 		   struct ice_port_info *pi)
 {
 	u32 status, tlv_status = le32_to_cpu(cee_cfg->tlv_status);
-	u32 ice_aqc_cee_status_mask, ice_aqc_cee_status_shift;
-	u8 i, j, err, sync, oper, app_index, ice_app_sel_type;
+	u32 ice_aqc_cee_status_mask, ice_aqc_cee_status_shift, j;
+	u8 i, err, sync, oper, app_index, ice_app_sel_type;
 	u16 app_prio = le16_to_cpu(cee_cfg->oper_app_prio);
 	u16 ice_aqc_cee_app_mask, ice_aqc_cee_app_shift;
 	struct ice_dcbx_cfg *cmp_dcbcfg, *dcbcfg;


