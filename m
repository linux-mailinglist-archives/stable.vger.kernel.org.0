Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED6D1B403B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgDVKS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729963AbgDVKS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:18:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8D922075A;
        Wed, 22 Apr 2020 10:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550707;
        bh=5nkV7eDi5Bx2nfm80C2yfyXLGRKXoar9TVzuNHHDrnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPc8fLm91Njb6X5OwKFNiDPFwW4xeJivIGPkG3nyW4ukiOXeXYObBWq7Qx/1Ve9lz
         Oj1AVcmDGK1Um6JVqzr3W5AU0jQu01ABleoTv9+2JX+IxK96faDOyi+wNKjnsBs/zM
         cw8GTlAQ+n4R/t+2/+4IMZPHqaXL0B8WMeoNvvQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/118] s390/cpuinfo: fix wrong output when CPU0 is offline
Date:   Wed, 22 Apr 2020 11:57:01 +0200
Message-Id: <20200422095041.859212172@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6ebc2117c66c7..91b9b3f73de6e 100644
--- a/arch/s390/kernel/processor.c
+++ b/arch/s390/kernel/processor.c
@@ -165,8 +165,9 @@ static void show_cpu_mhz(struct seq_file *m, unsigned long n)
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	unsigned long n = (unsigned long) v - 1;
+	unsigned long first = cpumask_first(cpu_online_mask);
 
-	if (!n)
+	if (n == first)
 		show_cpu_summary(m, v);
 	if (!machine_has_cpu_mhz)
 		return 0;
@@ -179,6 +180,8 @@ static inline void *c_update(loff_t *pos)
 {
 	if (*pos)
 		*pos = cpumask_next(*pos - 1, cpu_online_mask);
+	else
+		*pos = cpumask_first(cpu_online_mask);
 	return *pos < nr_cpu_ids ? (void *)*pos + 1 : NULL;
 }
 
-- 
2.20.1



