Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F360F529014
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346580AbiEPTyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346679AbiEPTxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:53:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860404704C;
        Mon, 16 May 2022 12:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4278160BB1;
        Mon, 16 May 2022 19:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26087C34115;
        Mon, 16 May 2022 19:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730522;
        bh=MN5DrjPhuKaz6X+gSJol3l5D47LkryzVT7lFWe8dDqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SyZvjmOdKLka2muqTFjbLFBRPlyI0UBZIo+CHjWjpXQZPSTpwWUHF02H4gLRi99d5
         701jFoaszogQGtLgfQuu8f4JYwvpw2KRc9meASZk/vlXP/ljrGV9EzPZpW28O+qzb4
         6FK+FQnYFSImDjKOUnPtjh06ek4SDDjTc6zsib0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/102] dim: initialize all struct fields
Date:   Mon, 16 May 2022 21:36:00 +0200
Message-Id: <20220516193624.750824454@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit ee1444b5e1df4155b591d0d9b1e72853a99ea861 ]

The W=2 build pointed out that the code wasn't initializing all the
variables in the dim_cq_moder declarations with the struct initializers.
The net change here is zero since these structs were already static
const globals and were initialized with zeros by the compiler, but
removing compiler warnings has value in and of itself.

lib/dim/net_dim.c: At top level:
lib/dim/net_dim.c:54:9: warning: missing initializer for field ‘comps’ of ‘const struct dim_cq_moder’ [-Wmissing-field-initializers]
   54 |         NET_DIM_RX_EQE_PROFILES,
      |         ^~~~~~~~~~~~~~~~~~~~~~~
In file included from lib/dim/net_dim.c:6:
./include/linux/dim.h:45:13: note: ‘comps’ declared here
   45 |         u16 comps;
      |             ^~~~~

and repeats for the tx struct, and once you fix the comps entry then
the cq_period_mode field needs the same treatment.

Use the commonly accepted style to indicate to the compiler that we
know what we're doing, and add a comma at the end of each struct
initializer to clean up the issue, and use explicit initializers
for the fields we are initializing which makes the compiler happy.

While here and fixing these lines, clean up the code slightly with
a fix for the super long lines by removing the word "_MODERATION" from a
couple defines only used in this file.

Fixes: f8be17b81d44 ("lib/dim: Fix -Wunused-const-variable warnings")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Link: https://lore.kernel.org/r/20220507011038.14568-1-jesse.brandeburg@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dim/net_dim.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/lib/dim/net_dim.c b/lib/dim/net_dim.c
index 06811d866775..53f6b9c6e936 100644
--- a/lib/dim/net_dim.c
+++ b/lib/dim/net_dim.c
@@ -12,41 +12,41 @@
  *        Each profile size must be of NET_DIM_PARAMS_NUM_PROFILES
  */
 #define NET_DIM_PARAMS_NUM_PROFILES 5
-#define NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE 256
-#define NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE 128
+#define NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE 256
+#define NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE 128
 #define NET_DIM_DEF_PROFILE_CQE 1
 #define NET_DIM_DEF_PROFILE_EQE 1
 
 #define NET_DIM_RX_EQE_PROFILES { \
-	{1,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{8,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{64,  NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{128, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{256, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
+	{.usec = 1,   .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 8,   .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 64,  .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 128, .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 256, .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}  \
 }
 
 #define NET_DIM_RX_CQE_PROFILES { \
-	{2,  256},             \
-	{8,  128},             \
-	{16, 64},              \
-	{32, 64},              \
-	{64, 64}               \
+	{.usec = 2,  .pkts = 256,},             \
+	{.usec = 8,  .pkts = 128,},             \
+	{.usec = 16, .pkts = 64,},              \
+	{.usec = 32, .pkts = 64,},              \
+	{.usec = 64, .pkts = 64,}               \
 }
 
 #define NET_DIM_TX_EQE_PROFILES { \
-	{1,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{8,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{32,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{64,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{128, NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE}   \
+	{.usec = 1,   .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 8,   .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 32,  .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 64,  .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 128, .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,}   \
 }
 
 #define NET_DIM_TX_CQE_PROFILES { \
-	{5,  128},  \
-	{8,  64},  \
-	{16, 32},  \
-	{32, 32},  \
-	{64, 32}   \
+	{.usec = 5,  .pkts = 128,},  \
+	{.usec = 8,  .pkts = 64,},  \
+	{.usec = 16, .pkts = 32,},  \
+	{.usec = 32, .pkts = 32,},  \
+	{.usec = 64, .pkts = 32,}   \
 }
 
 static const struct dim_cq_moder
-- 
2.35.1



