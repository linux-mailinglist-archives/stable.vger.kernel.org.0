Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939FD4CE6A6
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 20:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiCET7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 14:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiCET7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 14:59:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E274DEA3
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 11:58:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB9C6CE0953
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 19:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C919CC004E1;
        Sat,  5 Mar 2022 19:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646510299;
        bh=KbxcErY9nUqGLX4u0HzGN02x4DbT9vuPFlOUKaTuUIo=;
        h=Subject:To:Cc:From:Date:From;
        b=ZJD1amxCWK7jZKmgRzOV5wwzuHas3o7i0TIcZZcYGi0U5BKMwXGGwW4nVJhQx7qjm
         SrxGEELI3N0gy7PPgTVUPTioyVt36Ypix+B1blWOu2XRhmSxFJYjA7i4c0zMKHDQiY
         lN6jkrpPUahPmPAVq3j4Kw7IDXP7FVvaAwh5iPqY=
Subject: FAILED: patch "[PATCH] ibmvnic: register netdev after init of adapter" failed to apply to 5.4-stable tree
To:     sukadev@linux.ibm.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 20:58:16 +0100
Message-ID: <1646510296179130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 570425f8c7c18b14fa8a2a58a0adb431968ad118 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Date: Thu, 24 Feb 2022 22:23:55 -0800
Subject: [PATCH] ibmvnic: register netdev after init of adapter

Finish initializing the adapter before registering netdev so state
is consistent.

Fixes: c26eba03e407 ("ibmvnic: Update reset infrastructure to support tunable parameters")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5913d372bc27..a7b03ca109d8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5826,12 +5826,6 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		goto ibmvnic_dev_file_err;
 
 	netif_carrier_off(netdev);
-	rc = register_netdev(netdev);
-	if (rc) {
-		dev_err(&dev->dev, "failed to register netdev rc=%d\n", rc);
-		goto ibmvnic_register_fail;
-	}
-	dev_info(&dev->dev, "ibmvnic registered\n");
 
 	if (init_success) {
 		adapter->state = VNIC_PROBED;
@@ -5844,6 +5838,14 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	adapter->wait_for_reset = false;
 	adapter->last_reset_time = jiffies;
+
+	rc = register_netdev(netdev);
+	if (rc) {
+		dev_err(&dev->dev, "failed to register netdev rc=%d\n", rc);
+		goto ibmvnic_register_fail;
+	}
+	dev_info(&dev->dev, "ibmvnic registered\n");
+
 	return 0;
 
 ibmvnic_register_fail:

