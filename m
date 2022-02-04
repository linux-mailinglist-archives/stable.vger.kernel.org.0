Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3384A9622
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357505AbiBDJW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357531AbiBDJWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:22:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668D6C061760;
        Fri,  4 Feb 2022 01:22:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD5A46162C;
        Fri,  4 Feb 2022 09:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08BBC004E1;
        Fri,  4 Feb 2022 09:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966530;
        bh=WaDGmJ3k0j4stp3NMd9qs5wTtfDR4VHH69jQNzw4zAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iomp+G4sVDLziErQcGM0Rky/Zb3qb0+llMa2lkeverZ+jLIu++wGF1fZQ+qUrPO1z
         jL9AswVhN5Qd9A005ItC9kohFsoKVcEDyHf2HdyVDDINlzRKzxAT1HY7M1bt/pBz7b
         uyI43jfZfxm2+YO6LcrJnLGERiLUGtdavuWOtBRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 04/25] net: ipa: prevent concurrent replenish
Date:   Fri,  4 Feb 2022 10:20:11 +0100
Message-Id: <20220204091914.428884604@linuxfoundation.org>
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
 drivers/net/ipa/ipa_endpoint.c |   12 ++++++++++++
 drivers/net/ipa/ipa_endpoint.h |    2 ++
 2 files changed, 14 insertions(+)

--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -907,16 +907,27 @@ static void ipa_endpoint_replenish(struc
 		return;
 	}
 
+	/* If already active, just update the backlog */
+	if (test_and_set_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags)) {
+		if (count)
+			atomic_add(count, &endpoint->replenish_backlog);
+		return;
+	}
 
 	while (atomic_dec_not_zero(&endpoint->replenish_backlog))
 		if (ipa_endpoint_replenish_one(endpoint))
 			goto try_again_later;
+
+	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
+
 	if (count)
 		atomic_add(count, &endpoint->replenish_backlog);
 
 	return;
 
 try_again_later:
+	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
+
 	/* The last one didn't succeed, so fix the backlog */
 	backlog = atomic_add_return(count + 1, &endpoint->replenish_backlog);
 
@@ -1470,6 +1481,7 @@ static void ipa_endpoint_setup_one(struc
 		 * backlog is the same as the maximum outstanding TREs.
 		 */
 		clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
+		clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
 		atomic_set(&endpoint->replenish_saved,
 			   gsi_channel_tre_max(gsi, endpoint->channel_id));
 		atomic_set(&endpoint->replenish_backlog, 0);
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -43,10 +43,12 @@ enum ipa_endpoint_name {
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
 


