Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4521A9F2E
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441195AbgDOMHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897627AbgDOLrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A50214D8;
        Wed, 15 Apr 2020 11:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951241;
        bh=smI26Thxjv2e0tMx0kjMXubhh1q/+1ZeAOE/x4BuRko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCoZxOxyOWcQlnmbVEkTkWFxqNH7y7QWUCtVuXs3OKN5bhvzwh3NB3IXA0wPuXb5f
         F2652zwfNmnZBpGxAtfGQHHLmLnniX3K6RbkHK0TjL6oYjCYfve9+1ZIeIGizrJgfC
         1DTGn0OZ7fopgdUYL/dX7OcXIMAtIX8secPq1xSA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/30] s390/cpuinfo: fix wrong output when CPU0 is offline
Date:   Wed, 15 Apr 2020 07:46:49 -0400
Message-Id: <20200415114711.15381-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114711.15381-1-sashal@kernel.org>
References: <20200415114711.15381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 872f27103874a73783aeff2aac2b41a489f67d7c ]

/proc/cpuinfo should not print information about CPU 0 when it is offline.

Fixes: 281eaa8cb67c ("s390/cpuinfo: simplify locking and skip offline cpus early")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
[heiko.carstens@de.ibm.com: shortened commit message]
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/processor.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/processor.c b/arch/s390/kernel/processor.c
index 6fe2e1875058b..675d4be0c2b77 100644
--- a/arch/s390/kernel/processor.c
+++ b/arch/s390/kernel/processor.c
@@ -157,8 +157,9 @@ static void show_cpu_mhz(struct seq_file *m, unsigned long n)
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	unsigned long n = (unsigned long) v - 1;
+	unsigned long first = cpumask_first(cpu_online_mask);
 
-	if (!n)
+	if (n == first)
 		show_cpu_summary(m, v);
 	if (!machine_has_cpu_mhz)
 		return 0;
@@ -171,6 +172,8 @@ static inline void *c_update(loff_t *pos)
 {
 	if (*pos)
 		*pos = cpumask_next(*pos - 1, cpu_online_mask);
+	else
+		*pos = cpumask_first(cpu_online_mask);
 	return *pos < nr_cpu_ids ? (void *)*pos + 1 : NULL;
 }
 
-- 
2.20.1

