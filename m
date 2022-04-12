Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5954FC9C7
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242622AbiDLAsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242793AbiDLAr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA9513F6E;
        Mon, 11 Apr 2022 17:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C94A617F2;
        Tue, 12 Apr 2022 00:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C88DC385AB;
        Tue, 12 Apr 2022 00:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724309;
        bh=pfzk2lkTm9Eb23zE1+4Q0VFnUkwXVGJ+FUusJD95gG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGbCYaMHrVsU4PYvVAV359T3QSo3qPQ0C2kD29KcuxZZ6x2mm8cCG8Zpt1N+XpZLj
         LB0pQJkjo6nwn1bby6N8J1ohWnB2sUUBjlbV1WLM5PZvNPxaGn09GgMIh9vkX6buuV
         TiVZ0L6GTuJmdVvqZb9H9GqFYn4cwAaKINAUOYbKvntizlwI1x+i6WFAsaWBkPRX1u
         iI1b53jKW8nm2mqE3Qu25ijAIuVxivrH0EHxAH/l5av8Z5JmxBfgeQUiLRWtkb37NR
         jQNp6uUHP35weHbC63nB4CbeT/cswBKO8m8OaxM0ORsFKyB3b+aHXV4K1DtyBcWG0a
         W2kJ5N2tb0/SA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Sasha Levin <sashal@kernel.org>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 13/49] Drivers: hv: vmbus: Deactivate sysctl_record_panic_msg by default in isolated guests
Date:   Mon, 11 Apr 2022 20:43:31 -0400
Message-Id: <20220412004411.349427-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>

[ Upstream commit 9f8b577f7b43b2170628d6c537252785dcc2dcea ]

hv_panic_page might contain guest-sensitive information, do not dump it
over to Hyper-V by default in isolated guests.

While at it, update some comments in hyperv_{panic,die}_event().

Reported-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/20220301141135.2232-1-parri.andrea@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 12a2b37e87f3..a963b970ffb2 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -77,8 +77,8 @@ static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
 
 	/*
 	 * Hyper-V should be notified only once about a panic.  If we will be
-	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
-	 * the notification here.
+	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
+	 * here.
 	 */
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
 	    && hyperv_report_reg()) {
@@ -100,8 +100,8 @@ static int hyperv_die_event(struct notifier_block *nb, unsigned long val,
 
 	/*
 	 * Hyper-V should be notified only once about a panic.  If we will be
-	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
-	 * the notification here.
+	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
+	 * here.
 	 */
 	if (hyperv_report_reg())
 		hyperv_report_panic(regs, val, true);
@@ -1546,14 +1546,20 @@ static int vmbus_bus_init(void)
 	if (ret)
 		goto err_connect;
 
+	if (hv_is_isolation_supported())
+		sysctl_record_panic_msg = 0;
+
 	/*
 	 * Only register if the crash MSRs are available
 	 */
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
 		u64 hyperv_crash_ctl;
 		/*
-		 * Sysctl registration is not fatal, since by default
-		 * reporting is enabled.
+		 * Panic message recording (sysctl_record_panic_msg)
+		 * is enabled by default in non-isolated guests and
+		 * disabled by default in isolated guests; the panic
+		 * message recording won't be available in isolated
+		 * guests should the following registration fail.
 		 */
 		hv_ctl_table_hdr = register_sysctl_table(hv_root_table);
 		if (!hv_ctl_table_hdr)
-- 
2.35.1

