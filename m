Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E59C132FC8
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 20:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgAGTp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 14:45:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgAGTp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 14:45:26 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69A6C2187F;
        Tue,  7 Jan 2020 19:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578426325;
        bh=a62yqH6CQ3olTs3Ze32U1Y03qPp2spOZyIVZtyThr/M=;
        h=Date:From:To:Subject:From;
        b=xop74Njt6Q7/FFOcEkdXNLTX+4OwN4g/FTE1JvyN3gtayBH50AM+CFuICTivfplZV
         IbxymzSrY3psEIS3g5Cq60GdHiQsapNJLcxAfYvnqG/YiQ8QafLsfXRdxCp+zbGzFH
         y5E685mGyFxeMq+iehvaOnZ5MSKYS9tUww3DhTmw=
Date:   Tue, 07 Jan 2020 11:45:25 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, echron@arista.com, idryomov@gmail.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-oom-fix-pgtables-units-mismatch-in-killed-process-message.patch removed
 from -mm tree
Message-ID: <20200107194525.uXF6D8jlA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/oom: fix pgtables units mismatch in Killed process message
has been removed from the -mm tree.  Its filename was
     mm-oom-fix-pgtables-units-mismatch-in-killed-process-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ilya Dryomov <idryomov@gmail.com>
Subject: mm/oom: fix pgtables units mismatch in Killed process message

pr_err() expects kB, but mm_pgtables_bytes() returns the number of bytes. 
As everything else is printed in kB, I chose to fix the value rather than
the string.

Before:

[  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
...
[   1878]  1000  1878   217253   151144  1269760        0             0 python
...
Out of memory: Killed process 1878 (python) total-vm:869012kB, anon-rss:604572kB, file-rss:4kB, shmem-rss:0kB, UID:1000 pgtables:1269760kB oom_score_adj:0

After:

[  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
...
[   1436]  1000  1436   217253   151890  1294336        0             0 python
...
Out of memory: Killed process 1436 (python) total-vm:869012kB, anon-rss:607516kB, file-rss:44kB, shmem-rss:0kB, UID:1000 pgtables:1264kB oom_score_adj:0

Link: http://lkml.kernel.org/r/20191211202830.1600-1-idryomov@gmail.com
Fixes: 70cb6d267790 ("mm/oom: add oom_score_adj and pgtables to Killed process message")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Edward Chron <echron@arista.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom-fix-pgtables-units-mismatch-in-killed-process-message
+++ a/mm/oom_kill.c
@@ -890,7 +890,7 @@ static void __oom_kill_process(struct ta
 		K(get_mm_counter(mm, MM_FILEPAGES)),
 		K(get_mm_counter(mm, MM_SHMEMPAGES)),
 		from_kuid(&init_user_ns, task_uid(victim)),
-		mm_pgtables_bytes(mm), victim->signal->oom_score_adj);
+		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
 	task_unlock(victim);
 
 	/*
_

Patches currently in -mm which might be from idryomov@gmail.com are


