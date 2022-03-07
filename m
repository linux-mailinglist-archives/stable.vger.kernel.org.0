Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAB74CF9E4
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbiCGKMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242775AbiCGKLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4E47939B;
        Mon,  7 Mar 2022 01:55:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A6C60C6D;
        Mon,  7 Mar 2022 09:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5F3C340E9;
        Mon,  7 Mar 2022 09:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646953;
        bh=Kczgmju90Ffg9RYS6oYFGLab4Hx9As58J5PH3ksVK4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unLcKz9Xh5Vilm6x4BXiXyLqZEN3bPSHJnygZy3/Q2mxXuh/jbdb6PBYaBJfjs5/o
         /ROiJtOMq1zqpFaVum6zzBrUuZUE31nxUSp0H5LuSdXy3nGGWmdHmvTZQHF5WUZxtm
         TW0ZcOCsQwwrCFzK8J5NLTU7gYKIQEU6lYODwVKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 144/186] ibmvnic: init init_done_rc earlier
Date:   Mon,  7 Mar 2022 10:19:42 +0100
Message-Id: <20220307091658.103351345@linuxfoundation.org>
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

[ Upstream commit ae16bf15374d8b055e040ac6f3f1147ab1c9bb7d ]

We currently initialize the ->init_done completion/return code fields
before issuing a CRQ_INIT command. But if we get a transport event soon
after registering the CRQ the taskslet may already have recorded the
completion and error code. If we initialize here, we might overwrite/
lose that and end up issuing the CRQ_INIT only to timeout later.

If that timeout happens during probe, we will leave the adapter in the
DOWN state rather than retrying to register/init the CRQ.

Initialize the completion before registering the CRQ so we don't lose
the notification.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 7bd0ad590898..26ea1f32281f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2212,6 +2212,19 @@ static const char *reset_reason_to_string(enum ibmvnic_reset_reason reason)
 	return "UNKNOWN";
 }
 
+/*
+ * Initialize the init_done completion and return code values. We
+ * can get a transport event just after registering the CRQ and the
+ * tasklet will use this to communicate the transport event. To ensure
+ * we don't miss the notification/error, initialize these _before_
+ * regisering the CRQ.
+ */
+static inline void reinit_init_done(struct ibmvnic_adapter *adapter)
+{
+	reinit_completion(&adapter->init_done);
+	adapter->init_done_rc = 0;
+}
+
 /*
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
@@ -2318,6 +2331,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		 */
 		adapter->state = VNIC_PROBED;
 
+		reinit_init_done(adapter);
+
 		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
 			rc = init_crq_queue(adapter);
 		} else if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
@@ -2461,7 +2476,8 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	 */
 	adapter->state = VNIC_PROBED;
 
-	reinit_completion(&adapter->init_done);
+	reinit_init_done(adapter);
+
 	rc = init_crq_queue(adapter);
 	if (rc) {
 		netdev_err(adapter->netdev,
@@ -5685,10 +5701,6 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 
 	adapter->from_passive_init = false;
 
-	if (reset)
-		reinit_completion(&adapter->init_done);
-
-	adapter->init_done_rc = 0;
 	rc = ibmvnic_send_crq_init(adapter);
 	if (rc) {
 		dev_err(dev, "Send crq init failed with error %d\n", rc);
@@ -5702,12 +5714,14 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 
 	if (adapter->init_done_rc) {
 		release_crq_queue(adapter);
+		dev_err(dev, "CRQ-init failed, %d\n", adapter->init_done_rc);
 		return adapter->init_done_rc;
 	}
 
 	if (adapter->from_passive_init) {
 		adapter->state = VNIC_OPEN;
 		adapter->from_passive_init = false;
+		dev_err(dev, "CRQ-init failed, passive-init\n");
 		return -EINVAL;
 	}
 
@@ -5801,6 +5815,8 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	init_success = false;
 	do {
+		reinit_init_done(adapter);
+
 		rc = init_crq_queue(adapter);
 		if (rc) {
 			dev_err(&dev->dev, "Couldn't initialize crq. rc=%d\n",
-- 
2.34.1



