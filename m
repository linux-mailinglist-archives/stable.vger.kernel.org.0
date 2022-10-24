Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA4260B779
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiJXTYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiJXTWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:22:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6A8C4DA1;
        Mon, 24 Oct 2022 10:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 535D7CE134D;
        Mon, 24 Oct 2022 11:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67333C433D6;
        Mon, 24 Oct 2022 11:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612352;
        bh=QsAUGu98aFCufOBe4iBWZ+qBocl7d9WXykBVUjlzfZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvlB8XkOxmPArORef54xfQrXmn/wGt4pRGP9jYk4SckPA2m8Bquv02bIXXDtNc4Py
         ddNP+DMwy4BVCzV9wD2sE2VDXxwX7QnKX8Chihi0H38PwO2dyHPc1Np5PdeMcihapP
         rzj/ix0nJVYQpGhcACL3RLu7dc2OmmS50lUd+2S0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 164/210] thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash
Date:   Mon, 24 Oct 2022 13:31:21 +0200
Message-Id: <20221024113002.289703206@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
 drivers/thermal/intel_powerclamp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index c3293fa2bb1b..7ff59f86a543 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -550,8 +550,10 @@ static int start_power_clamp(void)
 
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



