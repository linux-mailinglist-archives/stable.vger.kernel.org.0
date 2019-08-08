Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42CB869E2
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405519AbfHHTLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405535AbfHHTLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8736214C6;
        Thu,  8 Aug 2019 19:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291504;
        bh=nQc0EkFtfBL68EBaU+ANWSb1GzRoMR3xpsLhl74/bHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLJopfF3Hm+nZwfWrQav40LRRIqmrPCP515SzL7INrft8Ppb4pe05FfIBvp0IWzzx
         f4ft6B7akwjifhW7TA8EgYyNFX6WtX7Lgdb1+9Al1fwj3NOGKfj6ZnCrcMduZrN0GD
         wnV/PCwmQfKujQIVve/lIJl0Z+c3fsT6LYG5p2Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        syzbot+d4bba5ccd4f9a2a68681@syzkaller.appspotmail.com
Subject: [PATCH 4.14 32/33] cgroup: Fix css_task_iter_advance_css_set() cset skip condition
Date:   Thu,  8 Aug 2019 21:05:39 +0200
Message-Id: <20190808190455.277241353@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit c596687a008b579c503afb7a64fcacc7270fae9e upstream.

While adding handling for dying task group leaders c03cd7738a83
("cgroup: Include dying leaders with live threads in PROCS
iterations") added an inverted cset skip condition to
css_task_iter_advance_css_set().  It should skip cset if it's
completely empty but was incorrectly testing for the inverse condition
for the dying_tasks list.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: c03cd7738a83 ("cgroup: Include dying leaders with live threads in PROCS iterations")
Reported-by: syzbot+d4bba5ccd4f9a2a68681@syzkaller.appspotmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4048,7 +4048,7 @@ static void css_task_iter_advance_css_se
 			it->task_pos = NULL;
 			return;
 		}
-	} while (!css_set_populated(cset) && !list_empty(&cset->dying_tasks));
+	} while (!css_set_populated(cset) && list_empty(&cset->dying_tasks));
 
 	if (!list_empty(&cset->tasks))
 		it->task_pos = cset->tasks.next;


