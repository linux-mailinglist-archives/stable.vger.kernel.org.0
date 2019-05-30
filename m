Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADEE62EF24
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfE3Dw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730912AbfE3DTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:33 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CC2F2489F;
        Thu, 30 May 2019 03:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186373;
        bh=WeE25g83ma4VNVN8TPBWVGA/qrGdFQKGMw85tuQEoYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/tNuhO/YBbYtJimVfXt0n5xMF3ZDqXSlPjBmgXk9BtWbAK8z5uCuT0JUDU14Fts0
         PwcK9NxY7/h1Llhk6+86Xco678GSc+7YbRIZPoNSXJdWvevinvERc0JZ8d2R+AUvka
         9r5LZsHFZ28qBNZGRf+O6GVwyFp7UThi6STeVbrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linuxppc-dev@lists.ozlabs.org, linux-pm@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 131/193] cpufreq/pasemi: fix possible object reference leak
Date:   Wed, 29 May 2019 20:06:25 -0700
Message-Id: <20190530030506.693074332@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a9acc26b75f652f697e02a9febe2ab0da648a571 ]

The call to of_get_cpu_node returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/cpufreq/pasemi-cpufreq.c:212:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 147, but without a corresponding object release within this function.
./drivers/cpufreq/pasemi-cpufreq.c:220:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 147, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/pasemi-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index b257fc7d52041..8456492124f0c 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -146,6 +146,7 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	cpu = of_get_cpu_node(policy->cpu, NULL);
 
+	of_node_put(cpu);
 	if (!cpu)
 		goto out;
 
-- 
2.20.1



