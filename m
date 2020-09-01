Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4853E25991A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbgIAQgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730548AbgIAP3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 705062100A;
        Tue,  1 Sep 2020 15:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974180;
        bh=rQf9pHyRrJGeKhzV9canzvzUgwfkjPmDF7b/ZBmDqUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+gE/w3x6WK8hQktJOvEhZn5SWbLBMQRtqTNXkxBh6CxVm64TSb/7CQ9N7jlRRO7+
         BmMUzy/YhZvekhuOjGBmSuYSNvlgCQ3d2GU2n+VD+aju32lZHJMmQChDikLECl1Fzz
         hvtyCk6Z5x8bi5rA2uTQpym8p1bDxrnDduTxoi1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/214] s390/numa: set node distance to LOCAL_DISTANCE
Date:   Tue,  1 Sep 2020 17:09:16 +0200
Message-Id: <20200901150956.617148721@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 535e4fc623fab2e09a0653fc3a3e17f382ad0251 ]

The node distance is hardcoded to 0, which causes a trouble
for some user-level applications. In particular, "libnuma"
expects the distance of a node to itself as LOCAL_DISTANCE.
This update removes the offending node distance override.

Cc: <stable@vger.kernel.org> # 4.4
Fixes: 3a368f742da1 ("s390/numa: add core infrastructure")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/numa.h     | 1 -
 arch/s390/include/asm/topology.h | 2 --
 arch/s390/numa/numa.c            | 6 ------
 3 files changed, 9 deletions(-)

diff --git a/arch/s390/include/asm/numa.h b/arch/s390/include/asm/numa.h
index 35f8cbe7e5bb0..c759dcffa9eaf 100644
--- a/arch/s390/include/asm/numa.h
+++ b/arch/s390/include/asm/numa.h
@@ -17,7 +17,6 @@
 
 void numa_setup(void);
 int numa_pfn_to_nid(unsigned long pfn);
-int __node_distance(int a, int b);
 void numa_update_cpu_topology(void);
 
 extern cpumask_t node_to_cpumask_map[MAX_NUMNODES];
diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index cca406fdbe51f..ef9dd253dfad0 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -83,8 +83,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 
-#define node_distance(a, b) __node_distance(a, b)
-
 #else /* !CONFIG_NUMA */
 
 #define numa_node_id numa_node_id
diff --git a/arch/s390/numa/numa.c b/arch/s390/numa/numa.c
index d2910fa834c8a..8386c58fdb3a0 100644
--- a/arch/s390/numa/numa.c
+++ b/arch/s390/numa/numa.c
@@ -49,12 +49,6 @@ void numa_update_cpu_topology(void)
 		mode->update_cpu_topology();
 }
 
-int __node_distance(int a, int b)
-{
-	return mode->distance ? mode->distance(a, b) : 0;
-}
-EXPORT_SYMBOL(__node_distance);
-
 int numa_debug_enabled;
 
 /*
-- 
2.25.1



