Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B337DB9313
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392787AbfITOhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:37:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35742 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388010AbfITOZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqD-0004wo-3p; Fri, 20 Sep 2019 15:24:57 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0007qJ-N9; Fri, 20 Sep 2019 15:24:56 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Ren" <renzhen@linux.alibaba.com>,
        "Jiufei Xue" <jiufei.xue@linux.alibaba.com>,
        "Jan Kara" <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.244664188@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 022/132] jbd2: check superblock mapped prior to
 committing
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiufei Xue <jiufei.xue@linux.alibaba.com>

commit 742b06b5628f2cd23cb51a034cb54dc33c6162c5 upstream.

We hit a BUG at fs/buffer.c:3057 if we detached the nbd device
before unmounting ext4 filesystem.

The typical chain of events leading to the BUG:
jbd2_write_superblock
  submit_bh
    submit_bh_wbc
      BUG_ON(!buffer_mapped(bh));

The block device is removed and all the pages are invalidated. JBD2
was trying to write journal superblock to the block device which is
no longer present.

Fix this by checking the journal superblock's buffer head prior to
submitting.

Reported-by: Eric Ren <renzhen@linux.alibaba.com>
Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jbd2/journal.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1344,6 +1344,10 @@ static int jbd2_write_superblock(journal
 	journal_superblock_t *sb = journal->j_superblock;
 	int ret;
 
+	/* Buffer got discarded which means block device got invalidated */
+	if (!buffer_mapped(bh))
+		return -EIO;
+
 	trace_jbd2_write_superblock(journal, write_op);
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_op &= ~(REQ_FUA | REQ_FLUSH);

