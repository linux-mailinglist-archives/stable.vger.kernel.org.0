Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81A9299FDA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442321AbgJ0AZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410129AbgJZXxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 841A1221FA;
        Mon, 26 Oct 2020 23:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756416;
        bh=kNN9WeQP4nWaV6sEsJfgKe5aLQBNl0cTieqmXZ4EBm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzvZRhm+jR9f7blfvwVD4aHtSJABMuqVtRLvF7xPHtRirh8DgHBlT29uufBrvhXv7
         k1jXd51tAFrMbwWzhL6oWOXcxrUqFx1w2ih5UpGp+928aq55+14c5KnRANB8j9sOId
         T/8To7/Lm5r/Au6rBWAfLfAREk/+llE1v0eojIlA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhengyuan Liu <liuzhengyuan@tj.kylinos.cn>,
        Gavin Shan <gshan@redhat.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 073/132] arm64/mm: return cpu_all_mask when node is NUMA_NO_NODE
Date:   Mon, 26 Oct 2020 19:51:05 -0400
Message-Id: <20201026235205.1023962-73-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index aafcee3e3f7ef..58c83c2b8748f 100644
--- a/arch/arm64/mm/numa.c
+++ b/arch/arm64/mm/numa.c
@@ -46,7 +46,11 @@ EXPORT_SYMBOL(node_to_cpumask_map);
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
2.25.1

