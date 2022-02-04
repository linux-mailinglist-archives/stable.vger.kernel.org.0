Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335A74A96AD
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358024AbiBDJ2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:28:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44172 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358025AbiBDJ0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:26:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90A52612C8;
        Fri,  4 Feb 2022 09:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC276C004E1;
        Fri,  4 Feb 2022 09:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966805;
        bh=SyzHGSaCOZ3ivvI/sjcAeoQjKsYXInq4oIEakk1zE6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghTcvp8nFLlsMBcDNYiWRPsJ88Vs6dKhZdv+P9i7PMM73TNMRAOl6dpQoTqng2Z9n
         WxtUgxBH/MzwArAoAq3U6QhAS7es7OLbv/xhBkLpMSFCbZsN3A0qFH4N6JBZNK3jhJ
         0fRxawXYdOlENGAo8QAqlaNY994YlgO2i3coINQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.16 30/43] i40e: Fix reset bw limit when DCB enabled with 1 TC
Date:   Fri,  4 Feb 2022 10:22:37 +0100
Message-Id: <20220204091918.148878584@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

commit 3d2504663c41104b4359a15f35670cfa82de1bbf upstream.

There was an AQ error I40E_AQ_RC_EINVAL when trying
to reset bw limit as part of bw allocation setup.
This was caused by trying to reset bw limit with
DCB enabled. Bw limit should not be reset when
DCB is enabled. The code was relying on the pf->flags
to check if DCB is enabled but if only 1 TC is available
this flag will not be set even though DCB is enabled.
Add a check for number of TC and if it is 1
don't try to reset bw limit even if pf->flags shows
DCB as disabled.

Fixes: fa38e30ac73f ("i40e: Fix for Tx timeouts when interface is brought up if DCB is enabled")
Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com> # Flatten the condition
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5372,7 +5372,15 @@ static int i40e_vsi_configure_bw_alloc(s
 	/* There is no need to reset BW when mqprio mode is on.  */
 	if (pf->flags & I40E_FLAG_TC_MQPRIO)
 		return 0;
-	if (!vsi->mqprio_qopt.qopt.hw && !(pf->flags & I40E_FLAG_DCB_ENABLED)) {
+
+	if (!vsi->mqprio_qopt.qopt.hw) {
+		if (pf->flags & I40E_FLAG_DCB_ENABLED)
+			goto skip_reset;
+
+		if (IS_ENABLED(CONFIG_I40E_DCB) &&
+		    i40e_dcb_hw_get_num_tc(&pf->hw) == 1)
+			goto skip_reset;
+
 		ret = i40e_set_bw_limit(vsi, vsi->seid, 0);
 		if (ret)
 			dev_info(&pf->pdev->dev,
@@ -5380,6 +5388,8 @@ static int i40e_vsi_configure_bw_alloc(s
 				 vsi->seid);
 		return ret;
 	}
+
+skip_reset:
 	memset(&bw_data, 0, sizeof(bw_data));
 	bw_data.tc_valid_bits = enabled_tc;
 	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)


