Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E6D2A53CB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388002AbgKCVEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387998AbgKCVEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:04:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB7A20658;
        Tue,  3 Nov 2020 21:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437477;
        bh=gkPEqAXJN9EPTh7XGZIwCLPEEsQ7pPhdG9e2tiRjWY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYVD4zPuB/nqY9M6ns8UKt4QePtNsKQw64eSISNRqdky8CPAaegMly6il9YdyTgLv
         Am7PYSyHLUe0rymG0j49E3cuQdn6vy+nr93jQSkIzsYEyDqgJbUxNIlWiUS074vSla
         Rrnj47VEePORlM4wK26leINccOj2YxJtaXGCNvpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@tj.kylinos.cn>,
        Gavin Shan <gshan@redhat.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/191] arm64/mm: return cpu_all_mask when node is NUMA_NO_NODE
Date:   Tue,  3 Nov 2020 21:36:18 +0100
Message-Id: <20201103203242.125528550@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengyuan Liu <liuzhengyuan@tj.kylinos.cn>

[ Upstream commit a194c5f2d2b3a05428805146afcabe5140b5d378 ]

The @node passed to cpumask_of_node() can be NUMA_NO_NODE, in that
case it will trigger the following WARN_ON(node >= nr_node_ids) due to
mismatched data types of @node and @nr_node_ids. Actually we should
return cpu_all_mask just like most other architectures do if passed
NUMA_NO_NODE.

Also add a similar check to the inline cpumask_of_node() in numa.h.

Signed-off-by: Zhengyuan Liu <liuzhengyuan@tj.kylinos.cn>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Link: https://lore.kernel.org/r/20200921023936.21846-1-liuzhengyuan@tj.kylinos.cn
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/numa.h | 3 +++
 arch/arm64/mm/numa.c          | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/numa.h b/arch/arm64/include/asm/numa.h
index 626ad01e83bf0..dd870390d639f 100644
--- a/arch/arm64/include/asm/numa.h
+++ b/arch/arm64/include/asm/numa.h
@@ -25,6 +25,9 @@ const struct cpumask *cpumask_of_node(int node);
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
 static inline const struct cpumask *cpumask_of_node(int node)
 {
+	if (node == NUMA_NO_NODE)
+		return cpu_all_mask;
+
 	return node_to_cpumask_map[node];
 }
 #endif
diff --git a/arch/arm64/mm/numa.c b/arch/arm64/mm/numa.c
index 54529b4ed5130..15eaf1e09d0ca 100644
--- a/arch/arm64/mm/numa.c
+++ b/arch/arm64/mm/numa.c
@@ -58,7 +58,11 @@ EXPORT_SYMBOL(node_to_cpumask_map);
  */
 const struct cpumask *cpumask_of_node(int node)
 {
-	if (WARN_ON(node >= nr_node_ids))
+
+	if (node == NUMA_NO_NODE)
+		return cpu_all_mask;
+
+	if (WARN_ON(node < 0 || node >= nr_node_ids))
 		return cpu_none_mask;
 
 	if (WARN_ON(node_to_cpumask_map[node] == NULL))
-- 
2.27.0



