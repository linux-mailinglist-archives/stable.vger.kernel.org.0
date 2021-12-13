Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E96D472643
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhLMJts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39610 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbhLMJrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A1D4CCE0E6B;
        Mon, 13 Dec 2021 09:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727F1C341C5;
        Mon, 13 Dec 2021 09:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388856;
        bh=nrrb7MP7dMSf02K6yIGdWHNNfljyPexHZmnQ23V9R40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+/fKGsSUSheyz2r93Q1rqH5lYgA0MLQYHDQbr5ufWD8ZOT7QyBgeteku03QySmAG
         i+n7b+Vpa4/YnQH63Wn+g7fBEx3aF7sfGj0sROAH1M5hp9X8TFxGRk47075chQ5YtV
         zwIGH7ijBAOGcg/OudvU07pyh8W06mzGArmXOBV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 032/132] ice: ignore dropped packets during init
Date:   Mon, 13 Dec 2021 10:29:33 +0100
Message-Id: <20211213092940.222334216@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit 28dc1b86f8ea9fd6f4c9e0b363db73ecabf84e22 upstream.

If the hardware is constantly receiving unicast or broadcast packets
during driver load, the device previously counted many GLV_RDPC (VSI
dropped packets) events during init. This causes confusing dropped
packet statistics during driver load. The dropped packets counter
incrementing does stop once the driver finishes loading.

Avoid this problem by baselining our statistics at the end of driver
open instead of the end of probe.

Fixes: cdedef59deb0 ("ice: Configure VSIs for Tx/Rx")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5267,6 +5267,9 @@ static int ice_up_complete(struct ice_vs
 		netif_carrier_on(vsi->netdev);
 	}
 
+	/* clear this now, and the first stats read will be used as baseline */
+	vsi->stat_offsets_loaded = false;
+
 	ice_service_task_schedule(pf);
 
 	return 0;


