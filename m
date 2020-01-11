Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C39D138042
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbgAKK1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:27:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729453AbgAKK1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:27:40 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12CD22082E;
        Sat, 11 Jan 2020 10:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738460;
        bh=rz3vLQZsEWlTvqZxYmkCgHHyAVgnHuRMZcZGDboN2wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVC2Ej7Q3EUjp94mQ/+iAnYW9zjcDfxkpUyQK1xeCN+B3/zX3ra+Kq7bySypmx7dw
         kkccCObFSjNXreqI4EFc2QhKWazPb7T0bCg4jQLY3fqhwUy2Q/4LJhMCb5jfLL98rE
         NtTEFIiwqgqH2vycmqzXOqPUulHQ0gVmg61V1Vro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meelis Roos <mroos@linux.ee>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/165] perf/x86: Fix potential out-of-bounds access
Date:   Sat, 11 Jan 2020 10:50:17 +0100
Message-Id: <20200111094929.877047542@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1e69a0efc0bd0e02b8327e7186fbb4a81878ea0b ]

UBSAN reported out-of-bound accesses for x86_pmu.event_map(), it's
arguments should be < x86_pmu.max_events. Make sure all users observe
this constraint.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 7b21455d7504..b9673396b571 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1641,9 +1641,12 @@ static struct attribute_group x86_pmu_format_group __ro_after_init = {
 
 ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr, char *page)
 {
-	struct perf_pmu_events_attr *pmu_attr = \
+	struct perf_pmu_events_attr *pmu_attr =
 		container_of(attr, struct perf_pmu_events_attr, attr);
-	u64 config = x86_pmu.event_map(pmu_attr->id);
+	u64 config = 0;
+
+	if (pmu_attr->id < x86_pmu.max_events)
+		config = x86_pmu.event_map(pmu_attr->id);
 
 	/* string trumps id */
 	if (pmu_attr->event_str)
@@ -1712,6 +1715,9 @@ is_visible(struct kobject *kobj, struct attribute *attr, int idx)
 {
 	struct perf_pmu_events_attr *pmu_attr;
 
+	if (idx >= x86_pmu.max_events)
+		return 0;
+
 	pmu_attr = container_of(attr, struct perf_pmu_events_attr, attr.attr);
 	/* str trumps id */
 	return pmu_attr->event_str || x86_pmu.event_map(idx) ? attr->mode : 0;
-- 
2.20.1



