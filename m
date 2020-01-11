Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F96C13808A
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbgAKKbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:31:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbgAKKbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:31:07 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B6CB20880;
        Sat, 11 Jan 2020 10:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738667;
        bh=iHG4J45p5lrv/0wCGpDECBEmG+GyhGGCV0bLDnMTYL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ysZ6KUsFgen3EPK7NxM9LDIO7Y4coN6OK+rzVNY7+GXCS+PIzAuVxKT1ueqmLk/vS
         3wLz9wa4SSV0xARQCGtMAatjzobOk/B1N7ffltIQwDoBJz8wrp31eHIAUNPa/0IyUO
         OfXnyiAWjYE9CAE4jpEHfH/6BDIIod+WooviQL6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/165] perf/smmuv3: Remove the leftover put_cpu() in error path
Date:   Sat, 11 Jan 2020 10:50:25 +0100
Message-Id: <20200111094930.982724766@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 8ae4bcf4821c18a8fbfa0b2c1df26c1085e9d923 ]

In smmu_pmu_probe(), there is put_cpu() in the error path,
which is wrong because we use raw_smp_processor_id() to
get the cpu ID, not get_cpu(), remove it.

While we are at it, kill 'out_cpuhp_err' altogether and
just return err if we fail to add the hotplug instance.

Acked-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_smmuv3_pmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
index abcf54f7d19c..191f410cf35c 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -815,7 +815,7 @@ static int smmu_pmu_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(dev, "Error %d registering hotplug, PMU @%pa\n",
 			err, &res_0->start);
-		goto out_cpuhp_err;
+		return err;
 	}
 
 	err = perf_pmu_register(&smmu_pmu->pmu, name, -1);
@@ -834,8 +834,6 @@ static int smmu_pmu_probe(struct platform_device *pdev)
 
 out_unregister:
 	cpuhp_state_remove_instance_nocalls(cpuhp_state_num, &smmu_pmu->node);
-out_cpuhp_err:
-	put_cpu();
 	return err;
 }
 
-- 
2.20.1



