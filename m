Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0CE5B7158
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbiIMOju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbiIMOhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:37:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812BE6B66A;
        Tue, 13 Sep 2022 07:20:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C373614B4;
        Tue, 13 Sep 2022 14:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DBBC433C1;
        Tue, 13 Sep 2022 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078788;
        bh=n35/stZhqURexH/BuYeoGPgRqe6e21ZPM0ynenKxGXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otGoylOh+VPlvDhjNzfqlFliG4muApEe2z3NjDa3E7qAu9kIrbtB3NVGgnM21MKHH
         2i2Zt6Dpn+b0BMhGX0DQMqxau01zqnxttK5ia+kSkEfFmlyAZ5GsFtzz/qnps4RDUv
         UDPfFstzMMaCa2YapR/sXiox3mPfTZNkI1B2uCpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        Vitaly Grinberg <vgrinber@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/121] iavf: Detach device during reset task
Date:   Tue, 13 Sep 2022 16:04:34 +0200
Message-Id: <20220913140400.938167651@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit aa626da947e9cd30c4cf727493903e1adbb2c0a0 ]

iavf_reset_task() takes crit_lock at the beginning and holds
it during whole call. The function subsequently calls
iavf_init_interrupt_scheme() that grabs RTNL. Problem occurs
when userspace initiates during the reset task any ndo callback
that runs under RTNL like iavf_open() because some of that
functions tries to take crit_lock. This leads to classic A-B B-A
deadlock scenario.

To resolve this situation the device should be detached in
iavf_reset_task() prior taking crit_lock to avoid subsequent
ndos running under RTNL and reattach the device at the end.

Fixes: 62fe2a865e6d ("i40evf: add missing rtnl_lock() around i40evf_set_interrupt_capability")
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
Cc: SlawomirX Laba <slawomirx.laba@intel.com>
Tested-by: Vitaly Grinberg <vgrinber@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index db95786c3419f..00b2ef01f4ea6 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2222,6 +2222,11 @@ static void iavf_reset_task(struct work_struct *work)
 	int i = 0, err;
 	bool running;
 
+	/* Detach interface to avoid subsequent NDO callbacks */
+	rtnl_lock();
+	netif_device_detach(netdev);
+	rtnl_unlock();
+
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
@@ -2229,7 +2234,7 @@ static void iavf_reset_task(struct work_struct *work)
 		if (adapter->state != __IAVF_REMOVE)
 			queue_work(iavf_wq, &adapter->reset_task);
 
-		return;
+		goto reset_finish;
 	}
 
 	while (!mutex_trylock(&adapter->client_lock))
@@ -2299,7 +2304,6 @@ static void iavf_reset_task(struct work_struct *work)
 
 	if (running) {
 		netif_carrier_off(netdev);
-		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
 		iavf_napi_disable_all(adapter);
 	}
@@ -2412,7 +2416,7 @@ static void iavf_reset_task(struct work_struct *work)
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 
-	return;
+	goto reset_finish;
 reset_err:
 	if (running) {
 		set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
@@ -2423,6 +2427,10 @@ static void iavf_reset_task(struct work_struct *work)
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
+reset_finish:
+	rtnl_lock();
+	netif_device_attach(netdev);
+	rtnl_unlock();
 }
 
 /**
-- 
2.35.1



