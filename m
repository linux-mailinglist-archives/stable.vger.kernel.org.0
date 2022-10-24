Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D8260AC9A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiJXOKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbiJXOIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:08:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACFD3B98E;
        Mon, 24 Oct 2022 05:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6326E612F3;
        Mon, 24 Oct 2022 12:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A929C43470;
        Mon, 24 Oct 2022 12:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615853;
        bh=do1I8NQWeaTX8+T+0jwrZEdD9Gg7WWzIym3aPHt6SJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3KeCQhSRN6LPq2k5qtg9r5bsdSInkBvhcvAQQOdFlVDPDNls1T5zdyVMSHrzn76K
         70Vc7/E0yIuY/yHBfs03zOybyB174mPseWPVfjK9niMxd99cRaOlaYoPmjvcn6OSwN
         hSDdX6r/kTjYqJf8XrDSgkRHBPtQ1Mx1LVP3txS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 409/530] thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash
Date:   Mon, 24 Oct 2022 13:32:33 +0200
Message-Id: <20221024113103.591956572@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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
index a5b58ea89cc6..9121ae4f5068 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -532,8 +532,10 @@ static int start_power_clamp(void)
 
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



