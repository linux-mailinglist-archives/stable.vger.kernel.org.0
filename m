Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 131A92F598
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbfE3EsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:48:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbfE3DLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:19 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 399DC244F6;
        Thu, 30 May 2019 03:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185879;
        bh=cYj6tGVRkcCfyzn1WMPn2V4eRoSHbAJSj6gDIu0hjcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXryasG9jmEbIr57rklm7Dz4+QfWHc6jcpGTYGMHvkm4S0RqifBctgwcsMrNuce2K
         GzVqdch0laLLb7bvuuO29Kp9ScQhHu40Xy6BOvb5xSE/U9DHq517tdlo6x4pp3sDQG
         j68tkaGFCo1dTHvoL86iBST87NGs1hF3W0xfnV2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-pm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 227/405] cpufreq: pmac32: fix possible object reference leak
Date:   Wed, 29 May 2019 20:03:45 -0700
Message-Id: <20190530030552.526559633@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8d10dc28a9ea6e8c02e825dab28699f3c72b02d9 ]

The call to of_find_node_by_name returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/cpufreq/pmac32-cpufreq.c:557:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 552, but without a corresponding object release within this function.
./drivers/cpufreq/pmac32-cpufreq.c:569:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 552, but without a corresponding object release within this function.
./drivers/cpufreq/pmac32-cpufreq.c:598:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 587, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-pm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/pmac32-cpufreq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 52f0d91d30c17..9b4ce2eb8222c 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -552,6 +552,7 @@ static int pmac_cpufreq_init_7447A(struct device_node *cpunode)
 	volt_gpio_np = of_find_node_by_name(NULL, "cpu-vcore-select");
 	if (volt_gpio_np)
 		voltage_gpio = read_gpio(volt_gpio_np);
+	of_node_put(volt_gpio_np);
 	if (!voltage_gpio){
 		pr_err("missing cpu-vcore-select gpio\n");
 		return 1;
@@ -588,6 +589,7 @@ static int pmac_cpufreq_init_750FX(struct device_node *cpunode)
 	if (volt_gpio_np)
 		voltage_gpio = read_gpio(volt_gpio_np);
 
+	of_node_put(volt_gpio_np);
 	pvr = mfspr(SPRN_PVR);
 	has_cpu_l2lve = !((pvr & 0xf00) == 0x100);
 
-- 
2.20.1



