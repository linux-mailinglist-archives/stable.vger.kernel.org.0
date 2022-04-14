Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714EA5010F1
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343593AbiDNOIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347680AbiDNN70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A20E49C81;
        Thu, 14 Apr 2022 06:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E874BB8298C;
        Thu, 14 Apr 2022 13:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34054C385A1;
        Thu, 14 Apr 2022 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944271;
        bh=wK2YngWWIWxMomu3G/G3fja+4rlWu+67C42w0ivXxVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQW4q04Vu17W64H6Vbx1TXZ4P6CZ0vX3U5a20ljAWC7AgbNxGhhUAKT0G8tLUZlT0
         Ru/ab1fZwYTZcEZnKCYyuZzXenlRzb61vXR8Ku+kBxfQxmczGmY4EM4BJmnLv19Ufl
         d17a1YuIyiGz9/l5D9z+LWAgS1ccIA569NRyiVxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 455/475] perf: qcom_l2_pmu: fix an incorrect NULL check on list iterator
Date:   Thu, 14 Apr 2022 15:14:00 +0200
Message-Id: <20220414110907.791052190@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 2012a9e279013933885983cbe0a5fe828052563b upstream.

The bug is here:
	return cluster;

The list iterator value 'cluster' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
is found.

To fix the bug, return 'cluster' when found, otherwise return NULL.

Cc: stable@vger.kernel.org
Fixes: 21bdbb7102ed ("perf: add qcom l2 cache perf events driver")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Link: https://lore.kernel.org/r/20220327055733.4070-1-xiam0nd.tong@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/qcom_l2_pmu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/perf/qcom_l2_pmu.c
+++ b/drivers/perf/qcom_l2_pmu.c
@@ -781,7 +781,7 @@ static struct cluster_pmu *l2_cache_asso
 {
 	u64 mpidr;
 	int cpu_cluster_id;
-	struct cluster_pmu *cluster = NULL;
+	struct cluster_pmu *cluster;
 
 	/*
 	 * This assumes that the cluster_id is in MPIDR[aff1] for
@@ -803,10 +803,10 @@ static struct cluster_pmu *l2_cache_asso
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


