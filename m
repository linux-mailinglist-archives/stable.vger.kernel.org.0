Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BEB551CF6
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244631AbiFTNLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245699AbiFTNJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95E463D5;
        Mon, 20 Jun 2022 06:04:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ED56B811D5;
        Mon, 20 Jun 2022 13:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADF2C341C4;
        Mon, 20 Jun 2022 13:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730159;
        bh=kO5U/4nrteTwo8hU3LdQpFlYmYPlmRjaszQnTgg4vXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BF/bN58Iu0eoT11X4TWfBEa1Xz7MUqF2U7CfcaoRnw2QdKmzZ5zdkPRj47yRkr+rP
         DOBlaExUM+7VYR07PGd2x825EO5GdCyoiMmGlJ1aNnz44eENRq8y2/jb5jpHZxxIfi
         XHFobSzK9MhLNAj+Et89osRWFeCermYMbXtpECmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Jaron <michalx.jaron@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.10 40/84] i40e: Fix call trace in setup_tx_descriptors
Date:   Mon, 20 Jun 2022 14:51:03 +0200
Message-Id: <20220620124722.076200599@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit fd5855e6b1358e816710afee68a1d2bc685176ca ]

After PF reset and ethtool -t there was call trace in dmesg
sometimes leading to panic. When there was some time, around 5
seconds, between reset and test there were no errors.

Problem was that pf reset calls i40e_vsi_close in prep_for_reset
and ethtool -t calls i40e_vsi_close in diag_test. If there was not
enough time between those commands the second i40e_vsi_close starts
before previous i40e_vsi_close was done which leads to crash.

Add check to diag_test if pf is in reset and don't start offline
tests if it is true.
Add netif_info("testing failed") into unhappy path of i40e_diag_test()

Fixes: e17bc411aea8 ("i40e: Disable offline diagnostics if VFs are enabled")
Fixes: 510efb2682b3 ("i40e: Fix ethtool offline diagnostic with netqueues")
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index a2bdb2906519..63054061966e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2582,15 +2582,16 @@ static void i40e_diag_test(struct net_device *netdev,
 
 		set_bit(__I40E_TESTING, pf->state);
 
+		if (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state) ||
+		    test_bit(__I40E_RESET_INTR_RECEIVED, pf->state)) {
+			dev_warn(&pf->pdev->dev,
+				 "Cannot start offline testing when PF is in reset state.\n");
+			goto skip_ol_tests;
+		}
+
 		if (i40e_active_vfs(pf) || i40e_active_vmdqs(pf)) {
 			dev_warn(&pf->pdev->dev,
 				 "Please take active VFs and Netqueues offline and restart the adapter before running NIC diagnostics\n");
-			data[I40E_ETH_TEST_REG]		= 1;
-			data[I40E_ETH_TEST_EEPROM]	= 1;
-			data[I40E_ETH_TEST_INTR]	= 1;
-			data[I40E_ETH_TEST_LINK]	= 1;
-			eth_test->flags |= ETH_TEST_FL_FAILED;
-			clear_bit(__I40E_TESTING, pf->state);
 			goto skip_ol_tests;
 		}
 
@@ -2637,9 +2638,17 @@ static void i40e_diag_test(struct net_device *netdev,
 		data[I40E_ETH_TEST_INTR] = 0;
 	}
 
-skip_ol_tests:
-
 	netif_info(pf, drv, netdev, "testing finished\n");
+	return;
+
+skip_ol_tests:
+	data[I40E_ETH_TEST_REG]		= 1;
+	data[I40E_ETH_TEST_EEPROM]	= 1;
+	data[I40E_ETH_TEST_INTR]	= 1;
+	data[I40E_ETH_TEST_LINK]	= 1;
+	eth_test->flags |= ETH_TEST_FL_FAILED;
+	clear_bit(__I40E_TESTING, pf->state);
+	netif_info(pf, drv, netdev, "testing failed\n");
 }
 
 static void i40e_get_wol(struct net_device *netdev,
-- 
2.35.1



