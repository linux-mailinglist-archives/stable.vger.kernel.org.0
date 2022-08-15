Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7897359484F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343694AbiHOX30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244637AbiHOXYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:24:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD7F876B6;
        Mon, 15 Aug 2022 13:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDA2B6068D;
        Mon, 15 Aug 2022 20:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03EAC433D6;
        Mon, 15 Aug 2022 20:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593947;
        bh=kcuCtULqp2kPi5vMU4qtw7Ki1COObkUW6h4KdKchGMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3tSE//f4wVND0u8N9564HmSFHTwpmPtj/AS6191Eb732JJwYk83QBLtKfHQqXFaQ
         yQQlcK5Nvam3ho9xou4lISKcz7sfvUo72iJoXhD7qq639NCb84ogQBRm12OO0CaD6C
         DGfLBL4AxPa0SBggoB2Dh59+qCkDcr8fAAiULqnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1033/1095] intel_idle: make SPR C1 and C1E be independent
Date:   Mon, 15 Aug 2022 20:07:12 +0200
Message-Id: <20220815180511.794102365@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

[ Upstream commit 1548fac47a114b42063def551eb152a536ed9697 ]

This patch partially reverts the changes made by the following commit:

da0e58c038e6 intel_idle: add 'preferred_cstates' module argument

As that commit describes, on early Sapphire Rapids Xeon platforms the C1 and
C1E states were mutually exclusive, so that users could only have either C1 and
C6, or C1E and C6.

However, Intel firmware engineers managed to remove this limitation and make C1
and C1E to be completely independent, just like on previous Xeon platforms.

Therefore, this patch:
 * Removes commentary describing the old, and now non-existing SPR C1E
   limitation.
 * Marks SPR C1E as available by default.
 * Removes the 'preferred_cstates' parameter handling for SPR. Both C1 and
   C1E will be available regardless of 'preferred_cstates' value.

We expect that all SPR systems are shipping with new firmware, which includes
the C1/C1E improvement.

Cc: v5.18+ <stable@vger.kernel.org> # v5.18+
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 907700d1e78e..9515a3146dc9 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -911,16 +911,6 @@ static struct cpuidle_state adl_l_cstates[] __initdata = {
 		.enter = NULL }
 };
 
-/*
- * On Sapphire Rapids Xeon C1 has to be disabled if C1E is enabled, and vice
- * versa. On SPR C1E is enabled only if "C1E promotion" bit is set in
- * MSR_IA32_POWER_CTL. But in this case there effectively no C1, because C1
- * requests are promoted to C1E. If the "C1E promotion" bit is cleared, then
- * both C1 and C1E requests end up with C1, so there is effectively no C1E.
- *
- * By default we enable C1 and disable C1E by marking it with
- * 'CPUIDLE_FLAG_UNUSABLE'.
- */
 static struct cpuidle_state spr_cstates[] __initdata = {
 	{
 		.name = "C1",
@@ -933,8 +923,7 @@ static struct cpuidle_state spr_cstates[] __initdata = {
 	{
 		.name = "C1E",
 		.desc = "MWAIT 0x01",
-		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_ALWAYS_ENABLE |
-					   CPUIDLE_FLAG_UNUSABLE,
+		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_ALWAYS_ENABLE,
 		.exit_latency = 2,
 		.target_residency = 4,
 		.enter = &intel_idle,
@@ -1756,17 +1745,6 @@ static void __init spr_idle_state_table_update(void)
 {
 	unsigned long long msr;
 
-	/* Check if user prefers C1E over C1. */
-	if ((preferred_states_mask & BIT(2)) &&
-	    !(preferred_states_mask & BIT(1))) {
-		/* Disable C1 and enable C1E. */
-		spr_cstates[0].flags |= CPUIDLE_FLAG_UNUSABLE;
-		spr_cstates[1].flags &= ~CPUIDLE_FLAG_UNUSABLE;
-
-		/* Enable C1E using the "C1E promotion" bit. */
-		c1e_promotion = C1E_PROMOTION_ENABLE;
-	}
-
 	/*
 	 * By default, the C6 state assumes the worst-case scenario of package
 	 * C6. However, if PC6 is disabled, we update the numbers to match
-- 
2.35.1



