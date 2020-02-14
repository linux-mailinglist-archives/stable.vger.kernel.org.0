Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4912315EB5E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389147AbgBNRUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:20:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391567AbgBNQKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CCB524695;
        Fri, 14 Feb 2020 16:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696638;
        bh=H01V1yAvGUnL110QyGxoWUFcprdk0MX1LGVD14UnwEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCklJDq8Q2mynhT7Um6Wp1estXSHPhiQ2SiOH/05679ePMr8LMOUwBIBYseAlLbk2
         nIPXnXVmJWStrp4FHyNUpdImm6soZ5Nv8RwEWWyWBb75jckZB3qyZsex051WBY4s1L
         o5CyLmAgX0DIdn6ZJkgwKoSubKN3hbpUWy8TUtYE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 416/459] powerpc/mm: Don't log user reads to 0xffffffff
Date:   Fri, 14 Feb 2020 11:01:06 -0500
Message-Id: <20200214160149.11681-416-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 0f9aee0cb9da7db7d96f63cfa2dc5e4f1bffeb87 ]

Running vdsotest leaves many times the following log:

  [   79.629901] vdsotest[396]: User access of kernel address (ffffffff) - exploit attempt? (uid: 0)

A pointer set to (-1) is likely a programming error similar to
a NULL pointer and is not worth logging as an exploit attempt.

Don't log user accesses to 0xffffffff.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/0728849e826ba16f1fbd6fa7f5c6cc87bd64e097.1577087627.git.christophe.leroy@c-s.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/fault.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 9298905cfe74f..881a026a603a6 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -354,6 +354,9 @@ static void sanity_check_fault(bool is_write, bool is_user,
 	 * Userspace trying to access kernel address, we get PROTFAULT for that.
 	 */
 	if (is_user && address >= TASK_SIZE) {
+		if ((long)address == -1)
+			return;
+
 		pr_crit_ratelimited("%s[%d]: User access of kernel address (%lx) - exploit attempt? (uid: %d)\n",
 				   current->comm, current->pid, address,
 				   from_kuid(&init_user_ns, current_uid()));
-- 
2.20.1

