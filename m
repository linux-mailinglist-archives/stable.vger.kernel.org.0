Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB72046AF
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 03:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731747AbgFWBYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 21:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731690AbgFWBYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 21:24:25 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BB5C061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 18:24:24 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j12so7073702pfn.10
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 18:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=l4NYx667LG9q9NFGHrK23fyoECCOJjNd1dq7cs066Xg=;
        b=lpSJRyVpMEsSOlvl7kLzvql8UnqNahJULDPUbsSP9RGfZaLp48G3K1rApZj570TLQh
         J9l3L3GPMNLQMHApW9po/sCNvQu26odVE7IO0mib9L0YnQPfJXtdmGg2zZV8x+Zm9jOf
         KDvmFz603RZlvsXdmKd9WxJjGjx0sE0B/74Wq3uniXhl872k7M/OMWbVK7/zyk+K/EeN
         AWt+BcjhD5asn9AItFyDrvFn5gaLgKy4KbxdDY0Uf3HtUBfNgEV7npiE5TETWWWWYy69
         EdZy+sju6ZHoeyRQk9Kclcu5EbF6SqptmiMvr8RV5T404erEUtPJfNa9hA6AaYqh3VZT
         W7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l4NYx667LG9q9NFGHrK23fyoECCOJjNd1dq7cs066Xg=;
        b=heNcoduH3/6GZzLwr4mEJ1VmGHtZJRzNH3qCJPEMM+ns4nDYJ8tgqibD6kFVY7ZDSE
         /pviebueawX5W0hhepVRck2o/NpQyDDEWJyPPTbTDTKWdN8hKmAgHpzsXPBk/YWEfNY+
         0WetAOmm4bbSK7YS19dpMN1yPQCr3aIwubOBA2oao7MtZNWuKm6P6PmkH55yFuhuPKRu
         YgN3iW+hs7apY7h4YIjzOWh78r9ouC2lIpis9EDnoCerVBZGcquBLaERDMJbrupExbm8
         0wOMJbTEHWu7Uy8X56Y+rw0EXf8zGqPC7XmtuGkv7VFkds0swH72rvHwBTaJvDwkgaQ9
         JJgA==
X-Gm-Message-State: AOAM530OFvWH+HdgYlMlwFpZMm/TJpdKzdUCKyEfe+496hnrFGNCBgi3
        xjp3qU/7xSgrBzdqWY6c1PPHog==
X-Google-Smtp-Source: ABdhPJzNNvEHle0i/TVzP9UjYgijBZ+zV1srWvoidpPMJMlcQw0Uv7YxUnPSWC3OfZ7GW2JuzhcV/Q==
X-Received: by 2002:a63:8949:: with SMTP id v70mr15020402pgd.256.1592875463979;
        Mon, 22 Jun 2020 18:24:23 -0700 (PDT)
Received: from VincentChen-ThinkPad-T480s.internal.sifive.com (114-34-229-221.HINET-IP.hinet.net. [114.34.229.221])
        by smtp.gmail.com with ESMTPSA id l61sm656741pjb.10.2020.06.22.18.24.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jun 2020 18:24:23 -0700 (PDT)
From:   Vincent Chen <vincent.chen@sifive.com>
To:     mturquette@baylibre.com, sboyd@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com
Cc:     linux-riscv@lists.infradead.org, schwab@suse.de,
        Vincent Chen <vincent.chen@sifive.com>, stable@vger.kernel.org
Subject: [PATCH] clk: sifive: allocate sufficient memory for struct __prci_data
Date:   Tue, 23 Jun 2020 09:24:17 +0800
Message-Id: <1592875458-5887-1-git-send-email-vincent.chen@sifive.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The (struct __prci_data).hw_clks.hws is an array with dynamic elements.
Using struct_size(pd, hw_clks.hws, ARRAY_SIZE(__prci_init_clocks))
instead of sizeof(*pd) to get the correct memory size of
struct __prci_data for sifive/fu540-prci. After applying this
modifications, the kernel runs smoothly with CONFIG_SLAB_FREELIST_RANDOM
enabled on the HiFive unleashed board.

Fixes: 30b8e27e3b58 ("clk: sifive: add a driver for the SiFive FU540 PRCI IP block")
Cc: stable@vger.kernel.org
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
---
 drivers/clk/sifive/fu540-prci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/sifive/fu540-prci.c b/drivers/clk/sifive/fu540-prci.c
index 6282ee2f361c..a8901f90a61a 100644
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
2.7.4

