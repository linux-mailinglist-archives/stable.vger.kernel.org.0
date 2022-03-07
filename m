Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC394CF6CF
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiCGJnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238928AbiCGJjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9FB6F49A;
        Mon,  7 Mar 2022 01:33:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBB7B60FF6;
        Mon,  7 Mar 2022 09:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE577C36AE5;
        Mon,  7 Mar 2022 09:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645597;
        bh=70FazzljlNlduRTWOkMcv6aw843eOYsSOelHFwwLpLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thxbDtiWVAHvXEoi1ryR/w4xj9soCEJQCt59fO6yZobTonXJu9c1l/DnYqXSRqzBO
         zCGvhWR0Ik/FDTlCusRRRAG0Dfgw+toW7jhkHZpFvTjcDifj8oCkthCySF53jJ6xdU
         dZwUQIaHdQo5MfznpMKFqG8RsigJ878wjxIXGdy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 065/105] ibmvnic: register netdev after init of adapter
Date:   Mon,  7 Mar 2022 10:19:08 +0100
Message-Id: <20220307091646.008120724@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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
 drivers/net/ethernet/ibm/ibmvnic.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5383,6 +5383,12 @@ static int ibmvnic_probe(struct vio_dev
 		goto ibmvnic_dev_file_err;
 
 	netif_carrier_off(netdev);
+
+	adapter->state = VNIC_PROBED;
+
+	adapter->wait_for_reset = false;
+	adapter->last_reset_time = jiffies;
+
 	rc = register_netdev(netdev);
 	if (rc) {
 		dev_err(&dev->dev, "failed to register netdev rc=%d\n", rc);
@@ -5390,10 +5396,6 @@ static int ibmvnic_probe(struct vio_dev
 	}
 	dev_info(&dev->dev, "ibmvnic registered\n");
 
-	adapter->state = VNIC_PROBED;
-
-	adapter->wait_for_reset = false;
-	adapter->last_reset_time = jiffies;
 	return 0;
 
 ibmvnic_register_fail:


