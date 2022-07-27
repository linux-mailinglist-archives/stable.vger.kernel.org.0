Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D7A5830A1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242316AbiG0Rjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242766AbiG0RjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:39:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6843661D6D;
        Wed, 27 Jul 2022 09:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 414AAB821BE;
        Wed, 27 Jul 2022 16:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D185C433D6;
        Wed, 27 Jul 2022 16:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940623;
        bh=0Hz8/hFoBN0GjaM6W/+HjXYAMPRkWM8xHaE1RB5/m1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ib8lxNaq2LOb+vqDINmyiIquxXVTXRVeD67UiGAHRbEkjSzGTtvixC+Cla8vZu5Kj
         AWXP23w3jA32iwJ1f5paZjZ/mIIyuscClipSSd0VzvGrR3ZTRH1lGwJ7Il6/Ukxz54
         qbTXK0i9WCTKRIgaF5BHZC94a+0g/CCzkb6MNwPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 089/158] i40e: Fix erroneous adapter reinitialization during recovery process
Date:   Wed, 27 Jul 2022 18:12:33 +0200
Message-Id: <20220727161025.042585831@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dawid Lukwinski <dawid.lukwinski@intel.com>

[ Upstream commit f838a63369818faadec4ad1736cfbd20ab5da00e ]

Fix an issue when driver incorrectly detects state
of recovery process and erroneously reinitializes interrupts,
which results in a kernel error and call trace message.

The issue was caused by a combination of two factors:
1. Assuming the EMP reset issued after completing
firmware recovery means the whole recovery process is complete.
2. Erroneous reinitialization of interrupt vector after detecting
the above mentioned EMP reset.

Fixes (1) by changing how recovery state change is detected
and (2) by adjusting the conditional expression to ensure using proper
interrupt reinitialization method, depending on the situation.

Fixes: 4ff0ee1af016 ("i40e: Introduce recovery mode support")
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20220715214542.2968762-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 77eb9c726205..6f01bffd7e5c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10645,7 +10645,7 @@ static int i40e_reset(struct i40e_pf *pf)
  **/
 static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 {
-	int old_recovery_mode_bit = test_bit(__I40E_RECOVERY_MODE, pf->state);
+	const bool is_recovery_mode_reported = i40e_check_recovery_mode(pf);
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status ret;
@@ -10653,13 +10653,11 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	int v;
 
 	if (test_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state) &&
-	    i40e_check_recovery_mode(pf)) {
+	    is_recovery_mode_reported)
 		i40e_set_ethtool_ops(pf->vsi[pf->lan_vsi]->netdev);
-	}
 
 	if (test_bit(__I40E_DOWN, pf->state) &&
-	    !test_bit(__I40E_RECOVERY_MODE, pf->state) &&
-	    !old_recovery_mode_bit)
+	    !test_bit(__I40E_RECOVERY_MODE, pf->state))
 		goto clear_recovery;
 	dev_dbg(&pf->pdev->dev, "Rebuilding internal switch\n");
 
@@ -10686,13 +10684,12 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	 * accordingly with regard to resources initialization
 	 * and deinitialization
 	 */
-	if (test_bit(__I40E_RECOVERY_MODE, pf->state) ||
-	    old_recovery_mode_bit) {
+	if (test_bit(__I40E_RECOVERY_MODE, pf->state)) {
 		if (i40e_get_capabilities(pf,
 					  i40e_aqc_opc_list_func_capabilities))
 			goto end_unlock;
 
-		if (test_bit(__I40E_RECOVERY_MODE, pf->state)) {
+		if (is_recovery_mode_reported) {
 			/* we're staying in recovery mode so we'll reinitialize
 			 * misc vector here
 			 */
-- 
2.35.1



