Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E042632AFC2
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238878AbhCCA2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:28:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383891AbhCBMcr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:32:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D70F964FC7;
        Tue,  2 Mar 2021 11:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686385;
        bh=X91BEpklofYjO4+lMYsjJCV7Ypwis/RBmob7/45dcQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKbYEhvvtz1/v3XxzlQyEhUYrJvi+6e5NhhmbUFUI3eWbr+k+WpRvzlerXWoRm4zZ
         eN5pZGAvZA+XehqohQrJ4TXashaVnri/Rp0lwF885FsBijq3VeetbotWUpSC9Np4BL
         v7hdJlsAUHOZknXy1px2fMWOMybLF3L8QVOgBDOOY7FNmMC3ycrxRqhXycstzNarNF
         lPXKLu1LMyghBPJHBCLYIrVeEEjYaOriRfwboAhrkXS6xN5wV5tTCHmqyJvhciENs6
         8q5F1qPssu7TAZGKE4guboT6350VAY2PBBOiKHPm3eDgN6gyXLPoNdZqgfZrVUgKLb
         RW7vhtA9izI9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 7/8] s390/smp: __smp_rescan_cpus() - move cpumask away from stack
Date:   Tue,  2 Mar 2021 06:59:34 -0500
Message-Id: <20210302115935.63777-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115935.63777-1-sashal@kernel.org>
References: <20210302115935.63777-1-sashal@kernel.org>
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
index f113fcd781d8..486f0d4f9aee 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -738,7 +738,7 @@ static int smp_add_core(struct sclp_core_entry *core, cpumask_t *avail,
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

