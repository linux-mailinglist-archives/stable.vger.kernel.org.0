Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D59BA2F273
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbfE3EWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730137AbfE3DPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:09 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BDED2458C;
        Thu, 30 May 2019 03:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186109;
        bh=VJJ2PuPVWHqol+6SIVNX2fP7TlmgBiJL/thsn/56aRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqc5PB8KIwfbhqNqd9dVqIOjJP4WN+11NZ3g1vJyXahzz2NEiIb/oDcjcatSk6w40
         DAmHAi01VbGcsMR/QG9iIfrSGUd08tOB8QJ/hzZqG2MdbhKIDqVpT57igcmPVEm3rq
         HLrUXgwYYm4hAuKJcMNqLXMPr8V2apUYzg5Dzua0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 210/346] cpufreq: imx6q: fix possible object reference leak
Date:   Wed, 29 May 2019 20:04:43 -0700
Message-Id: <20190530030551.765653896@linuxfoundation.org>
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

[ Upstream commit ddb64c5db3cc8fb9c1242214d5798b2c2865681c ]

The call to of_node_get returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/cpufreq/imx6q-cpufreq.c:391:4-10: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 348, but without a corresponding object release within this function.
./drivers/cpufreq/imx6q-cpufreq.c:395:3-9: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 348, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 9fedf627e000d..3ee55aee5d71a 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -407,11 +407,11 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 		ret = imx6ul_opp_check_speed_grading(cpu_dev);
 		if (ret) {
 			if (ret == -EPROBE_DEFER)
-				return ret;
+				goto put_node;
 
 			dev_err(cpu_dev, "failed to read ocotp: %d\n",
 				ret);
-			return ret;
+			goto put_node;
 		}
 	} else {
 		imx6q_opp_check_speed_grading(cpu_dev);
-- 
2.20.1



