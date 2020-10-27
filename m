Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2351D29C061
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783594AbgJ0O63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783588AbgJ0O63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A4D20715;
        Tue, 27 Oct 2020 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810708;
        bh=n933nPjPhTwaAxa76XZlpZtEQm3PzxBaAMGkeZ3inPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FonqJtqBliuiF1ih7aX7y27SFTZDoxwMVUVwNbIJoU2CPSTqXjHlTVwdjiwd/1xd5
         4hePBT3B4jT37mHUO0wA1G/Wr9xBC/O9r8jSqny9mBeRp4OhZdR73PYIwMxagX06iU
         14vDINxkdIVGugFpnbMscy3gVJZdV9vm7aKeLqzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 235/633] coresight: etm4x: Handle unreachable sink in perf mode
Date:   Tue, 27 Oct 2020 14:49:38 +0100
Message-Id: <20201027135533.708145459@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 859d510e58dac94f0b204b7b5cccafbc130d2291 ]

If the specified/hinted sink is not reachable from a subset of the CPUs,
we could end up unable to trace the event on those CPUs. This
is the best effort we could do until we support 1:1 configurations.
Fail gracefully in such cases avoiding a WARN_ON, which can be easily
triggered by the user on certain platforms (Arm N1SDP), with the following
trace paths :

 CPU0
      \
       -- Funnel0 --> ETF0 -->
      /                        \
 CPU1                           \
                                  MainFunnel
 CPU2                           /
      \                        /
       -- Funnel1 --> ETF1 -->
      /
 CPU1

$ perf record --per-thread -e cs_etm/@ETF0/u -- <app>

could trigger the following WARNING, when the event is scheduled
on CPU2.

[10919.513250] ------------[ cut here ]------------
[10919.517861] WARNING: CPU: 2 PID: 24021 at
drivers/hwtracing/coresight/coresight-etm-perf.c:316 etm_event_start+0xf8/0x100
...

[10919.564403] CPU: 2 PID: 24021 Comm: perf Not tainted 5.8.0+ #24
[10919.570308] pstate: 80400089 (Nzcv daIf +PAN -UAO BTYPE=--)
[10919.575865] pc : etm_event_start+0xf8/0x100
[10919.580034] lr : etm_event_start+0x80/0x100
[10919.584202] sp : fffffe001932f940
[10919.587502] x29: fffffe001932f940 x28: fffffc834995f800
[10919.592799] x27: 0000000000000000 x26: fffffe0011f3ced0
[10919.598095] x25: fffffc837fce244c x24: fffffc837fce2448
[10919.603391] x23: 0000000000000002 x22: fffffc8353529c00
[10919.608688] x21: fffffc835bb31000 x20: 0000000000000000
[10919.613984] x19: fffffc837fcdcc70 x18: 0000000000000000
[10919.619281] x17: 0000000000000000 x16: 0000000000000000
[10919.624577] x15: 0000000000000000 x14: 00000000000009f8
[10919.629874] x13: 00000000000009f8 x12: 0000000000000018
[10919.635170] x11: 0000000000000000 x10: 0000000000000000
[10919.640467] x9 : fffffe00108cd168 x8 : 0000000000000000
[10919.645763] x7 : 0000000000000020 x6 : 0000000000000001
[10919.651059] x5 : 0000000000000002 x4 : 0000000000000001
[10919.656356] x3 : 0000000000000000 x2 : 0000000000000000
[10919.661652] x1 : fffffe836eb40000 x0 : 0000000000000000
[10919.666949] Call trace:
[10919.669382]  etm_event_start+0xf8/0x100
[10919.673203]  etm_event_add+0x40/0x60
[10919.676765]  event_sched_in.isra.134+0xcc/0x210
[10919.681281]  merge_sched_in+0xb0/0x2a8
[10919.685017]  visit_groups_merge.constprop.140+0x15c/0x4b8
[10919.690400]  ctx_sched_in+0x15c/0x170
[10919.694048]  perf_event_sched_in+0x6c/0xa0
[10919.698130]  ctx_resched+0x60/0xa0
[10919.701517]  perf_event_exec+0x288/0x2f0
[10919.705425]  begin_new_exec+0x4c8/0xf58
[10919.709247]  load_elf_binary+0x66c/0xf30
[10919.713155]  exec_binprm+0x15c/0x450
[10919.716716]  __do_execve_file+0x508/0x748
[10919.720711]  __arm64_sys_execve+0x40/0x50
[10919.724707]  do_el0_svc+0xf4/0x1b8
[10919.728095]  el0_sync_handler+0xf8/0x124
[10919.732003]  el0_sync+0x140/0x180

Even though we don't support using separate sinks for the ETMs yet (e.g,
for 1:1 configurations), we should at least honor the user's choice and
handle the limitations gracefully, by simply skipping the tracing on ETMs
which can't reach the requested sink.

Fixes: f9d81a657bb8 ("coresight: perf: Allow tracing on hotplugged CPUs")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Reported-by: Jeremy Linton <jeremy.linton@arm.com>
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-11-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index 84f1dcb698272..c4b9898e28418 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -310,6 +310,16 @@ static void etm_event_start(struct perf_event *event, int flags)
 	if (!event_data)
 		goto fail;
 
+	/*
+	 * Check if this ETM is allowed to trace, as decided
+	 * at etm_setup_aux(). This could be due to an unreachable
+	 * sink from this ETM. We can't do much in this case if
+	 * the sink was specified or hinted to the driver. For
+	 * now, simply don't record anything on this ETM.
+	 */
+	if (!cpumask_test_cpu(cpu, &event_data->mask))
+		goto fail_end_stop;
+
 	path = etm_event_cpu_path(event_data, cpu);
 	/* We need a sink, no need to continue without one */
 	sink = coresight_get_sink(path);
-- 
2.25.1



