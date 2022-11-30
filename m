Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A4A63DF7F
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiK3Srq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiK3Sro (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EE55FC4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B15D5B81B37
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12062C433C1;
        Wed, 30 Nov 2022 18:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834061;
        bh=zuHEPewD/+5cJDy1OGWQYNJ990utv2Uu1eOhXrNaSYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjiMy/Y+7Lfnw1vkDCB5xDfXACqp5CjbU/iOnjk1znLoyQEWgV6B+TyV6YEzTzdrL
         mIGC3lDHtyzHKwOyAYY9X+3sE5rq0CPHMelcql7o4whhNfCoG9FoX5jtbkrh3Qpfoj
         LUX7sM7WfGBp0cBZ1n5OCbFqRIyznxqbYGr/cz7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Slawomir Laba <slawomirx.laba@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 087/289] iavf: Fix race condition between iavf_shutdown and iavf_remove
Date:   Wed, 30 Nov 2022 19:21:12 +0100
Message-Id: <20221130180546.117910015@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

[ Upstream commit a8417330f8a57275ed934293e832982b6d882713 ]

Fix a deadlock introduced by commit
974578017fc1 ("iavf: Add waiting so the port is initialized in remove")
due to race condition between iavf_shutdown and iavf_remove, where
iavf_remove stucks forever in while loop since iavf_shutdown already
set __IAVF_REMOVE adapter state.

Fix this by checking if the __IAVF_IN_REMOVE_TASK has already been
set and return if so.

Fixes: 974578017fc1 ("iavf: Add waiting so the port is initialized in remove")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 005bb8378c76..cff03723f4f9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -5042,23 +5042,21 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 static void iavf_remove(struct pci_dev *pdev)
 {
 	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
-	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
+	struct iavf_cloud_filter *cf, *cftmp;
 	struct iavf_adv_rss *rss, *rsstmp;
 	struct iavf_mac_filter *f, *ftmp;
-	struct iavf_cloud_filter *cf, *cftmp;
-	struct iavf_hw *hw = &adapter->hw;
+	struct net_device *netdev;
+	struct iavf_hw *hw;
 	int err;
 
-	/* When reboot/shutdown is in progress no need to do anything
-	 * as the adapter is already REMOVE state that was set during
-	 * iavf_shutdown() callback.
-	 */
-	if (adapter->state == __IAVF_REMOVE)
+	netdev = adapter->netdev;
+	hw = &adapter->hw;
+
+	if (test_and_set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
 		return;
 
-	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
 	/* Wait until port initialization is complete.
 	 * There are flows where register/unregister netdev may race.
 	 */
-- 
2.35.1



