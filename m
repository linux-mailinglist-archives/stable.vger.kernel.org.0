Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4F24A5499
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 02:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiBABRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 20:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiBABRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 20:17:04 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A644C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:17:04 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id q11so4827760ild.11
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LAgAscH9vjrvTKdyRdJAFmxfGPWOd/Tk2lnlhlUtOEI=;
        b=sPNN2IC8Kqp3UN9Dh00Kj+axC2cnr1lZ43f6JzbxnKivbGttxCAON/lnZMJo4rBEr9
         IunBZHSI+xd/UxVUNqRJm3KLAb0LO6PG2Lf6BKZm6+Gu3wDhR8SujEtwnjmzKV6rFMgT
         7mGzI3wddiBjyKPNV8mcziW0H2OAZr5kTVcZbiyy+WjN12shZ4ih5TYHHle5EDUK1vhn
         4L8bo5Jxw08qStG8CO1upLGNtdbrT6aW1w+T49m/2CxCqRZ4CAPJGXN5Onni6w+p3cHr
         gfAvaG+1tFUTxBtIhwQaaG7UipPaYYsIPLCbwwDa0CH7+YW99gTxeCLTNwsHmzFoEzYh
         F0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LAgAscH9vjrvTKdyRdJAFmxfGPWOd/Tk2lnlhlUtOEI=;
        b=VN0cs+lBs5EZnczN2nzuk+opz85otVZa615xdWilZFfXaWIWPH23d1XdyJOnZafGKY
         SwZUfGd0lsOlyJv0h9rpgh1D/97ViwZGRZWAsK0XFHp/rQug8oi9hLgYXNo0mrCJOwEa
         DF4vIEq/u/kmgJ0XePCo0iA3blPMFH48Saxhj652/KXKmIfdOxD1KSTLdT/McttsqwrT
         sCEElgt+oolrmTt7U+9xwIkNvJK/AKJa2QoOAF+qx/1Dks7v/fdKKB41nVVgEm+WR2E6
         nqMZrxzE37fRb1sbH5xQxH0OwwMcJ/36NPRtIkkzielzIstt3OakXBIy5/RYL1+EWqdS
         ekdw==
X-Gm-Message-State: AOAM5323FVdMbacHkl5qiW8A/HhZ79pUqw+66TBmUJtfc2u4JqLdwGDH
        XznR9wX38+7wrmVGfXiuFDaTNri237sZ9psA
X-Google-Smtp-Source: ABdhPJyVldM7b5pp0VbgjroDRjl0buKaitQVNpYdTHLerH2BT/lOAV+t2jbVx1oywRie+4dxk3/KKw==
X-Received: by 2002:a92:c54e:: with SMTP id a14mr14390878ilj.256.1643678223417;
        Mon, 31 Jan 2022 17:17:03 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k2sm5966919iow.7.2022.01.31.17.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 17:17:02 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     davem@davemloft.net, elder@kernel.org
Subject: [PATCH 1/2] net: ipa: use a bitmap for endpoint replenish_enabled
Date:   Mon, 31 Jan 2022 19:16:57 -0600
Message-Id: <20220201011658.308283-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220201011658.308283-1-elder@linaro.org>
References: <20220201011658.308283-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

    XXX commit c1aaa01dbf4cef95af3e04a5a43986c290e06ea3 upstream.

Define a new replenish_flags bitmap to contain Boolean flags
associated with an endpoint's replenishing state.  Replace the
replenish_enabled field with a flag in that bitmap.  This is to
prepare for the next patch, which adds another flag.

References: https://lore.kernel.org/stable/1643031462146216@kroah.com
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ipa/ipa_endpoint.c |  8 ++++----
 drivers/net/ipa/ipa_endpoint.h | 13 ++++++++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index a37aae00e128f..80380f5966142 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -901,7 +901,7 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, u32 count)
 	struct gsi *gsi;
 	u32 backlog;
 
-	if (!endpoint->replenish_enabled) {
+	if (!test_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags)) {
 		if (count)
 			atomic_add(count, &endpoint->replenish_saved);
 		return;
@@ -941,7 +941,7 @@ static void ipa_endpoint_replenish_enable(struct ipa_endpoint *endpoint)
 	u32 max_backlog;
 	u32 saved;
 
-	endpoint->replenish_enabled = true;
+	set_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 	while ((saved = atomic_xchg(&endpoint->replenish_saved, 0)))
 		atomic_add(saved, &endpoint->replenish_backlog);
 
@@ -955,7 +955,7 @@ static void ipa_endpoint_replenish_disable(struct ipa_endpoint *endpoint)
 {
 	u32 backlog;
 
-	endpoint->replenish_enabled = false;
+	clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 	while ((backlog = atomic_xchg(&endpoint->replenish_backlog, 0)))
 		atomic_add(backlog, &endpoint->replenish_saved);
 }
@@ -1472,7 +1472,7 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
 		/* RX transactions require a single TRE, so the maximum
 		 * backlog is the same as the maximum outstanding TREs.
 		 */
-		endpoint->replenish_enabled = false;
+		clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 		atomic_set(&endpoint->replenish_saved,
 			   gsi_channel_tre_max(gsi, endpoint->channel_id));
 		atomic_set(&endpoint->replenish_backlog, 0);
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 58a245de488e8..ffae393500d4f 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -39,6 +39,17 @@ enum ipa_endpoint_name {
 
 #define IPA_ENDPOINT_MAX		32	/* Max supported by driver */
 
+/**
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
 /**
  * struct ipa_endpoint - IPA endpoint information
  * @channel_id:	EP's GSI channel
@@ -60,7 +71,7 @@ struct ipa_endpoint {
 	struct net_device *netdev;
 
 	/* Receive buffer replenishing for RX endpoints */
-	bool replenish_enabled;
+	DECLARE_BITMAP(replenish_flags, IPA_REPLENISH_COUNT);
 	u32 replenish_ready;
 	atomic_t replenish_saved;
 	atomic_t replenish_backlog;
-- 
2.32.0

