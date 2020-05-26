Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5DAF1A5A44
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgDKXGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727602AbgDKXGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D17F217D8;
        Sat, 11 Apr 2020 23:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646404;
        bh=/GonmYKtW5Cf9hF+Kz8M2dBkwVtojYdg7j4tQNIOrPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oG3GcSW1kOouDZDsoGhIJdxj6God/q4pH6rqvFxY6TphqZwJt9Ly6nQLeRRpgBdiS
         I9F6Fqv/MjUMPmMGV9ng0A0tF/dn+Sh50NVbx+qAQI232cmdDL9sQXQRTK2vFAI/l5
         r8091uYLd+jQFm3W35G9/Xk5blha4hSpLJxGf4ts=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 140/149] drivers: qcom: rpmh-rsc: Use rcuidle tracepoints for rpmh
Date:   Sat, 11 Apr 2020 19:03:37 -0400
Message-Id: <20200411230347.22371-140-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit efde2659b0fe835732047357b2902cca14f054d9 ]

This tracepoint is hit now that we call into the rpmh code from the cpu
idle path. Let's move this to be an rcuidle tracepoint so that we avoid
the RCU idle splat below

 =============================
 WARNING: suspicious RCU usage
 5.4.10 #68 Tainted: G S
 -----------------------------
 drivers/soc/qcom/trace-rpmh.h:72 suspicious rcu_dereference_check() usage!

 other info that might help us debug this:

 RCU used illegally from idle CPU!
 rcu_scheduler_active = 2, debug_locks = 1
 RCU used illegally from extended quiescent state!
 5 locks held by swapper/2/0:
  #0: ffffff81745d6ee8 (&(&genpd->slock)->rlock){+.+.}, at: genpd_lock_spin+0x1c/0x2c
  #1: ffffff81745da6e8 (&(&genpd->slock)->rlock/1){....}, at: genpd_lock_nested_spin+0x24/0x34
  #2: ffffff8174f2ca20 (&(&genpd->slock)->rlock/2){....}, at: genpd_lock_nested_spin+0x24/0x34
  #3: ffffff8174f2c300 (&(&drv->client.cache_lock)->rlock){....}, at: rpmh_flush+0x48/0x24c
  #4: ffffff8174f2c150 (&(&tcs->lock)->rlock){+.+.}, at: rpmh_rsc_write_ctrl_data+0x74/0x270

 stack backtrace:
 CPU: 2 PID: 0 Comm: swapper/2 Tainted: G S                5.4.10 #68
 Call trace:
  dump_backtrace+0x0/0x174
  show_stack+0x20/0x2c
  dump_stack+0xc8/0x124
  lockdep_rcu_suspicious+0xe4/0x104
  __tcs_buffer_write+0x230/0x2d0
  rpmh_rsc_write_ctrl_data+0x210/0x270
  rpmh_flush+0x84/0x24c
  rpmh_domain_power_off+0x78/0x98
  _genpd_power_off+0x40/0xc0
  genpd_power_off+0x168/0x208
  genpd_power_off+0x1e0/0x208
  genpd_power_off+0x1e0/0x208
  genpd_runtime_suspend+0x1ac/0x220
  __rpm_callback+0x70/0xfc
  rpm_callback+0x34/0x8c
  rpm_suspend+0x218/0x4a4
  __pm_runtime_suspend+0x88/0xac
  psci_enter_domain_idle_state+0x3c/0xb4
  cpuidle_enter_state+0xb8/0x284
  cpuidle_enter+0x38/0x4c
  call_cpuidle+0x3c/0x68
  do_idle+0x194/0x260
  cpu_startup_entry+0x24/0x28
  secondary_start_kernel+0x150/0x15c

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Fixes: a65a397f2451 ("cpuidle: psci: Add support for PM domains by using genpd")
Reported-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20200115013751.249588-1-swboyd@chromium.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index e278fc11fe5cf..b71822131f598 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -277,7 +277,7 @@ static void __tcs_buffer_write(struct rsc_drv *drv, int tcs_id, int cmd_id,
 		write_tcs_cmd(drv, RSC_DRV_CMD_MSGID, tcs_id, j, msgid);
 		write_tcs_cmd(drv, RSC_DRV_CMD_ADDR, tcs_id, j, cmd->addr);
 		write_tcs_cmd(drv, RSC_DRV_CMD_DATA, tcs_id, j, cmd->data);
-		trace_rpmh_send_msg(drv, tcs_id, j, msgid, cmd);
+		trace_rpmh_send_msg_rcuidle(drv, tcs_id, j, msgid, cmd);
 	}
 
 	write_tcs_reg(drv, RSC_DRV_CMD_WAIT_FOR_CMPL, tcs_id, cmd_complete);
-- 
2.20.1

