Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF40FEF8E
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731318AbfKPPxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731302AbfKPPxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:49 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48B89218DE;
        Sat, 16 Nov 2019 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919628;
        bh=cPliugyUoPKqEYajZaa+5EhjP4iV/yZw1O40DFpuI2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nv4Fktz6Hp7I95e2seudfh1iupz46ADQWmdL1vTLK26l8o1hVyhzUEV1o0l4Ms4jZ
         HLGmEFvHB7nM/aXMZXgKEH6FtOlO9nPc2Ct8kwn2ILedetWJyLllZBWMdl3J6KpIee
         ho4R9Aomw4q3y4xd/nabocurSSKvVVihwqsgeipY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaotian Jing <chaotian.jing@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/77] mmc: mediatek: fix cannot receive new request when msdc_cmd_is_ready fail
Date:   Sat, 16 Nov 2019 10:52:31 -0500
Message-Id: <20191116155339.11909-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
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
index 0bf0d0e9dbdba..5ef25463494f4 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -846,6 +846,7 @@ static void msdc_start_command(struct msdc_host *host,
 	WARN_ON(host->cmd);
 	host->cmd = cmd;
 
+	mod_delayed_work(system_wq, &host->req_timeout, DAT_TIMEOUT);
 	if (!msdc_cmd_is_ready(host, mrq, cmd))
 		return;
 
@@ -857,7 +858,6 @@ static void msdc_start_command(struct msdc_host *host,
 
 	cmd->error = 0;
 	rawcmd = msdc_cmd_prepare_raw_cmd(host, mrq, cmd);
-	mod_delayed_work(system_wq, &host->req_timeout, DAT_TIMEOUT);
 
 	sdr_set_bits(host->base + MSDC_INTEN, cmd_ints_mask);
 	writel(cmd->arg, host->base + SDC_ARG);
-- 
2.20.1

