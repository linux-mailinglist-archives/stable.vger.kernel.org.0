Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 385C3B85A3
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394158AbfISWXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394167AbfISWXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:23:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E25021924;
        Thu, 19 Sep 2019 22:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931790;
        bh=yLnWCBzURFYaphma3SALcWe00G9AD5Jynb2Nanj3EW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtBTmOaTMb0ztwJnUNcuACt6SF3CVhvyKSwGDqBbUYlWcinuSRduum+BuuxNmJuky
         ua3WJJYxHzK4DqtowjU9K9lcnvrAnlWAmHPU2Gw1W3xKHFJF/dKciL4qNqTVDAlEPB
         5zWs4JWiwHKx6M9MnTp4uxucIpeNFJm0zgM9x8as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Laura Abbott <labbott@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Peng Fan <peng.fan@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 41/56] ARM: 8874/1: mm: only adjust sections of valid mm structures
Date:   Fri, 20 Sep 2019 00:04:22 +0200
Message-Id: <20190919214759.795931660@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a9f6705aea238..731b7e64715b9 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -691,7 +691,8 @@ static void update_sections_early(struct section_perm perms[], int n)
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



