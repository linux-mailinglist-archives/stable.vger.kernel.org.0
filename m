Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B570CA8B15
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733088AbfIDQBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732012AbfIDQBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:01:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64252070C;
        Wed,  4 Sep 2019 16:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612901;
        bh=HM89y0GM3yQ9uGNFebzaFnpLm1dfQiI9Y1XTs/Ja0fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmCb+rPaB4rOLOoe+Tlh9cpXKhAZW+Xcxi3EthbAGZp4NQC28v/dGrKNEPixigmFK
         jfyK9JJIxbo5kVB93yucnW5dHPWy7KKD3vTuKo7GHmbZ65eZAWJx4h7XtVfShTgSKs
         nJp3u0muIb4A67yivWZEBeIjuEkGOlrgcPjgdYkE=
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
Subject: [PATCH AUTOSEL 4.14 14/36] ARM: 8874/1: mm: only adjust sections of valid mm structures
Date:   Wed,  4 Sep 2019 12:01:00 -0400
Message-Id: <20190904160122.4179-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
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
index defb7fc264280..4fa12fcf1f5d8 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -722,7 +722,8 @@ static void update_sections_early(struct section_perm perms[], int n)
 		if (t->flags & PF_KTHREAD)
 			continue;
 		for_each_thread(t, s)
-			set_section_perms(perms, n, true, s->mm);
+			if (s->mm)
+				set_section_perms(perms, n, true, s->mm);
 	}
 	set_section_perms(perms, n, true, current->active_mm);
 	set_section_perms(perms, n, true, &init_mm);
-- 
2.20.1

