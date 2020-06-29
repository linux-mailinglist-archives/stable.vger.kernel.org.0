Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9159320DA17
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbgF2Txm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387681AbgF2Tk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F471248DB;
        Mon, 29 Jun 2020 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444433;
        bh=whz2AYzxqIosz40Rk8FfNtqCsv/X1JKsrbmEzCmFp8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yghRabmA3VVz0GK32FCfsR0jyKnOIl/oRNlH7ApGONDWQHhyIsFLY3+g8CwFnuR9J
         A8tAfXQpSziRiGYWtoKuqezhkL77pmXdt6ka5P6jsfSZURxaLkvoy9DFo2Lq2+YII/
         BD7Za+V2CFC6iLngpK/8pCT1vPx1zJxynXvRMGfI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Chen <vincent.chen@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/178] clk: sifive: allocate sufficient memory for struct __prci_data
Date:   Mon, 29 Jun 2020 11:24:16 -0400
Message-Id: <20200629152523.2494198-112-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

[ Upstream commit d0a5fdf4cc83dabcdea668f971b8a2e916437711 ]

The (struct __prci_data).hw_clks.hws is an array with dynamic elements.
Using struct_size(pd, hw_clks.hws, ARRAY_SIZE(__prci_init_clocks))
instead of sizeof(*pd) to get the correct memory size of
struct __prci_data for sifive/fu540-prci. After applying this
modifications, the kernel runs smoothly with CONFIG_SLAB_FREELIST_RANDOM
enabled on the HiFive unleashed board.

Fixes: 30b8e27e3b58 ("clk: sifive: add a driver for the SiFive FU540 PRCI IP block")
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sifive/fu540-prci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/sifive/fu540-prci.c b/drivers/clk/sifive/fu540-prci.c
index 6282ee2f361cd..a8901f90a61ac 100644
--- a/drivers/clk/sifive/fu540-prci.c
+++ b/drivers/clk/sifive/fu540-prci.c
@@ -586,7 +586,10 @@ static int sifive_fu540_prci_probe(struct platform_device *pdev)
 	struct __prci_data *pd;
 	int r;
 
-	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	pd = devm_kzalloc(dev,
+			  struct_size(pd, hw_clks.hws,
+				      ARRAY_SIZE(__prci_init_clocks)),
+			  GFP_KERNEL);
 	if (!pd)
 		return -ENOMEM;
 
-- 
2.25.1

