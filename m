Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1F24A96A6
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358302AbiBDJ2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358305AbiBDJ00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:26:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACEDC06175F;
        Fri,  4 Feb 2022 01:26:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23545B836F9;
        Fri,  4 Feb 2022 09:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E09EC004E1;
        Fri,  4 Feb 2022 09:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966757;
        bh=wsDPVvMJ3fihSgGDbISGT78IhKQRNro2j33j6ziBLu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpBU6Bp5c5v9ungTrQTH5476TjZXJ5vG/EU0s1toXSuxFZK9UdDAInix0sGYq2YP5
         n06c+1A/HgrhvCK2MrvTVDKTYhgdwwLKf/UDJmEmXqn/f9DhFxRyFLk9fbfWVsOy5n
         EGnuXpRDPylSaQVXCBFjfPLwHibaQ1VlNTCoMwgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 04/43] net: ipa: prevent concurrent replenish
Date:   Fri,  4 Feb 2022 10:22:11 +0100
Message-Id: <20220204091917.334430355@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

commit 998c0bd2b3715244da7639cc4e6a2062cb79c3f4 upstream.

We have seen cases where an endpoint RX completion interrupt arrives
while replenishing for the endpoint is underway.  This causes another
instance of replenishing to begin as part of completing the receive
transaction.  If this occurs it can lead to transaction corruption.

Use a new flag to ensure only one replenish instance for an endpoint
executes at a time.

Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_endpoint.c |   13 +++++++++++++
 drivers/net/ipa/ipa_endpoint.h |    2 ++
 2 files changed, 15 insertions(+)

--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1075,15 +1075,27 @@ static void ipa_endpoint_replenish(struc
 		return;
 	}
 
+	/* If already active, just update the backlog */
+	if (test_and_set_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags)) {
+		if (add_one)
+			atomic_inc(&endpoint->replenish_backlog);
+		return;
+	}
+
 	while (atomic_dec_not_zero(&endpoint->replenish_backlog))
 		if (ipa_endpoint_replenish_one(endpoint))
 			goto try_again_later;
+
+	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
+
 	if (add_one)
 		atomic_inc(&endpoint->replenish_backlog);
 
 	return;
 
 try_again_later:
+	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
+
 	/* The last one didn't succeed, so fix the backlog */
 	delta = add_one ? 2 : 1;
 	backlog = atomic_add_return(delta, &endpoint->replenish_backlog);
@@ -1666,6 +1678,7 @@ static void ipa_endpoint_setup_one(struc
 		 * backlog is the same as the maximum outstanding TREs.
 		 */
 		clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
+		clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
 		atomic_set(&endpoint->replenish_saved,
 			   gsi_channel_tre_max(gsi, endpoint->channel_id));
 		atomic_set(&endpoint->replenish_backlog, 0);
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -44,10 +44,12 @@ enum ipa_endpoint_name {
  * enum ipa_replenish_flag:	RX buffer replenish flags
  *
  * @IPA_REPLENISH_ENABLED:	Whether receive buffer replenishing is enabled
+ * @IPA_REPLENISH_ACTIVE:	Whether replenishing is underway
  * @IPA_REPLENISH_COUNT:	Number of defined replenish flags
  */
 enum ipa_replenish_flag {
 	IPA_REPLENISH_ENABLED,
+	IPA_REPLENISH_ACTIVE,
 	IPA_REPLENISH_COUNT,	/* Number of flags (must be last) */
 };
 


