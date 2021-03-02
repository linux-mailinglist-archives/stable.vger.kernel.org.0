Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143AF32B09D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhCCAhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351394AbhCBOWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 09:22:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDBF864FB3;
        Tue,  2 Mar 2021 11:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686359;
        bh=tdEsweCBK+jRRgLHFORyuB/DNrpK71EXPvedRDiL8Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uN4guFijRE0/dKdfFZ9dDPo71MMgD9Tc2l2yBhe8PdB9b0cXv6sny0J/u3pY/1JT6
         y6ybpqy4iDGJaWeuQz/K1sp1IkRpiQmT1ccWbgTJvpQAPvw9Wzoted1CxIl2rJkDpd
         /3Cgm9n/EorvlP6RMMD5Szf0dpUMXtX2Ctvtun/QeAUfa/YrnZc80I6Q/T1l3B/r0J
         QvOdSpJBgddqMdXMTCsRokFgcm2EcX4CAdWS/mtWjimVGh6KtjgV+b1SGWG7A+8E40
         Vm/hS/bS4jJhLQqA3CGOxi74Z3eqAPtZ8nnUzrEg/RLWmSSVzX7J/fhwctEWLbdio+
         JEqMcCO/X7kYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/13] s390/smp: __smp_rescan_cpus() - move cpumask away from stack
Date:   Tue,  2 Mar 2021 06:59:02 -0500
Message-Id: <20210302115903.63458-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115903.63458-1-sashal@kernel.org>
References: <20210302115903.63458-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 62c8dca9e194326802b43c60763f856d782b225c ]

Avoid a potentially large stack frame and overflow by making
"cpumask_t avail" a static variable. There is no concurrent
access due to the existing locking.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 40946c8587a5..d43b48d8f67d 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -761,7 +761,7 @@ static int smp_add_core(struct sclp_core_entry *core, cpumask_t *avail,
 static int __smp_rescan_cpus(struct sclp_core_info *info, bool early)
 {
 	struct sclp_core_entry *core;
-	cpumask_t avail;
+	static cpumask_t avail;
 	bool configured;
 	u16 core_id;
 	int nr, i;
-- 
2.30.1

