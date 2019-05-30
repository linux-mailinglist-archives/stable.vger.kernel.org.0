Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0412F27F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbfE3EWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730100AbfE3DPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:05 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7337024595;
        Thu, 30 May 2019 03:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186104;
        bh=KFjWdcM0j1PIjGo1SD5vVsinYegNqV/OwabGD7l4Pfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pq5rW2Cxe4u1bomJp/fvhgQbmHXyVVlHJQoFi3v2yq97ugK/RH7zSNz5Fjq5U2aXC
         +/CsUkV3sIdFaMZECOHvWfo/4UUs8QMF9/nCBzevz9w0Rpie9BngF+r/1UBQHF7zBH
         WUEM/I0ZPcLNB/36vA8EPonitOHaipfdhKpKhqPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 209/346] cpufreq: kirkwood: fix possible object reference leak
Date:   Wed, 29 May 2019 20:04:42 -0700
Message-Id: <20190530030551.716687141@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7c468966f05ac9c17bb5948275283d34e6fe0660 ]

The call to of_get_child_by_name returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/cpufreq/kirkwood-cpufreq.c:127:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 118, but without a corresponding object release within this function.
./drivers/cpufreq/kirkwood-cpufreq.c:133:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 118, but without a corresponding object release within this function.

and also do some cleanup:
- of_node_put(np);
- np = NULL;
...
of_node_put(np);

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/kirkwood-cpufreq.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index c2dd43f3f5d8a..8d63a6dc8383c 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -124,13 +124,14 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
 	priv.cpu_clk = of_clk_get_by_name(np, "cpu_clk");
 	if (IS_ERR(priv.cpu_clk)) {
 		dev_err(priv.dev, "Unable to get cpuclk\n");
-		return PTR_ERR(priv.cpu_clk);
+		err = PTR_ERR(priv.cpu_clk);
+		goto out_node;
 	}
 
 	err = clk_prepare_enable(priv.cpu_clk);
 	if (err) {
 		dev_err(priv.dev, "Unable to prepare cpuclk\n");
-		return err;
+		goto out_node;
 	}
 
 	kirkwood_freq_table[0].frequency = clk_get_rate(priv.cpu_clk) / 1000;
@@ -161,20 +162,22 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
 		goto out_ddr;
 	}
 
-	of_node_put(np);
-	np = NULL;
-
 	err = cpufreq_register_driver(&kirkwood_cpufreq_driver);
-	if (!err)
-		return 0;
+	if (err) {
+		dev_err(priv.dev, "Failed to register cpufreq driver\n");
+		goto out_powersave;
+	}
 
-	dev_err(priv.dev, "Failed to register cpufreq driver\n");
+	of_node_put(np);
+	return 0;
 
+out_powersave:
 	clk_disable_unprepare(priv.powersave_clk);
 out_ddr:
 	clk_disable_unprepare(priv.ddr_clk);
 out_cpu:
 	clk_disable_unprepare(priv.cpu_clk);
+out_node:
 	of_node_put(np);
 
 	return err;
-- 
2.20.1



