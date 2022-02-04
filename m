Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B704A9621
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357603AbiBDJWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357605AbiBDJWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:22:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D953C061769;
        Fri,  4 Feb 2022 01:22:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4DAC615ED;
        Fri,  4 Feb 2022 09:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72371C004E1;
        Fri,  4 Feb 2022 09:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966527;
        bh=r+9CMK2YraWHNvdjd/Uq7p2YSuxZJmo5/XjNTWxAkws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2Q2wWkS60k+/f0mPvEjeNx/Wp9nsB7vbyYLNJpVDU+DWKL52i/uEx/txRk0mhOTt
         v5ppdJb1gOkrJ9kHIYosakk6gMrm6+kaPmGP7r4+ngTTZBRS8l80zFg91D5C+BisPa
         n7XITJzctdTjBMFCYqUMEcMlGKsA8LPxmWizqdVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 03/25] net: ipa: use a bitmap for endpoint replenish_enabled
Date:   Fri,  4 Feb 2022 10:20:10 +0100
Message-Id: <20220204091914.389643045@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
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
 drivers/net/ipa/ipa_endpoint.h |   13 ++++++++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -901,7 +901,7 @@ static void ipa_endpoint_replenish(struc
 	struct gsi *gsi;
 	u32 backlog;
 
-	if (!endpoint->replenish_enabled) {
+	if (!test_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags)) {
 		if (count)
 			atomic_add(count, &endpoint->replenish_saved);
 		return;
@@ -938,7 +938,7 @@ static void ipa_endpoint_replenish_enabl
 	u32 max_backlog;
 	u32 saved;
 
-	endpoint->replenish_enabled = true;
+	set_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 	while ((saved = atomic_xchg(&endpoint->replenish_saved, 0)))
 		atomic_add(saved, &endpoint->replenish_backlog);
 
@@ -952,7 +952,7 @@ static void ipa_endpoint_replenish_disab
 {
 	u32 backlog;
 
-	endpoint->replenish_enabled = false;
+	clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 	while ((backlog = atomic_xchg(&endpoint->replenish_backlog, 0)))
 		atomic_add(backlog, &endpoint->replenish_saved);
 }
@@ -1469,7 +1469,7 @@ static void ipa_endpoint_setup_one(struc
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
@@ -40,6 +40,17 @@ enum ipa_endpoint_name {
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
  * @channel_id:	EP's GSI channel
  * @evt_ring_id: EP's GSI channel event ring
@@ -60,7 +71,7 @@ struct ipa_endpoint {
 	struct net_device *netdev;
 
 	/* Receive buffer replenishing for RX endpoints */
-	bool replenish_enabled;
+	DECLARE_BITMAP(replenish_flags, IPA_REPLENISH_COUNT);
 	u32 replenish_ready;
 	atomic_t replenish_saved;
 	atomic_t replenish_backlog;


