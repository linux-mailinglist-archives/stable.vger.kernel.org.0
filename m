Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9A18F54C
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 22:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733221AbfHOUCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 16:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733212AbfHOUCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 16:02:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 970A12089E;
        Thu, 15 Aug 2019 20:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565899343;
        bh=UZaCR1A10doPAt0qAHsMjKBIg80whx10pAiS94oqYp8=;
        h=Date:From:To:Subject:From;
        b=MdUz96wMgWw0E2ahc6DPdHac0nBJ5DXAfrN4G4Z6OFK97cJHpBc9DCYlGaTf/fzYs
         aDOErDOvehzeDwRkULb9C/t58YJUtb0nyDDio1ELApUaYkD6aQL/Bvzt4+7RvgdWB1
         XZKGejG3iGBf8i7gnIAi0ooaI8Iz9mraw8LAVOP8=
Date:   Thu, 15 Aug 2019 13:02:23 -0700
From:   akpm@linux-foundation.org
To:     Markus.Elfring@web.de, mm-commits@vger.kernel.org, neilb@suse.com,
        stable@vger.kernel.org, turchanov@farpost.com,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 seq_file-fix-problem-when-seeking-mid-record.patch removed from -mm tree
Message-ID: <20190815200223.tO_KW6U1Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: seq_file: fix problem when seeking mid-record
has been removed from the -mm tree.  Its filename was
     seq_file-fix-problem-when-seeking-mid-record.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.com>
Subject: seq_file: fix problem when seeking mid-record

If you use lseek or similar (e.g.  pread) to access a location in a
seq_file file that is within a record, rather than at a record boundary,
then the first read will return the remainder of the record, and the
second read will return the whole of that same record (instead of the next
record).  When seeking to a record boundary, the next record is correctly
returned.

This bug was introduced by a recent patch (identified below).  Before that
patch, seq_read() would increment m->index when the last of the buffer was
returned (m->count == 0).  After that patch, we rely on ->next to
increment m->index after filling the buffer - but there was one place
where that didn't happen.

Link: https://lkml.kernel.org/lkml/877e7xl029.fsf@notabene.neil.brown.name/
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Signed-off-by: NeilBrown <neilb@suse.com>
Reported-by: Sergei Turchanov <turchanov@farpost.com>
Tested-by: Sergei Turchanov <turchanov@farpost.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: <stable@vger.kernel.org>	[4.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/seq_file.c~seq_file-fix-problem-when-seeking-mid-record
+++ a/fs/seq_file.c
@@ -119,6 +119,7 @@ static int traverse(struct seq_file *m,
 		}
 		if (seq_has_overflowed(m))
 			goto Eoverflow;
+		p = m->op->next(m, p, &m->index);
 		if (pos + m->count > offset) {
 			m->from = offset - pos;
 			m->count -= m->from;
@@ -126,7 +127,6 @@ static int traverse(struct seq_file *m,
 		}
 		pos += m->count;
 		m->count = 0;
-		p = m->op->next(m, p, &m->index);
 		if (pos == offset)
 			break;
 	}
_

Patches currently in -mm which might be from neilb@suse.com are


