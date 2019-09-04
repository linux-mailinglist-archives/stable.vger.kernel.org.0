Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE8A8BCC
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731774AbfIDQGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733309AbfIDQCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:02:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 451A52339D;
        Wed,  4 Sep 2019 16:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612954;
        bh=U7yRzAYMW30TIjYy8RlK1FZ5pZc4dDGGUPsgsBmMOss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBLoD5UQrt7T/8wE00/9MPi4Rnn5U0uMPQ6bM+0BxEUmGhlkDAhzsn1+9uUoUGUfh
         pKtLFb/WMMvUYg/JEkUQklJdY6JVlV3bx70RcyEwtFgES6B15ZrQSqQbsuuLp+VAZn
         zmz94xcZ73JPEDqYO0Jqb1yzQBJY89woi0Y67yDA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>, Laura Abbott <labbott@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Peng Fan <peng.fan@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 10/27] ARM: 8874/1: mm: only adjust sections of valid mm structures
Date:   Wed,  4 Sep 2019 12:02:03 -0400
Message-Id: <20190904160220.4545-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160220.4545-1-sashal@kernel.org>
References: <20190904160220.4545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit c51bc12d06b3a5494fbfcbd788a8e307932a06e9 ]

A timing hazard exists when an early fork/exec thread begins
exiting and sets its mm pointer to NULL while a separate core
tries to update the section information.

This commit ensures that the mm pointer is not NULL before
setting its section parameters. The arguments provided by
commit 11ce4b33aedc ("ARM: 8672/1: mm: remove tasklist locking
from update_sections_early()") are equally valid for not
requiring grabbing the task_lock around this check.

Fixes: 08925c2f124f ("ARM: 8464/1: Update all mm structures with section adjustments")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Laura Abbott <labbott@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Rob Herring <robh@kernel.org>
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 1565d6b671636..4fb1474141a61 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -698,7 +698,8 @@ static void update_sections_early(struct section_perm perms[], int n)
 		if (t->flags & PF_KTHREAD)
 			continue;
 		for_each_thread(t, s)
-			set_section_perms(perms, n, true, s->mm);
+			if (s->mm)
+				set_section_perms(perms, n, true, s->mm);
 	}
 	read_unlock(&tasklist_lock);
 	set_section_perms(perms, n, true, current->active_mm);
-- 
2.20.1

