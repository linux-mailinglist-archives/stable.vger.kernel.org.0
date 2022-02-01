Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C064A549A
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 02:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiBABRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 20:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiBABRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 20:17:05 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6898FC061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:17:05 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id o10so13038809ilh.0
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Doa7Y7pWgNWVLCaZJ78hK1yWjrRlAu/s6eUkXXI5TDc=;
        b=wV1X8crHiAD9O+1YRp+t8FCAXCzpCCQsWUdVO3vTD3xboCnJALCcOzbpNcwi5tzcqq
         GIq5eCw4k6gph27SUZFmf56Kfd6U9c9RSfPzL2vlIxPt7KlOOMQGjCetL0yXWpirmPrX
         oXMwpdp7JU65gWx4Y6S9yl1Pq2nDc3NulyCtXnzE7vpyRgkVzpeUznUxlRLRHknBxt3n
         l/5l7MyOaXp+uj+Ji4DItZbkF0L+DTfOLwBOOWGnHRr5U3A7vdgW1/hvN1midqlFBhpu
         CWls1jQaP15q/IFABRxM4gFD0Iy6j2TYAggzarKIVxsfzerh+Iu3zaGs9dme8hItUcZu
         yRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Doa7Y7pWgNWVLCaZJ78hK1yWjrRlAu/s6eUkXXI5TDc=;
        b=AX+Wqg3SZc6PFcgF9BwZwpD1EJb8PiB9t1Z0/zN0taBsv0qi6Y8G1hQ2HvDqOqyDrq
         Pau69Kj8YbX5ManktqpWjxkZIsF/H/xilZ6KWlnZQdnGjt5xkc4s63+zugf+CvUcKwHA
         fEzXF9jQ+JM2TxaQvm1GXW+CCnDIB2GsOZIw9+92FwcdB6mDb0EFu8MWwSRo6xleER50
         MVmbpbwkLb32drTdE54GzJY1XwzWUWFKkTkOsztIRHEXOFRXHvQekdgFBdkqkgE1KdaM
         Li7DynSe2DsytRZU5SQtUuMv2NkyxZTxLygi9bpLnsC4Wifwg/Dhq3vriyoKPhS5/mjc
         Db0g==
X-Gm-Message-State: AOAM532YZRslg7T20JQniPexP1Bn+3YUaxg49SrcqPfKgzvuZf+MxaeI
        E8XYWlxjY7XLIqeEUJcxvis5vIQ1owj4GVQX
X-Google-Smtp-Source: ABdhPJwlgsUTySZTuF+34zXtBAFD0gEU1g5JT2GDJzVh5a9Zr6IkQS+gebVOj1LW8iYmOYobbjjpqg==
X-Received: by 2002:a92:d447:: with SMTP id r7mr4576068ilm.35.1643678224535;
        Mon, 31 Jan 2022 17:17:04 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k2sm5966919iow.7.2022.01.31.17.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 17:17:04 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     davem@davemloft.net, elder@kernel.org
Subject: [PATCH 2/2] net: ipa: prevent concurrent replenish
Date:   Mon, 31 Jan 2022 19:16:58 -0600
Message-Id: <20220201011658.308283-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220201011658.308283-1-elder@linaro.org>
References: <20220201011658.308283-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

    XXX commit 998c0bd2b3715244da7639cc4e6a2062cb79c3f4 upstream.

We have seen cases where an endpoint RX completion interrupt arrives
while replenishing for the endpoint is underway.  This causes another
instance of replenishing to begin as part of completing the receive
transaction.  If this occurs it can lead to transaction corruption.

Use a new flag to ensure only one replenish instance for an endpoint
executes at a time.

References: https://lore.kernel.org/stable/1643031462146216@kroah.com
Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ipa/ipa_endpoint.c | 12 ++++++++++++
 drivers/net/ipa/ipa_endpoint.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 80380f5966142..2e1e558275b1c 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -907,16 +907,27 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, u32 count)
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
 	backlog = atomic_inc_return(&endpoint->replenish_backlog);
 
@@ -1473,6 +1484,7 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
 		 * backlog is the same as the maximum outstanding TREs.
 		 */
 		clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
+		clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
 		atomic_set(&endpoint->replenish_saved,
 			   gsi_channel_tre_max(gsi, endpoint->channel_id));
 		atomic_set(&endpoint->replenish_backlog, 0);
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index ffae393500d4f..823c4a1296587 100644
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
 
-- 
2.32.0

