Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB3459BFA6
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiHVMpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbiHVMpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:45:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FEA33418
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AD71B81195
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 12:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCA2C433C1;
        Mon, 22 Aug 2022 12:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661172320;
        bh=Eod1N6gKTBvI6rMRRpxrpl6Do2czlmSic75ftPQvrLI=;
        h=Subject:To:Cc:From:Date:From;
        b=r/D3e0UV0IN1o8jCbcKsiM3+pJhF/3p5Qg60QcTD2qfcBEZtyzi1XdmhzN9L8XUXg
         cYJ2aX2tspYeHUKV2QWYqk6X5fcaU5QFsGvKAeeQwHVJTnCl/adaXp9VuZ6OykoUn9
         3Nhd19KEw2RnLKXCjIVonYOYSiQCrgmhSbxwJIUg=
Subject: FAILED: patch "[PATCH] iavf: Fix deadlock in initialization" failed to apply to 5.15-stable tree
To:     ivecera@redhat.com, anthony.l.nguyen@intel.com,
        konrad0.jankowski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 14:45:16 +0200
Message-ID: <166117231662182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cbe9e51126305832cf407ee6bb556ce831488ffe Mon Sep 17 00:00:00 2001
From: Ivan Vecera <ivecera@redhat.com>
Date: Mon, 8 Aug 2022 19:58:45 +0200
Subject: [PATCH] iavf: Fix deadlock in initialization

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

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 95d4348e7579..f39440ad5c50 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4088,8 +4088,17 @@ static int iavf_open(struct net_device *netdev)
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

