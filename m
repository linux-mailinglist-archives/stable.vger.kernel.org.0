Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A0C33B7CC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhCOOBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232758AbhCON7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B493B64F3A;
        Mon, 15 Mar 2021 13:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816747;
        bh=HsTOAjFt0Qv3hWvDbeT7KpYR94s0MCCee9gvtc+rK34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWP+8pfyq5dJd90el9Uyl70uWatxKlqcuDDJwEtTqljD8uWBa2OTYoDDueITwhfDx
         zd7LfpaZDpnjOwVSK72+8/R7WIhIKP7p4zYluIOxI4WqXqQOUN6voKH7Dpe3aR4Vb1
         3zEjND29CM48qZAaK0K5uRXdLnkrfdgguLY391YQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/168] s390/smp: __smp_rescan_cpus() - move cpumask away from stack
Date:   Mon, 15 Mar 2021 14:55:15 +0100
Message-Id: <20210315135553.113281586@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
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
index 659d99af9156..8c51462f13fd 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -765,7 +765,7 @@ static int smp_add_core(struct sclp_core_entry *core, cpumask_t *avail,
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



