Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49134FF3B0
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfKPPlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbfKPPli (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:38 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDDF42081E;
        Sat, 16 Nov 2019 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918898;
        bh=0dbdYLGTq2BVs9/jCLHYxBB0RMEi4AQzMdhJs3x8hd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4wSMHd7dNVqCjNotxgLaH6TGYqb3MuTDTud179jHbTw1/JAwyJ7UIP+9Lqlk1Zq0
         dL1H64nxjcD0w7rpDSWLheq/0jZegrAqPJjDBYdsc96uEug5yLuNJ2+BEDfG7EH6oG
         G4zsMJmIOfdsLnpBKVSWQfKCX0wfmRzgjevQUDUA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaotian Jing <chaotian.jing@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 025/237] mmc: mediatek: fix cannot receive new request when msdc_cmd_is_ready fail
Date:   Sat, 16 Nov 2019 10:37:40 -0500
Message-Id: <20191116154113.7417-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaotian Jing <chaotian.jing@mediatek.com>

[ Upstream commit f38a9774ddde9d79b3487dd888edd8b8623552af ]

when msdc_cmd_is_ready return fail, the req_timeout work has not been
inited and cancel_delayed_work() will return false, then, the request
return directly and never call mmc_request_done().

so need call mod_delayed_work() before msdc_cmd_is_ready()

Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 621c914dc5c01..673f6a9616cd9 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1056,6 +1056,7 @@ static void msdc_start_command(struct msdc_host *host,
 	WARN_ON(host->cmd);
 	host->cmd = cmd;
 
+	mod_delayed_work(system_wq, &host->req_timeout, DAT_TIMEOUT);
 	if (!msdc_cmd_is_ready(host, mrq, cmd))
 		return;
 
@@ -1067,7 +1068,6 @@ static void msdc_start_command(struct msdc_host *host,
 
 	cmd->error = 0;
 	rawcmd = msdc_cmd_prepare_raw_cmd(host, mrq, cmd);
-	mod_delayed_work(system_wq, &host->req_timeout, DAT_TIMEOUT);
 
 	sdr_set_bits(host->base + MSDC_INTEN, cmd_ints_mask);
 	writel(cmd->arg, host->base + SDC_ARG);
-- 
2.20.1

