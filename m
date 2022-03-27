Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871A94E8623
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbiC0F7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiC0F7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:59:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30666246;
        Sat, 26 Mar 2022 22:57:40 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gp15-20020a17090adf0f00b001c7cd11b0b3so6982763pjb.3;
        Sat, 26 Mar 2022 22:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=WsZxcVF6gelyqFkjIt1JdX7eFg0WjDR//rw4D2Z8gs8=;
        b=X9pbSvV37GL7ppqA/+UhWpyPUA1nuOuj0i7OpnQOjapUN4BAgu9E/nGV3QOsEaFxPq
         T5mjmUnu41uY9M2IZzx0/D3qHtwyl+eovZ3Xky6XojSfYHcJPiEZMnn20n6my8XVaphS
         yiTo7Q5GDQBLxq141NupWXLFyPQ0K578QZdEEB5ZtdLZWnAa/lgE04gYiwBS4Vz47jZD
         Bm0Vnh/R9CTNwF71gKRTzbOOK2moyubUs1ZWRiiGI/ObPyGrKo4bXNmEm0FcrXkYg1Tz
         UaRPYzonKv2jyRaIrt69u1zGRvXXtWQMRvnhGmAitCw+AlO4CnI/GnNV46UtPzRkSc5b
         O4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WsZxcVF6gelyqFkjIt1JdX7eFg0WjDR//rw4D2Z8gs8=;
        b=N5FjmcdP4kcMaEOUdqzrCC+Nudj9RTfgXMCf40wREkYv7cFJo2Gk/TXLJPCiJRqZ7H
         z2fW2RxbhDsX0lZ2zzwV/6mV9n7dtnE6C5VUp5SU0K50S/SEsmsjbQS2eSBzU2933+Co
         JL+lk84kZ7n2NOuqa/pzQ/MW8Z5DS9psYDaHE0+U229vbJlTCyD0YzWp4tW4C2nEnovL
         D0OTjeW8/N3SMLLjqVoBD7bxexDj0B0DwDVcL0nl8vNtqlJi9HJ9HLr9l3BRkuGJpxwl
         oto6gPwSGpZmP32b7uVpS0cLJlI9GoLJec1JNtYTSw1OlYLEV9lb/f2vp9Tpg6Sa6YV+
         AGtQ==
X-Gm-Message-State: AOAM531HDT1gfw3JDW122XP58xumnc9RLojdtPkFB6gfcPHnDqRNBlpu
        0BCaccZS+B8/TRLX6RMDLyI=
X-Google-Smtp-Source: ABdhPJy21/36o8RbcYc3P0F87LTTzcgjypp4Vfim45j/4/DCLn5D8RIIkLxvz5WSuSLW6fnYmICcIQ==
X-Received: by 2002:a17:902:a3c1:b0:14f:dc65:ff6c with SMTP id q1-20020a170902a3c100b0014fdc65ff6cmr19902576plb.13.1648360660215;
        Sat, 26 Mar 2022 22:57:40 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id x2-20020a63aa42000000b0038265eb2495sm9308525pgo.88.2022.03.26.22.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:57:39 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     agross@kernel.org
Cc:     bjorn.andersson@linaro.org, will@kernel.org, mark.rutland@arm.com,
        nleeder@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] perf: qcom_l2_pmu: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 13:57:33 +0800
Message-Id: <20220327055733.4070-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	return cluster;

The list iterator value 'cluster' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
is found.

To fix the bug, return 'cluster' when found, otherwise return NULL.

Cc: stable@vger.kernel.org
Fixes: 21bdbb7102ede ("perf: add qcom l2 cache perf events driver")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/perf/qcom_l2_pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/perf/qcom_l2_pmu.c b/drivers/perf/qcom_l2_pmu.c
index 7640491aab12..30234c261b05 100644
--- a/drivers/perf/qcom_l2_pmu.c
+++ b/drivers/perf/qcom_l2_pmu.c
@@ -736,7 +736,7 @@ static struct cluster_pmu *l2_cache_associate_cpu_with_cluster(
 {
 	u64 mpidr;
 	int cpu_cluster_id;
-	struct cluster_pmu *cluster = NULL;
+	struct cluster_pmu *cluster;
 
 	/*
 	 * This assumes that the cluster_id is in MPIDR[aff1] for
@@ -758,10 +758,10 @@ static struct cluster_pmu *l2_cache_associate_cpu_with_cluster(
 			 cluster->cluster_id);
 		cpumask_set_cpu(cpu, &cluster->cluster_cpus);
 		*per_cpu_ptr(l2cache_pmu->pmu_cluster, cpu) = cluster;
-		break;
+		return cluster;
 	}
 
-	return cluster;
+	return NULL;
 }
 
 static int l2cache_pmu_online_cpu(unsigned int cpu, struct hlist_node *node)
-- 
2.17.1

