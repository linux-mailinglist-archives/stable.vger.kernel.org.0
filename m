Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878004CFA52
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238432AbiCGKPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241514AbiCGKKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA41338B1;
        Mon,  7 Mar 2022 01:53:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 395F9B810BC;
        Mon,  7 Mar 2022 09:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87034C340F3;
        Mon,  7 Mar 2022 09:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646792;
        bh=Qf0pMOyeqKrwzeWEyzg94zwj7+R6q9P1xaVjSePZBdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxWKYORZX/bAXiuVtuSwuHhQQ9rZlIzh0VMDRdg/h00GtaZlRsQk5YOZHzl5K4UZt
         IcaR4UjGPg88fEbMSd9ONlr8DmV9W1HUa+zKMq29Jmqu6y88WoY4XLaSFylxRWTVUx
         9qFKfSDrL4vn4OYRd3BSEbZXPGS+G5zcmDaR1kTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 094/186] ibmvnic: register netdev after init of adapter
Date:   Mon,  7 Mar 2022 10:18:52 +0100
Message-Id: <20220307091656.711747658@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

commit 570425f8c7c18b14fa8a2a58a0adb431968ad118 upstream.

Finish initializing the adapter before registering netdev so state
is consistent.

Fixes: c26eba03e407 ("ibmvnic: Update reset infrastructure to support tunable parameters")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5811,12 +5811,6 @@ static int ibmvnic_probe(struct vio_dev
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
@@ -5829,6 +5823,14 @@ static int ibmvnic_probe(struct vio_dev
 
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


