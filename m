Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A30BAAB4
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfIVT35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392388AbfIVStb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D819214AF;
        Sun, 22 Sep 2019 18:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178170;
        bh=Lc59sncasa5gS38TB/SVhDDqzccv+JjvHgvKuSv4u+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qo4fwiyiu17kLbHE9lki31yqnyZbimYhLjpx9eQg4wTaWuUS10CmHdOl3vyGdDkck
         9DxdZrCitJzqd7iDd9S/qx1bt+bHSExhqK/Um4wIVp31Uas7b0eaFdXG6IlZNosIXm
         8e24vjIeU3AzZBAbDVVbC83HyC3Jt9sX00l3t6jE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 003/185] cpufreq: ap806: Add NULL check after kcalloc
Date:   Sun, 22 Sep 2019 14:46:21 -0400
Message-Id: <20190922184924.32534-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>

[ Upstream commit 3355c91b79394593ebbb197c8e930a91826f4ff3 ]

Add NULL check  after kcalloc.

Fix below issue reported by coccicheck
./drivers/cpufreq/armada-8k-cpufreq.c:138:1-12: alloc with no test,
possible model on line 151

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/armada-8k-cpufreq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/armada-8k-cpufreq.c b/drivers/cpufreq/armada-8k-cpufreq.c
index 988ebc326bdbb..39e34f5066d3d 100644
--- a/drivers/cpufreq/armada-8k-cpufreq.c
+++ b/drivers/cpufreq/armada-8k-cpufreq.c
@@ -136,6 +136,8 @@ static int __init armada_8k_cpufreq_init(void)
 
 	nb_cpus = num_possible_cpus();
 	freq_tables = kcalloc(nb_cpus, sizeof(*freq_tables), GFP_KERNEL);
+	if (!freq_tables)
+		return -ENOMEM;
 	cpumask_copy(&cpus, cpu_possible_mask);
 
 	/*
-- 
2.20.1

