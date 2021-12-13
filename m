Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D2F4728DB
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241270AbhLMKPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243350AbhLMKMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:12:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E969C08ECB8;
        Mon, 13 Dec 2021 01:54:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 446BEB80E39;
        Mon, 13 Dec 2021 09:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C9DC34600;
        Mon, 13 Dec 2021 09:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389263;
        bh=A3lXUWFMScdH9r2Kh7fEOqqgEHOnaa01MFfcMGP0XPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2hjb22lXQQthhANHP3KidNjWqiHyE6ZzYnnSRY2bFm/ZLXesfRYhcAktCmj5Hdo9
         zJyLN8WwloS3R6fjxxvZ37QvNN1/uOEWdSzRMYf0oz3Dj+3NnZvZO3VfFr09vPlyKr
         y0dnbmJnJIngLK6cItJbaK85RWyDY7qCgxqMgWRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 040/171] ice: ignore dropped packets during init
Date:   Mon, 13 Dec 2021 10:29:15 +0100
Message-Id: <20211213092946.412566678@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -5621,6 +5621,9 @@ static int ice_up_complete(struct ice_vs
 		netif_carrier_on(vsi->netdev);
 	}
 
+	/* clear this now, and the first stats read will be used as baseline */
+	vsi->stat_offsets_loaded = false;
+
 	ice_service_task_schedule(pf);
 
 	return 0;


