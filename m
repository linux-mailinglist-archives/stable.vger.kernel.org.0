Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5BE33B851
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhCOOCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232844AbhCOOAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DAC664F21;
        Mon, 15 Mar 2021 13:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816768;
        bh=02ckzVMLLa7/mqcJCbiSz5NJ52Ls+EyxHla1v14UTX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vd9jLNLA6d+f6dhob3+5Wfvxb7dPtPMGoZqvP0Y84afrdz0npBCZpNWfPbNpwqHTK
         Pq0gqB5j9uXwGL1D20AUXxQyqzBYZjn023CSWgeF8LGel7wtUqzt8kxv84U8Dfe3Yu
         d4z29ul3C7KR8RnIL1GiLU4OQTUyEjX+d5ommp7M=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/120] s390/smp: __smp_rescan_cpus() - move cpumask away from stack
Date:   Mon, 15 Mar 2021 14:56:46 +0100
Message-Id: <20210315135721.787469574@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



