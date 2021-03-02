Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3080532AFA3
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbhCCA1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:27:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350701AbhCBMXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:23:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9EB564FB0;
        Tue,  2 Mar 2021 11:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686338;
        bh=kKPXFGmocRgAyVULV6u78ddVNab1ZnkopxxC8LH//7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMOB65a2pkLjiD/V58IRBwC6DZsMWgyQtwHRCnx3k+Paftt/HFr4K6c4I5vxqqNbf
         cZjEQtfmi/JOz79nvGngEP5hEgLXt9jb6aZh00j8qVea7tIYBWIkGierSAuf/j43ZK
         9CcwNEBGDQ+iqxMSQ3hiZRM7+1QTkJ19ADQ8+e6URJi3wasvSLpJ8cRq35s8x/saEC
         vh+3UwIya3R2AqQXyKhrYM9gJsKj5KMwU/RIJs/bQMKDKaDfFjkZ+JSIyl1sB6lPVm
         cHfmlxHRHotFtxJ6B8mj92lIVz8pb62T9JjUhpHD3/FxcdHatwT6alN2vh7vwHIaVK
         mvpTSJlrCtcNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/21] s390/smp: __smp_rescan_cpus() - move cpumask away from stack
Date:   Tue,  2 Mar 2021 06:58:32 -0500
Message-Id: <20210302115835.63269-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115835.63269-1-sashal@kernel.org>
References: <20210302115835.63269-1-sashal@kernel.org>
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
index c47bd581a08a..bce678c7179c 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -751,7 +751,7 @@ static int smp_add_core(struct sclp_core_entry *core, cpumask_t *avail,
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

