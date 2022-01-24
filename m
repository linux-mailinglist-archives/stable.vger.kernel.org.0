Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D225F49813B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240476AbiAXNh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbiAXNhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:37:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5337DC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:37:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19BDAB80EEB
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461C2C340E1;
        Mon, 24 Jan 2022 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643031472;
        bh=9wSZYVMpaFfAWLutB7Z/qmGSYglHWBwpM+ibBPfkykg=;
        h=Subject:To:Cc:From:Date:From;
        b=wHkDjxQuNZYF2E6SXh8ndDG9lpQmPMJ4SCSur/9yEAY39wmtQdJwlw5myMNxR1zIl
         LMnQKXoZoitaLilnEaavYi4uSmTknhvTG0txKw2EmUZ8E3LZRzq5krUKrGm8AtKRSg
         gKRY4tkV0vosGvE2aHW+Mt6Z/m5iyv+cJ5rBM0Zk=
Subject: FAILED: patch "[PATCH] net: ipa: prevent concurrent replenish" failed to apply to 5.16-stable tree
To:     elder@linaro.org, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:37:42 +0100
Message-ID: <1643031462146216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 998c0bd2b3715244da7639cc4e6a2062cb79c3f4 Mon Sep 17 00:00:00 2001
From: Alex Elder <elder@linaro.org>
Date: Wed, 12 Jan 2022 07:30:12 -0600
Subject: [PATCH] net: ipa: prevent concurrent replenish

We have seen cases where an endpoint RX completion interrupt arrives
while replenishing for the endpoint is underway.  This causes another
instance of replenishing to begin as part of completing the receive
transaction.  If this occurs it can lead to transaction corruption.

Use a new flag to ensure only one replenish instance for an endpoint
executes at a time.

Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index cddddcedaf72..68291a3efd04 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1088,15 +1088,27 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
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
@@ -1691,6 +1703,7 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
 		 * backlog is the same as the maximum outstanding TREs.
 		 */
 		clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
+		clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
 		atomic_set(&endpoint->replenish_saved,
 			   gsi_channel_tre_max(gsi, endpoint->channel_id));
 		atomic_set(&endpoint->replenish_backlog, 0);
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 07d5c20e5f00..0313cdc607de 100644
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
 

