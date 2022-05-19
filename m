Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A0C52CB65
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 07:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbiESFKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 01:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiESFKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 01:10:49 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 May 2022 22:10:46 PDT
Received: from mo-csw-fb.securemx.jp (mo-csw-fb1516.securemx.jp [210.130.202.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25EC10C7
        for <stable@vger.kernel.org>; Wed, 18 May 2022 22:10:46 -0700 (PDT)
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1516) id 24J4qC1X001567; Thu, 19 May 2022 13:52:12 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 24J4q1uQ031806; Thu, 19 May 2022 13:52:01 +0900
X-Iguazu-Qid: 34trdnoW8gY06pGj5d
X-Iguazu-QSIG: v=2; s=0; t=1652935920; q=34trdnoW8gY06pGj5d; m=6wr5xh26vSEjOuDW9jUMb/ENDRS+NLY2Yl+1UilPzw0=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1510) id 24J4pwxF013454
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 May 2022 13:51:59 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     daichi1.fukui@toshiba.co.jp,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 2/3] igc: Remove phy->type checking
Date:   Thu, 19 May 2022 13:51:44 +0900
X-TSB-HOP2: ON
Message-Id: <20220519045145.114240-3-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220519045145.114240-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20220519045145.114240-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

commit 47bca7de6a4fb8dcb564c7ca14d885c91ed19e03 upstream.

i225 devices have only one phy->type: copper. There is no point checking
phy->type during the igc_has_link method from the watchdog that
invoked every 2 seconds.
This patch comes to clean up these pointless checkings.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index da39380ab205..fd9257c7059a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4177,17 +4177,10 @@ bool igc_has_link(struct igc_adapter *adapter)
 	 * false until the igc_check_for_link establishes link
 	 * for copper adapters ONLY
 	 */
-	switch (hw->phy.media_type) {
-	case igc_media_type_copper:
-		if (!hw->mac.get_link_status)
-			return true;
-		hw->mac.ops.check_for_link(hw);
-		link_active = !hw->mac.get_link_status;
-		break;
-	default:
-	case igc_media_type_unknown:
-		break;
-	}
+	if (!hw->mac.get_link_status)
+		return true;
+	hw->mac.ops.check_for_link(hw);
+	link_active = !hw->mac.get_link_status;
 
 	if (hw->mac.type == igc_i225) {
 		if (!netif_carrier_ok(adapter->netdev)) {
-- 
2.36.0


