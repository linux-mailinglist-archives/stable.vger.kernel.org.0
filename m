Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DF74B70C7
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbiBOPa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:30:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240076AbiBOPaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:30:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51A5B0C74;
        Tue, 15 Feb 2022 07:28:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6292FB81AFA;
        Tue, 15 Feb 2022 15:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FF8C340EB;
        Tue, 15 Feb 2022 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938921;
        bh=Z9AP8sHVGnKeExOiFmw9xaQ/eAc+E0fki+qkJR1RQuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lw6tfkGo6GSFHEaxB64U7kACjTZzL9A//zQvk9LN6I5vKJISzhumjlHudALbz5taa
         0iv8CkGwWRtVMcwLhPpgk+Onq3GC/Un7bb0XU0kS4jh1DBvAjgRwNZN7qtj66qo2As
         z65sdloJHBJVtiRtoGEE5Oo5ktBORXq5+9q5y6XsDB9Hcu3SUltNbnFamxUNpXs1rG
         COdj5wiY2VjlhcW0U/GJGzY+6zU7AiFE5rNSZ/B2boLShIhsXPD4sfn8HJBhl3S5bq
         BG1/Y6vMuJ5vSiPotjwxXnkxW15ZVw7v7hRjktzxgj5aOiXSX+QY6HrFBD6LQHt/XU
         vKrLX8+KdHfsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Padmanabha Srinivasaiah <treasure4paddy@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, nsaenz@kernel.org,
        gascoar@gmail.com, ojaswin98@gmail.com,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 04/33] staging: vc04_services: Fix RCU dereference check
Date:   Tue, 15 Feb 2022 10:28:02 -0500
Message-Id: <20220215152831.580780-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Padmanabha Srinivasaiah <treasure4paddy@gmail.com>

[ Upstream commit 0cea730cac824edf78ffd3302938ed5fe2b9d50d ]

In service_callback path RCU dereferenced pointer struct vchiq_service
need to be accessed inside rcu read-critical section.

Also userdata/user_service part of vchiq_service is accessed around
different synchronization mechanism, getting an extra reference to a
pointer keeps sematics simpler and avoids prolonged graceperiod.

Accessing vchiq_service with rcu_read_[lock/unlock] fixes below issue.

[   32.201659] =============================
[   32.201664] WARNING: suspicious RCU usage
[   32.201670] 5.15.11-rt24-v8+ #3 Not tainted
[   32.201680] -----------------------------
[   32.201685] drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.h:529 suspicious rcu_dereference_check() usage!
[   32.201695]
[   32.201695] other info that might help us debug this:
[   32.201695]
[   32.201700]
[   32.201700] rcu_scheduler_active = 2, debug_locks = 1
[   32.201708] no locks held by vchiq-slot/0/98.
[   32.201715]
[   32.201715] stack backtrace:
[   32.201723] CPU: 1 PID: 98 Comm: vchiq-slot/0 Not tainted 5.15.11-rt24-v8+ #3
[   32.201733] Hardware name: Raspberry Pi 4 Model B Rev 1.4 (DT)
[   32.201739] Call trace:
[   32.201742]  dump_backtrace+0x0/0x1b8
[   32.201772]  show_stack+0x20/0x30
[   32.201784]  dump_stack_lvl+0x8c/0xb8
[   32.201799]  dump_stack+0x18/0x34
[   32.201808]  lockdep_rcu_suspicious+0xe4/0xf8
[   32.201817]  service_callback+0x124/0x400
[   32.201830]  slot_handler_func+0xf60/0x1e20
[   32.201839]  kthread+0x19c/0x1a8
[   32.201849]  ret_from_fork+0x10/0x20

Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Padmanabha Srinivasaiah <treasure4paddy@gmail.com>
Link: https://lore.kernel.org/r/20211231195406.5479-1-treasure4paddy@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../interface/vchiq_arm/vchiq_arm.c           | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 967f10b9582a8..ea9a53bdb4174 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1033,15 +1033,27 @@ service_callback(enum vchiq_reason reason, struct vchiq_header *header,
 
 	DEBUG_TRACE(SERVICE_CALLBACK_LINE);
 
+	rcu_read_lock();
 	service = handle_to_service(handle);
-	if (WARN_ON(!service))
+	if (WARN_ON(!service)) {
+		rcu_read_unlock();
 		return VCHIQ_SUCCESS;
+	}
 
 	user_service = (struct user_service *)service->base.userdata;
 	instance = user_service->instance;
 
-	if (!instance || instance->closing)
+	if (!instance || instance->closing) {
+		rcu_read_unlock();
 		return VCHIQ_SUCCESS;
+	}
+
+	/*
+	 * As hopping around different synchronization mechanism,
+	 * taking an extra reference results in simpler implementation.
+	 */
+	vchiq_service_get(service);
+	rcu_read_unlock();
 
 	vchiq_log_trace(vchiq_arm_log_level,
 		"%s - service %lx(%d,%p), reason %d, header %lx, instance %lx, bulk_userdata %lx",
@@ -1074,6 +1086,7 @@ service_callback(enum vchiq_reason reason, struct vchiq_header *header,
 					NULL, user_service, bulk_userdata);
 				if (status != VCHIQ_SUCCESS) {
 					DEBUG_TRACE(SERVICE_CALLBACK_LINE);
+					vchiq_service_put(service);
 					return status;
 				}
 			}
@@ -1084,11 +1097,13 @@ service_callback(enum vchiq_reason reason, struct vchiq_header *header,
 				vchiq_log_info(vchiq_arm_log_level,
 					"%s interrupted", __func__);
 				DEBUG_TRACE(SERVICE_CALLBACK_LINE);
+				vchiq_service_put(service);
 				return VCHIQ_RETRY;
 			} else if (instance->closing) {
 				vchiq_log_info(vchiq_arm_log_level,
 					"%s closing", __func__);
 				DEBUG_TRACE(SERVICE_CALLBACK_LINE);
+				vchiq_service_put(service);
 				return VCHIQ_ERROR;
 			}
 			DEBUG_TRACE(SERVICE_CALLBACK_LINE);
@@ -1117,6 +1132,7 @@ service_callback(enum vchiq_reason reason, struct vchiq_header *header,
 		header = NULL;
 	}
 	DEBUG_TRACE(SERVICE_CALLBACK_LINE);
+	vchiq_service_put(service);
 
 	if (skip_completion)
 		return VCHIQ_SUCCESS;
-- 
2.34.1

