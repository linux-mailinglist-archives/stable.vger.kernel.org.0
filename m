Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4818699B0B
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfHVRS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388846AbfHVRIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:15 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F72223402;
        Thu, 22 Aug 2019 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493694;
        bh=5j8eSVDxtdl+CJ7xV2ee7Pj08LtadYXJ6WneXT9Kpf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqynQSxKdSrnPndUog4JDQMHYth6RLSbR/k7qppL2GjEunhNgsk4SPCKZ+o8OTr+Y
         aN9jUIA5/rAuxHVirzIFOzViOMiFR6SUq7IzZbjz9Hyzmf848fDj2dKBmDWjoScPpH
         vFN1LhZjsyGURYdV0KIUlPJQzFMt2ISRrnSPpAzw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.com>,
        Sergei Turchanov <turchanov@farpost.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Markus Elfring <Markus.Elfring@web.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 003/135] seq_file: fix problem when seeking mid-record
Date:   Thu, 22 Aug 2019 13:05:59 -0400
Message-Id: <20190822170811.13303-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.com>

commit 6a2aeab59e97101b4001bac84388fc49a992f87e upstream.

If you use lseek or similar (e.g.  pread) to access a location in a
seq_file file that is within a record, rather than at a record boundary,
then the first read will return the remainder of the record, and the
second read will return the whole of that same record (instead of the
next record).  When seeking to a record boundary, the next record is
correctly returned.

This bug was introduced by a recent patch (identified below).  Before
that patch, seq_read() would increment m->index when the last of the
buffer was returned (m->count == 0).  After that patch, we rely on
->next to increment m->index after filling the buffer - but there was
one place where that didn't happen.

Link: https://lkml.kernel.org/lkml/877e7xl029.fsf@notabene.neil.brown.name/
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Signed-off-by: NeilBrown <neilb@suse.com>
Reported-by: Sergei Turchanov <turchanov@farpost.com>
Tested-by: Sergei Turchanov <turchanov@farpost.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: <stable@vger.kernel.org>	[4.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/seq_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index abe27ec431766..225bf9239b329 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -119,6 +119,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 		}
 		if (seq_has_overflowed(m))
 			goto Eoverflow;
+		p = m->op->next(m, p, &m->index);
 		if (pos + m->count > offset) {
 			m->from = offset - pos;
 			m->count -= m->from;
@@ -126,7 +127,6 @@ static int traverse(struct seq_file *m, loff_t offset)
 		}
 		pos += m->count;
 		m->count = 0;
-		p = m->op->next(m, p, &m->index);
 		if (pos == offset)
 			break;
 	}
-- 
2.20.1

