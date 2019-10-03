Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38565CA882
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387629AbfJCQ1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391309AbfJCQ1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:27:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D013020867;
        Thu,  3 Oct 2019 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120063;
        bh=Lc59sncasa5gS38TB/SVhDDqzccv+JjvHgvKuSv4u+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=04NpvnNB1i8pbn4hgWtQAtV7GwfJlrDqudOPg+3z3SuZQCoTUkEUassKbtYZzyDrj
         pnz++lVO9T/U5cdHS7Q5bO7ra2+j6xKzMKkN0Y8TCCntzowStYUT6/vGHFz1tdrVci
         otdE6i/h0Zm8RJ32KzRRuUV5+lpQXacublmlNSSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 035/313] cpufreq: ap806: Add NULL check after kcalloc
Date:   Thu,  3 Oct 2019 17:50:13 +0200
Message-Id: <20191003154536.721814144@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



