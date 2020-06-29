Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C997420E86D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404826AbgF2WGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgF2SfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9533724742;
        Mon, 29 Jun 2020 15:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444062;
        bh=whz2AYzxqIosz40Rk8FfNtqCsv/X1JKsrbmEzCmFp8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzmPCf5XiGk65b/f2Le6y1T6qfjo3Zs0ZbkvKXjWMiverw98MexeZ0X+GJIvck6R9
         EDMiSC27ZWEBkYlL5Ub4rp7q2Jpm+5gyW/N0cmuL+cvTf+aRsyE8/6FBq1RUgHlvll
         Hfp5buf8yVfKVJpL9OOhRqMGH5JtifQq+Ixd2lJo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Chen <vincent.chen@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 170/265] clk: sifive: allocate sufficient memory for struct __prci_data
Date:   Mon, 29 Jun 2020 11:16:43 -0400
Message-Id: <20200629151818.2493727-171-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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

