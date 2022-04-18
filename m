Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE78505276
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbiDRMpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbiDRMn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:43:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122ED26AD8;
        Mon, 18 Apr 2022 05:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1652B80EDC;
        Mon, 18 Apr 2022 12:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209DCC385A8;
        Mon, 18 Apr 2022 12:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285146;
        bh=udydudFpXI5RsOzbFPzo0ugZyhEPmUnyeJk9tXbSHNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZRsV4N1TunqLWB86XYmvmcZqIbeJpmvZR9Zu41tHl7eTgYRL0ydkV6PQJHFcSwHv
         LKp1s/ponMO60ORdHkYkwMix1aImNfqCsglfjes1o0hICR9onzvR13EwA5Ut3xZx3a
         jcvWj74OZgTAUA7XjU5UwIq1X7IhY9Bm7CIjLvpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/189] Drivers: hv: vmbus: Deactivate sysctl_record_panic_msg by default in isolated guests
Date:   Mon, 18 Apr 2022 14:12:16 +0200
Message-Id: <20220418121203.790593859@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>

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
index a939ca1a8d54..aea8125a4db8 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -76,8 +76,8 @@ static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
 
 	/*
 	 * Hyper-V should be notified only once about a panic.  If we will be
-	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
-	 * the notification here.
+	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
+	 * here.
 	 */
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
 	    && hyperv_report_reg()) {
@@ -99,8 +99,8 @@ static int hyperv_die_event(struct notifier_block *nb, unsigned long val,
 
 	/*
 	 * Hyper-V should be notified only once about a panic.  If we will be
-	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
-	 * the notification here.
+	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
+	 * here.
 	 */
 	if (hyperv_report_reg())
 		hyperv_report_panic(regs, val, true);
@@ -1545,14 +1545,20 @@ static int vmbus_bus_init(void)
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



