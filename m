Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E86A4A9653
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357917AbiBDJYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357636AbiBDJYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:24:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B87C06175C;
        Fri,  4 Feb 2022 01:24:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BD65B836F2;
        Fri,  4 Feb 2022 09:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BE2C004E1;
        Fri,  4 Feb 2022 09:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966625;
        bh=wDWmQp90kgCrwgiLNL+U3qc/fKgK7nB1VdZ628Ja/X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FchSeYMUvqgKvtu6MRQ/QORm2/3Cjvm2DUNPtWpp0p07k5+aPHres0fBm63Lq29pA
         2XgslXEbGWkeAH2QAGOgdAQt6z1eE9P+Xb9t25PQp7Bf6YF0GInKoxasvUWBNuSKNT
         z7MD7y2OJVvAs8+6aW0wG+JRtmPcMfDvMYUAUjrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 03/32] net: ipa: use a bitmap for endpoint replenish_enabled
Date:   Fri,  4 Feb 2022 10:22:13 +0100
Message-Id: <20220204091915.359696757@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

commit c1aaa01dbf4cef95af3e04a5a43986c290e06ea3 upstream.

Define a new replenish_flags bitmap to contain Boolean flags
associated with an endpoint's replenishing state.  Replace the
replenish_enabled field with a flag in that bitmap.  This is to
prepare for the next patch, which adds another flag.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_endpoint.c |    8 ++++----
 drivers/net/ipa/ipa_endpoint.h |   15 +++++++++++++--
 2 files changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1069,7 +1069,7 @@ static void ipa_endpoint_replenish(struc
 	u32 backlog;
 	int delta;
 
-	if (!endpoint->replenish_enabled) {
+	if (!test_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags)) {
 		if (add_one)
 			atomic_inc(&endpoint->replenish_saved);
 		return;
@@ -1106,7 +1106,7 @@ static void ipa_endpoint_replenish_enabl
 	u32 max_backlog;
 	u32 saved;
 
-	endpoint->replenish_enabled = true;
+	set_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 	while ((saved = atomic_xchg(&endpoint->replenish_saved, 0)))
 		atomic_add(saved, &endpoint->replenish_backlog);
 
@@ -1120,7 +1120,7 @@ static void ipa_endpoint_replenish_disab
 {
 	u32 backlog;
 
-	endpoint->replenish_enabled = false;
+	clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 	while ((backlog = atomic_xchg(&endpoint->replenish_backlog, 0)))
 		atomic_add(backlog, &endpoint->replenish_saved);
 }
@@ -1665,7 +1665,7 @@ static void ipa_endpoint_setup_one(struc
 		/* RX transactions require a single TRE, so the maximum
 		 * backlog is the same as the maximum outstanding TREs.
 		 */
-		endpoint->replenish_enabled = false;
+		clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 		atomic_set(&endpoint->replenish_saved,
 			   gsi_channel_tre_max(gsi, endpoint->channel_id));
 		atomic_set(&endpoint->replenish_backlog, 0);
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -41,6 +41,17 @@ enum ipa_endpoint_name {
 #define IPA_ENDPOINT_MAX		32	/* Max supported by driver */
 
 /**
+ * enum ipa_replenish_flag:	RX buffer replenish flags
+ *
+ * @IPA_REPLENISH_ENABLED:	Whether receive buffer replenishing is enabled
+ * @IPA_REPLENISH_COUNT:	Number of defined replenish flags
+ */
+enum ipa_replenish_flag {
+	IPA_REPLENISH_ENABLED,
+	IPA_REPLENISH_COUNT,	/* Number of flags (must be last) */
+};
+
+/**
  * struct ipa_endpoint - IPA endpoint information
  * @ipa:		IPA pointer
  * @ee_id:		Execution environmnent endpoint is associated with
@@ -51,7 +62,7 @@ enum ipa_endpoint_name {
  * @trans_tre_max:	Maximum number of TRE descriptors per transaction
  * @evt_ring_id:	GSI event ring used by the endpoint
  * @netdev:		Network device pointer, if endpoint uses one
- * @replenish_enabled:	Whether receive buffer replenishing is enabled
+ * @replenish_flags:	Replenishing state flags
  * @replenish_ready:	Number of replenish transactions without doorbell
  * @replenish_saved:	Replenish requests held while disabled
  * @replenish_backlog:	Number of buffers needed to fill hardware queue
@@ -72,7 +83,7 @@ struct ipa_endpoint {
 	struct net_device *netdev;
 
 	/* Receive buffer replenishing for RX endpoints */
-	bool replenish_enabled;
+	DECLARE_BITMAP(replenish_flags, IPA_REPLENISH_COUNT);
 	u32 replenish_ready;
 	atomic_t replenish_saved;
 	atomic_t replenish_backlog;


