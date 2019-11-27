Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0216F10BD8F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfK0V3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731118AbfK0U4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DED0F20862;
        Wed, 27 Nov 2019 20:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888214;
        bh=0dbdYLGTq2BVs9/jCLHYxBB0RMEi4AQzMdhJs3x8hd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQl3RcrFVPq6isdsi8Q+3MQjyYePnX4u41LQX3oda3LoV93LJdXOK9xX66LWTeF6w
         vat05VNhW06EdKHrrB6NXBi6NoaTHs7JOcQibPRIH+kcLdo3FY5l4JqMd/tCPiAUiw
         42lp9MX8qyTuFolIbePnmBQsfxeLegrWRabsYomo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chaotian Jing <chaotian.jing@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/306] mmc: mediatek: fix cannot receive new request when msdc_cmd_is_ready fail
Date:   Wed, 27 Nov 2019 21:28:16 +0100
Message-Id: <20191127203118.178576070@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



