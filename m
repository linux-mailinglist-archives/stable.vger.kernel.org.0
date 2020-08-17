Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559F1246BB3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388001AbgHQQBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731028AbgHQQAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:00:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61800207FF;
        Mon, 17 Aug 2020 16:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680037;
        bh=uYRquI/KJm2YxZ+8G3U/q6s0AMxXxdKG3v8RREjKJ8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEBy2mBoZl0Hi1NqgxWyjsEFBFh+fMhttVNP8QWU7UnUGv1hTKUKnk5zCE80Yzb0E
         iiVcM+Pvlw3Pmy20MMdltQmYcuGH42h94NUQsduEapwjz3dItauL9tM0ZbNMkHYYn3
         3jGbSY1Tqp120Wsotjc89w1/CqQ+41JwTj4wvMwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Tipton <mdtipton@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/270] clk: qcom: clk-rpmh: Wait for completion when enabling clocks
Date:   Mon, 17 Aug 2020 17:13:26 +0200
Message-Id: <20200817143756.079168781@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Tipton <mdtipton@codeaurora.org>

[ Upstream commit dad4e7fda4bdc1a6357db500a7bab8843c08e521 ]

The current implementation always uses rpmh_write_async, which doesn't
wait for completion. That's fine for disable requests since there's no
immediate need for the clocks and they can be disabled in the
background. However, for enable requests we need to ensure the clocks
are actually enabled before returning to the client. Otherwise, clients
can end up accessing their HW before the necessary clocks are enabled,
which can lead to bus errors.

Use the synchronous version of this API (rpmh_write) for enable requests
in the active set to ensure completion.

Completion isn't required for sleep/wake sets, since they don't take
effect until after we enter sleep. All rpmh requests are automatically
flushed prior to entering sleep.

Fixes: 9c7e47025a6b ("clk: qcom: clk-rpmh: Add QCOM RPMh clock driver")
Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
Link: https://lkml.kernel.org/r/20200215021232.1149-1-mdtipton@codeaurora.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
[sboyd@kernel.org: Reorg code a bit for readability, rename to 'wait' to
make local variable not conflict with completion.h mechanism]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rpmh.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
index 96a36f6ff667d..d7586e26acd8d 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -143,12 +143,22 @@ static inline bool has_state_changed(struct clk_rpmh *c, u32 state)
 		!= (c->aggr_state & BIT(state));
 }
 
+static int clk_rpmh_send(struct clk_rpmh *c, enum rpmh_state state,
+			 struct tcs_cmd *cmd, bool wait)
+{
+	if (wait)
+		return rpmh_write(c->dev, state, cmd, 1);
+
+	return rpmh_write_async(c->dev, state, cmd, 1);
+}
+
 static int clk_rpmh_send_aggregate_command(struct clk_rpmh *c)
 {
 	struct tcs_cmd cmd = { 0 };
 	u32 cmd_state, on_val;
 	enum rpmh_state state = RPMH_SLEEP_STATE;
 	int ret;
+	bool wait;
 
 	cmd.addr = c->res_addr;
 	cmd_state = c->aggr_state;
@@ -159,7 +169,8 @@ static int clk_rpmh_send_aggregate_command(struct clk_rpmh *c)
 			if (cmd_state & BIT(state))
 				cmd.data = on_val;
 
-			ret = rpmh_write_async(c->dev, state, &cmd, 1);
+			wait = cmd_state && state == RPMH_ACTIVE_ONLY_STATE;
+			ret = clk_rpmh_send(c, state, &cmd, wait);
 			if (ret) {
 				dev_err(c->dev, "set %s state of %s failed: (%d)\n",
 					!state ? "sleep" :
@@ -267,7 +278,7 @@ static int clk_rpmh_bcm_send_cmd(struct clk_rpmh *c, bool enable)
 	cmd.addr = c->res_addr;
 	cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);
 
-	ret = rpmh_write_async(c->dev, RPMH_ACTIVE_ONLY_STATE, &cmd, 1);
+	ret = clk_rpmh_send(c, RPMH_ACTIVE_ONLY_STATE, &cmd, enable);
 	if (ret) {
 		dev_err(c->dev, "set active state of %s failed: (%d)\n",
 			c->res_name, ret);
-- 
2.25.1



