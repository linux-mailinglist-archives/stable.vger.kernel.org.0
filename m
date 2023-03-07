Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCAB6AF221
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbjCGSuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbjCGSuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:50:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5478DCFD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 91490CE1C8D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD7BC433EF;
        Tue,  7 Mar 2023 18:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213608;
        bh=/cD+OMKL6GnvFIBsYmlbDkHeh24XybtdMR33/9MU0B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lxkgle0lBeu0v3cSW/R3QLxRwpesC360lM65JbMXf4bkXpvxK8U3rhP8Rl0H5jTx+
         iNUQ9PII30qtT2wrDiQNGfQHviotFjck/+vXK9JGM9Km13U9fQrx7+a5tgkGJbBHjL
         86mYqm6SAsEhjPvuBTvW28WcmciIWEo+/J1CRlfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Siddaraju DH <siddaraju.dh@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 561/885] ice: restrict PTP HW clock freq adjustments to 100, 000, 000 PPB
Date:   Tue,  7 Mar 2023 17:58:15 +0100
Message-Id: <20230307170026.824682530@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddaraju DH <siddaraju.dh@intel.com>

[ Upstream commit 8aa4318c3a122b8670bc09af142de3872ca63b88 ]

The PHY provides only 39b timestamp. With current timing
implementation, we discard lower 7b, leaving 32b timestamp.
The driver reconstructs the full 64b timestamp by correlating the
32b timestamp with cached_time for performance. The reconstruction
algorithm does both forward & backward interpolation.

The 32b timeval has overflow duration of 2^32 counts ~= 4.23 second.
Due to interpolation in both direction, its now ~= 2.125 second
IIRC, going with at least half a duration, the cached_time is updated
with periodic thread of 1 second (worst-case) periodicity.

But the 1 second periodicity is based on System-timer.
With PPB adjustments, if the 1588 timers increments at say
double the rate, (2s in-place of 1s), the Nyquist rate/half duration
sampling/update of cached_time with 1 second periodic thread will
lead to incorrect interpolations.

Hence we should restrict the PPB adjustments to at least half duration
of cached_time update which translates to 500,000,000 PPB.

Since the periodicity of the cached-time system thread can vary,
it is good to have some buffer time and considering practicality of
PPB adjustments, limiting the max_adj to 100,000,000.

Signed-off-by: Siddaraju DH <siddaraju.dh@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 53fec5bbe6e00..a3585ede829bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2293,7 +2293,7 @@ static void ice_ptp_set_caps(struct ice_pf *pf)
 	snprintf(info->name, sizeof(info->name) - 1, "%s-%s-clk",
 		 dev_driver_string(dev), dev_name(dev));
 	info->owner = THIS_MODULE;
-	info->max_adj = 999999999;
+	info->max_adj = 100000000;
 	info->adjtime = ice_ptp_adjtime;
 	info->adjfine = ice_ptp_adjfine;
 	info->gettimex64 = ice_ptp_gettimex64;
-- 
2.39.2



