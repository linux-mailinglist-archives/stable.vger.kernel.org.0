Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4A763583A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbiKWJvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236590AbiKWJuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:50:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C977B10566
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:47:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88F3961B6F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E25C433C1;
        Wed, 23 Nov 2022 09:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196864;
        bh=9LuCxELjQe5XEdt7o5CPgb0qGBIZqkrcpmfrY//LbKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOqiyGclqdMjO5TRWjgtuUC8mJgkjy6/+bo+VGjBhTfdsouTu+h0vuepoCd8LsMkT
         v5uXES9+fjo0TpjHDVtCWgjgRNevAwN1m02a/8qkcoMGzwd9B2BPbWQt1SXd0C/VFo
         7uqBnuXEKu4LKUOoX/CmCzL+ECMYsl67OkK1+RO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Kuohai <xukuohai@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 146/314] bpf: Initialize same number of free nodes for each pcpu_freelist
Date:   Wed, 23 Nov 2022 09:49:51 +0100
Message-Id: <20221123084632.167451448@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 4b45cd81f737d79d0fbfc0d320a1e518e7f0bbf0 ]

pcpu_freelist_populate() initializes nr_elems / num_possible_cpus() + 1
free nodes for some CPUs, and then possibly one CPU with fewer nodes,
followed by remaining cpus with 0 nodes. For example, when nr_elems == 256
and num_possible_cpus() == 32, CPU 0~27 each gets 9 free nodes, CPU 28 gets
4 free nodes, CPU 29~31 get 0 free nodes, while in fact each CPU should get
8 nodes equally.

This patch initializes nr_elems / num_possible_cpus() free nodes for each
CPU firstly, then allocates the remaining free nodes by one for each CPU
until no free nodes left.

Fixes: e19494edab82 ("bpf: introduce percpu_freelist")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20221110122128.105214-1-xukuohai@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/percpu_freelist.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/percpu_freelist.c b/kernel/bpf/percpu_freelist.c
index 00b874c8e889..2ffb741eee8d 100644
--- a/kernel/bpf/percpu_freelist.c
+++ b/kernel/bpf/percpu_freelist.c
@@ -102,22 +102,21 @@ void pcpu_freelist_populate(struct pcpu_freelist *s, void *buf, u32 elem_size,
 			    u32 nr_elems)
 {
 	struct pcpu_freelist_head *head;
-	int i, cpu, pcpu_entries;
+	unsigned int cpu, cpu_idx, i, j, n, m;
 
-	pcpu_entries = nr_elems / num_possible_cpus() + 1;
-	i = 0;
+	n = nr_elems / num_possible_cpus();
+	m = nr_elems % num_possible_cpus();
 
+	cpu_idx = 0;
 	for_each_possible_cpu(cpu) {
-again:
 		head = per_cpu_ptr(s->freelist, cpu);
-		/* No locking required as this is not visible yet. */
-		pcpu_freelist_push_node(head, buf);
-		i++;
-		buf += elem_size;
-		if (i == nr_elems)
-			break;
-		if (i % pcpu_entries)
-			goto again;
+		j = n + (cpu_idx < m ? 1 : 0);
+		for (i = 0; i < j; i++) {
+			/* No locking required as this is not visible yet. */
+			pcpu_freelist_push_node(head, buf);
+			buf += elem_size;
+		}
+		cpu_idx++;
 	}
 }
 
-- 
2.35.1



