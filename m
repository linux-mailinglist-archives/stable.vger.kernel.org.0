Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D38411BEC8
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 22:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfLKVCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 16:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbfLKVCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 16:02:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADB5120836;
        Wed, 11 Dec 2019 21:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576098150;
        bh=P4RGll93gXPE0+wlLsYIw6XI5tksKM19qezWvxj/Tg0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WKe1t6e22hUcnM7vPPcmLvgvp00l4RNcDDsMEZAgj7ro4GuLJSvv9EtFqja1rmcve
         BOmCZJQRBgLc4bvj3f2mBQIiGDk4NchXCBGvH3iY2NLpiCTGinDr69heObAtifmo5x
         jKUptgU2hTjtBuI6FKdOwifUCa6kigZJJybpcZpQ=
Date:   Wed, 11 Dec 2019 13:02:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, echron@arista.com, idryomov@gmail.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com,
        stable@vger.kernel.org
Subject:  +
 mm-oom-fix-pgtables-units-mismatch-in-killed-process-message.patch added to
 -mm tree
Message-ID: <20191211210229.ECH4aSGkL%akpm@linux-foundation.org>
In-Reply-To: <20191206170123.cb3ad1f76af2b48505fabb33@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/oom: fix pgtables units mismatch in Killed process message
has been added to the -mm tree.  Its filename is
     mm-oom-fix-pgtables-units-mismatch-in-killed-process-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-fix-pgtables-units-mismatch-in-killed-process-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-fix-pgtables-units-mismatch-in-killed-process-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Edward Chron <echron@arista.com>
Cc: Michal Hocko <mhocko@suse.com>
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

mm-oom-fix-pgtables-units-mismatch-in-killed-process-message.patch

