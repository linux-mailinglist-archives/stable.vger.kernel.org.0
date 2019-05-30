Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3012EF23
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbfE3Dw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731932AbfE3DTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:33 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3C6E24820;
        Thu, 30 May 2019 03:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186372;
        bh=/9gO1owKbVSEM1J1l/p0XqI3NOncT/RkO+xEAx1EsGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jw+mLu1NQMYQ8LmX/NMQYBjb4hathAmsul7rNDgO2YzDUAmiB89fqjmsdsv1TItc4
         YPzN/Hg+I3FQQqvTBgHqhziKYd9pcUGdq4Q971DdU6yDmTzqtL2uEvK1+TQyufTWiC
         B/lK6kCK4h4MNmiWC4gAJqaabUhfvYN8emZ9hkeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 130/193] cpufreq: ppc_cbe: fix possible object reference leak
Date:   Wed, 29 May 2019 20:06:24 -0700
Message-Id: <20190530030506.541854823@linuxfoundation.org>
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

[ Upstream commit 233298032803f2802fe99892d0de4ab653bfece4 ]

The call to of_get_cpu_node returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/cpufreq/ppc_cbe_cpufreq.c:89:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 76, but without a corresponding object release within this function.
./drivers/cpufreq/ppc_cbe_cpufreq.c:89:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 76, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/ppc_cbe_cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 5a4c5a639f618..2eaeebcc93afe 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -86,6 +86,7 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (!cbe_get_cpu_pmd_regs(policy->cpu) ||
 	    !cbe_get_cpu_mic_tm_regs(policy->cpu)) {
 		pr_info("invalid CBE regs pointers for cpufreq\n");
+		of_node_put(cpu);
 		return -EINVAL;
 	}
 
-- 
2.20.1



