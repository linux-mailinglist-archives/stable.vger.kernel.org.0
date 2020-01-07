Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 823D913341E
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgAGVA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:37114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbgAGVA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:00:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 176B624679;
        Tue,  7 Jan 2020 21:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430855;
        bh=anoq1RTDq1OzE2CcHB5UMkHgDAmFHe7j6kShud54A24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CliLGcepthVt1iW5+/dokxVR9W8Y/RgpUfelTlBbP6E7GpXQzu5MwgWylCyzL1AZg
         +1BB7k1gfzeRGntXl7QGYP0AEGP2QeKKiXroo9K2qJcFzx8Rslcuw3acuv6mzlG2zH
         ytcxlH4mBMHv41WcGn1vVyyV/5JnsLmHCudD9PhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Edward Chron <echron@arista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 087/191] mm/oom: fix pgtables units mismatch in Killed process message
Date:   Tue,  7 Jan 2020 21:53:27 +0100
Message-Id: <20200107205337.655036075@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit 941f762bcb276259a78e7931674668874ccbda59 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -890,7 +890,7 @@ static void __oom_kill_process(struct ta
 		K(get_mm_counter(mm, MM_FILEPAGES)),
 		K(get_mm_counter(mm, MM_SHMEMPAGES)),
 		from_kuid(&init_user_ns, task_uid(victim)),
-		mm_pgtables_bytes(mm), victim->signal->oom_score_adj);
+		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
 	task_unlock(victim);
 
 	/*


