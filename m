Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22C960BC64
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiJXVnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiJXVnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:43:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7B02E8BAD;
        Mon, 24 Oct 2022 12:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80AEFB8160C;
        Mon, 24 Oct 2022 12:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCF7C433C1;
        Mon, 24 Oct 2022 12:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613619;
        bh=WwLmp2q3LG4H7tU6nfLi2QNNkpGu3VvUBc/Mb+G7hoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmOKx+zqLgTr2zrTA/dwvZd+rGOzkYZXn/ydTR2bDuYqX2R2J2XR8LDqz1FjFfKFJ
         /N9zLENLidmVJe2o+U/E9BkKxNZW8mWz7aaZihm5/USMxX6neMKuGkQUNw7RMYMYx9
         FeRzY6vk+4NC2lPKSsS77eRYG9FNwEpph8PyDq4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/255] thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash
Date:   Mon, 24 Oct 2022 13:31:38 +0200
Message-Id: <20221024113009.197311082@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 68b99e94a4a2db6ba9b31fe0485e057b9354a640 ]

When CPU 0 is offline and intel_powerclamp is used to inject
idle, it generates kernel BUG:

BUG: using smp_processor_id() in preemptible [00000000] code: bash/15687
caller is debug_smp_processor_id+0x17/0x20
CPU: 4 PID: 15687 Comm: bash Not tainted 5.19.0-rc7+ #57
Call Trace:
<TASK>
dump_stack_lvl+0x49/0x63
dump_stack+0x10/0x16
check_preemption_disabled+0xdd/0xe0
debug_smp_processor_id+0x17/0x20
powerclamp_set_cur_state+0x7f/0xf9 [intel_powerclamp]
...
...

Here CPU 0 is the control CPU by default and changed to the current CPU,
if CPU 0 offlined. This check has to be performed under cpus_read_lock(),
hence the above warning.

Use get_cpu() instead of smp_processor_id() to avoid this BUG.

Suggested-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
[ rjw: Subject edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_powerclamp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index 53216dcbe173..5e4f32733caf 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -535,8 +535,10 @@ static int start_power_clamp(void)
 
 	/* prefer BSP */
 	control_cpu = 0;
-	if (!cpu_online(control_cpu))
-		control_cpu = smp_processor_id();
+	if (!cpu_online(control_cpu)) {
+		control_cpu = get_cpu();
+		put_cpu();
+	}
 
 	clamping = true;
 	schedule_delayed_work(&poll_pkg_cstate_work, 0);
-- 
2.35.1



