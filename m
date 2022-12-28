Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14588657D43
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiL1PlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiL1PlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:41:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C31F17047
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:41:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6CEC6155E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2C6C433F0;
        Wed, 28 Dec 2022 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242069;
        bh=CqQRcsSQq058uT3OMgNYfTs9DiLJtY+KpGVWtVw1EFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmKQWEvkRy1bXM/6GUo7iFxBnsYya6wVQ15tB7ZM9iRU0l8tshCrjNj9HsbXsg8ET
         awOwZRpUaRHxgM6f1EWyl10kAd0V/yf9ioKt3L7+e3NPvpy/RwigAKj7eErASyuQg0
         lTleu1izc9iqmWLWA44+R9cu3oG8jpaaRy9cmy9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0322/1146] wifi: iwlwifi: mei: fix potential NULL-ptr deref after clone
Date:   Wed, 28 Dec 2022 15:31:01 +0100
Message-Id: <20221228144338.900054101@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d3df49dda431f7ae4132a9a0ac25a5134c04e812 ]

If cloning the SKB fails, don't try to use it, but rather return
as if we should pass it.

Coverity CID: 1503456

Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20221030191011.0ce03ba99601.I87960b7cb0a3d16b9fd8d9144027e7e2587f5a58@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/net.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/net.c b/drivers/net/wireless/intel/iwlwifi/mei/net.c
index 3472167c8370..eac46d1a397a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/net.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/net.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2021 Intel Corporation
+ * Copyright (C) 2021-2022 Intel Corporation
  */
 
 #include <uapi/linux/if_ether.h>
@@ -337,10 +337,14 @@ rx_handler_result_t iwl_mei_rx_filter(struct sk_buff *orig_skb,
 	if (!*pass_to_csme)
 		return RX_HANDLER_PASS;
 
-	if (ret == RX_HANDLER_PASS)
+	if (ret == RX_HANDLER_PASS) {
 		skb = skb_copy(orig_skb, GFP_ATOMIC);
-	else
+
+		if (!skb)
+			return RX_HANDLER_PASS;
+	} else {
 		skb = orig_skb;
+	}
 
 	/* CSME wants the MAC header as well, push it back */
 	skb_push(skb, skb->data - skb_mac_header(skb));
-- 
2.35.1



