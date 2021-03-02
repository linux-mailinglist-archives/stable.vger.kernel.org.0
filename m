Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B1532AFE3
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbhCCA3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245751AbhCBMiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:38:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC66A64F3A;
        Tue,  2 Mar 2021 11:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686195;
        bh=ZBjTCQZngZWXOGpIJqWDdpln4/kqr+sxTTFX4V+7n58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIH0T9jjG95zwjtFOzqn+326oFXMZ8ayOe635snNLd73s77uAJMXkZWcrSX3Nv1BL
         MVj7IltzXml7nZSSkJ4AF3fk0MJ5sTFkOJpdQT6Lgon5I4Wqdseh8RfwW8v2levh4p
         ZAF6FAxFulDvyYEZGIMnIfqiXKcqCsedbMDwo1ZAX84uKkebIK/4QdmKO0hY+QWQT+
         Ul1j//lHGTkcNRjnw6fXrFEcaFZkvcxZwvrNDd8cQdxZy8HHzxbJ7iWVy58TZPd27t
         WJPHXZL048KneM/m5oiEx7+qImvURTw7RvEUCWTh3hHCHvXnTVEOxwxXVOMDLKgs0V
         WUPA11ugyIdlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 46/52] s390/smp: __smp_rescan_cpus() - move cpumask away from stack
Date:   Tue,  2 Mar 2021 06:55:27 -0500
Message-Id: <20210302115534.61800-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
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
index 27c763014114..1bae4a65416b 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -770,7 +770,7 @@ static int smp_add_core(struct sclp_core_entry *core, cpumask_t *avail,
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

