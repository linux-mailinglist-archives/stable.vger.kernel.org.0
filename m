Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4AD32AF49
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbhCCAQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350181AbhCBMOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:14:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B46C964F78;
        Tue,  2 Mar 2021 11:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686258;
        bh=onLq89cOFx+AyLaOx4Qx+MWy1UoCg9ftS820O9gTxYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7sWXKKuRbiszNP+4ZDMzcq4d+CjPvPzhdgYoexQ/r1aNEzuo/g44rNYaenPD515L
         xj8+5s9BY6/xU/3A3hODdDDzn7655rhALt0acMOKmFwGg0sFEUs3tvwFJhvtfiP8dm
         bZqoTXZzkjaGS9nzfDGsFmBFRikzGA5/DgSyD5KZwnAmyClTNf9O6/P+f6ryW6J7wK
         vuCpRVzT9lbbOb1WulGAWbUcURVmr3UhI+7tHp8JNBuQqLNSUcNTyI/1q4tHMyPTiT
         0kbHSqzCg0rgdxq4jGRw5/oAt7PihKg8RvK01K4YMLfV4uJ7HklvowBnXimkaYXyru
         88rflK5s4VH4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 41/47] s390/smp: __smp_rescan_cpus() - move cpumask away from stack
Date:   Tue,  2 Mar 2021 06:56:40 -0500
Message-Id: <20210302115646.62291-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
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
index 3a0d545f0ce8..791bc373418b 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -775,7 +775,7 @@ static int smp_add_core(struct sclp_core_entry *core, cpumask_t *avail,
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

