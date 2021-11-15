Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75342451F66
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356004AbhKPAit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344016AbhKOTXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE0DF633B8;
        Mon, 15 Nov 2021 18:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002228;
        bh=LD7BgWih6TJdGkfJZXeOJ/rgl4qG71Ywl9JCm3FdYgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSLNUvYam4UDXY0q6Pe1CPg6Lwv5X2qOWzovf8lYm0I8Zq9dajk1CzFfalhJmQVeu
         VGZVt3kyvpg4J4hOiFqr9lHzZJ7cA+mg7B8dITeKKDDH77wdtqNR1TR1/behddK4aF
         PMc+7y+yr8m9DSwJ6zCBgNpEZExHMFS0L0wkLUOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Shao <fshao@chromium.org>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 453/917] mailbox: mtk-cmdq: Fix local clock ID usage
Date:   Mon, 15 Nov 2021 17:59:08 +0100
Message-Id: <20211115165444.143164817@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fei Shao <fshao@chromium.org>

[ Upstream commit 0a5ad4322927ee4aaba6facc0e4faf1ab6c0d48e ]

In the probe function, the clock IDs were pointed to local variables
which should only be used in the same code block, and any access to them
after the probing stage becomes an use-after-free case.

Since there are only limited variants of the gce clock names so far, we
can just declare them as static constants to fix the issue.

Fixes: 85dfdbfc13ea ("mailbox: cmdq: add multi-gce clocks support for mt8195")
Signed-off-by: Fei Shao <fshao@chromium.org>
Reviewed-by: Tzung-Bi Shih <tzungbi@google.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 9b0cc3bb5b23a..bb4793c7b38fd 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -531,7 +531,8 @@ static int cmdq_probe(struct platform_device *pdev)
 	struct device_node *phandle = dev->of_node;
 	struct device_node *node;
 	int alias_id = 0;
-	char clk_name[4] = "gce";
+	static const char * const clk_name = "gce";
+	static const char * const clk_names[] = { "gce0", "gce1" };
 
 	cmdq = devm_kzalloc(dev, sizeof(*cmdq), GFP_KERNEL);
 	if (!cmdq)
@@ -569,12 +570,9 @@ static int cmdq_probe(struct platform_device *pdev)
 
 	if (cmdq->gce_num > 1) {
 		for_each_child_of_node(phandle->parent, node) {
-			char clk_id[8];
-
 			alias_id = of_alias_get_id(node, clk_name);
 			if (alias_id >= 0 && alias_id < cmdq->gce_num) {
-				snprintf(clk_id, sizeof(clk_id), "%s%d", clk_name, alias_id);
-				cmdq->clocks[alias_id].id = clk_id;
+				cmdq->clocks[alias_id].id = clk_names[alias_id];
 				cmdq->clocks[alias_id].clk = of_clk_get(node, 0);
 				if (IS_ERR(cmdq->clocks[alias_id].clk)) {
 					dev_err(dev, "failed to get gce clk: %d\n", alias_id);
-- 
2.33.0



