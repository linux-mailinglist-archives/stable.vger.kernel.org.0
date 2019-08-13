Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2257C8C45C
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 00:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfHMWhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 18:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfHMWhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 18:37:45 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FFCF2067D;
        Tue, 13 Aug 2019 22:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565735864;
        bh=ysttfdAa6ko0C9eA5eQh7HuJ/XcqYVyeVwbJ1PQCm3U=;
        h=Date:From:To:Subject:From;
        b=Ykc1UA/MVo0L4s8U47ncPcjo8peE0lBOI22jnNOprObsQBZzrO1LU4MFxj/6LQNsa
         3D9p9fzIkL6+8G1xMsCYzjRxuWwJQu0IoVBjhUAPZ7SrLSKZoqCQsD5nY28U24Hei5
         oUtd9Ch43KWK9FbnI3ZLJpJ8HPcrNONk2A+g2y4Q=
Date:   Tue, 13 Aug 2019 15:37:44 -0700
From:   akpm@linux-foundation.org
To:     viro@zeniv.linux.org.uk, turchanov@farpost.com,
        stable@vger.kernel.org, Markus.Elfring@web.de, neilb@suse.com,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 13/18] seq_file: fix problem when seeking mid-record
Message-ID: <20190813223744.2CZ_v%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
