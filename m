Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D17E15EFAE
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388847AbgBNP7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388844AbgBNP7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10A6424681;
        Fri, 14 Feb 2020 15:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695952;
        bh=4aonCssWYdstuScFHWHex3lRsbsWzswOK1XgUJWXPzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rW9L223SHeibZC1iKHCCJhNgcws5jKPJP96JPez+rojzSt0s6pM4YtXtdV1FnZ2gN
         gQpO1hRsFiNdlfo7DNz5LMB0UFPsR2sGGsw6UtO3+jtKjOXPG3U/qAMsy9YB5wuqBj
         4tWe52vTBPmxnqC5mfyHKlJ9eIAYYZQk7HZY3KWc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.5 483/542] powerpc/mm: Don't log user reads to 0xffffffff
Date:   Fri, 14 Feb 2020 10:47:55 -0500
Message-Id: <20200214154854.6746-483-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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
index 1baeb045f7f4b..e083a9f67f701 100644
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

