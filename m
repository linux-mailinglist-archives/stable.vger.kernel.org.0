Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66C559D542
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346593AbiHWImd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347783AbiHWIlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:41:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD6B792E6;
        Tue, 23 Aug 2022 01:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40619B81C4D;
        Tue, 23 Aug 2022 08:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE52C433C1;
        Tue, 23 Aug 2022 08:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242707;
        bh=xd9pSX2o4PEovPzwScjsz4aIA2Eq9p7JoyzIc20i9rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qF4ZO91nB18E9CbYLnipxMoJ3hSZzVMJwT+HjqIVrHiD3D6IKq2mHEQwrY9loB0Xe
         xOAHGVd1c0yiHeR2EwmXM4LiGvLZJ/Y5QNXhZNbQ24UqbBrXAPFTXO4gy17hRS92ST
         BKPrd/IjmeK65XWsLKgsDaA2j3qEffop3CHyGcIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.19 175/365] iavf: Fix deadlock in initialization
Date:   Tue, 23 Aug 2022 10:01:16 +0200
Message-Id: <20220823080125.533399037@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

commit cbe9e51126305832cf407ee6bb556ce831488ffe upstream.

Fix deadlock that occurs when iavf interface is a part of failover
configuration.

1. Mutex crit_lock is taken at the beginning of iavf_watchdog_task()
2. Function iavf_init_config_adapter() is called when adapter
   state is __IAVF_INIT_CONFIG_ADAPTER
3. iavf_init_config_adapter() calls register_netdevice() that emits
   NETDEV_REGISTER event
4. Notifier function failover_event() then calls
   net_failover_slave_register() that calls dev_open()
5. dev_open() calls iavf_open() that tries to take crit_lock in
   end-less loop

Stack trace:
...
[  790.251876]  usleep_range_state+0x5b/0x80
[  790.252547]  iavf_open+0x37/0x1d0 [iavf]
[  790.253139]  __dev_open+0xcd/0x160
[  790.253699]  dev_open+0x47/0x90
[  790.254323]  net_failover_slave_register+0x122/0x220 [net_failover]
[  790.255213]  failover_slave_register.part.7+0xd2/0x180 [failover]
[  790.256050]  failover_event+0x122/0x1ab [failover]
[  790.256821]  notifier_call_chain+0x47/0x70
[  790.257510]  register_netdevice+0x20f/0x550
[  790.258263]  iavf_watchdog_task+0x7c8/0xea0 [iavf]
[  790.259009]  process_one_work+0x1a7/0x360
[  790.259705]  worker_thread+0x30/0x390

To fix the situation we should check the current adapter state after
first unsuccessful mutex_trylock() and return with -EBUSY if it is
__IAVF_INIT_CONFIG_ADAPTER.

Fixes: 226d528512cf ("iavf: fix locking of critical sections")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3989,8 +3989,17 @@ static int iavf_open(struct net_device *
 		return -EIO;
 	}
 
-	while (!mutex_trylock(&adapter->crit_lock))
+	while (!mutex_trylock(&adapter->crit_lock)) {
+		/* If we are in __IAVF_INIT_CONFIG_ADAPTER state the crit_lock
+		 * is already taken and iavf_open is called from an upper
+		 * device's notifier reacting on NETDEV_REGISTER event.
+		 * We have to leave here to avoid dead lock.
+		 */
+		if (adapter->state == __IAVF_INIT_CONFIG_ADAPTER)
+			return -EBUSY;
+
 		usleep_range(500, 1000);
+	}
 
 	if (adapter->state != __IAVF_DOWN) {
 		err = -EBUSY;


