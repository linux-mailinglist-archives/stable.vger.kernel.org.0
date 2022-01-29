Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCDF4A3213
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 22:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353232AbiA2Vl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 16:41:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48038 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353231AbiA2Vl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 16:41:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5BE9B827EE;
        Sat, 29 Jan 2022 21:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17968C340E5;
        Sat, 29 Jan 2022 21:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492484;
        bh=bFtqr3z8tdckz/RB4dJTJ8Y293P850XkpxoA3JT6Jio=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=V8eO5Bgu7xgONhv7QxWydBEytb3aEpaUifLaEVFtI9bzwiZmHuwSPf9O0yVnolKfL
         ZLQ7Vmj82PaE7wUJWd/yMkJgEry1VIT81t+zN+uBoGMFkmuIIIhDo0qokk1FNjva73
         hmU5mbA+rx7Nfp3jJ6Q0aA6YaN4l7xfJPtyhxqEU=
Date:   Sat, 29 Jan 2022 13:41:23 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        gautham.ananthakrishna@oracle.com, gechangwei@live.cn,
        ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        saeed.mirzamohammadi@oracle.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, tytso@mit.edu
Subject:  [patch 11/12] jbd2: export
 jbd2_journal_[grab|put]_journal_head
Message-ID: <20220129214123.z8JOI6u8G%akpm@linux-foundation.org>
In-Reply-To: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: jbd2: export jbd2_journal_[grab|put]_journal_head

Patch series "ocfs2: fix a deadlock case".

This fixes a deadlock case in ocfs2.  We firstly export jbd2 symbols
jbd2_journal_[grab|put]_journal_head as preparation and later use them in
ocfs2 insread of jbd_[lock|unlock]_bh_journal_head to fix the deadlock.


This patch (of 2):

This exports symbols jbd2_journal_[grab|put]_journal_head, which will be
used outside modules, e.g. ocfs2.

Link: https://lkml.kernel.org/r/20220121071205.100648-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Cc: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/jbd2/journal.c~jbd2-export-jbd2_journal__journal_head
+++ a/fs/jbd2/journal.c
@@ -2972,6 +2972,7 @@ struct journal_head *jbd2_journal_grab_j
 	jbd_unlock_bh_journal_head(bh);
 	return jh;
 }
+EXPORT_SYMBOL(jbd2_journal_grab_journal_head);
 
 static void __journal_remove_journal_head(struct buffer_head *bh)
 {
@@ -3024,6 +3025,7 @@ void jbd2_journal_put_journal_head(struc
 		jbd_unlock_bh_journal_head(bh);
 	}
 }
+EXPORT_SYMBOL(jbd2_journal_put_journal_head);
 
 /*
  * Initialize jbd inode head
_
