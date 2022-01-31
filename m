Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0DA4A4348
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378720AbiAaLUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349721AbiAaLQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:16:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877C0C0613F7;
        Mon, 31 Jan 2022 03:11:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50E35B82A61;
        Mon, 31 Jan 2022 11:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EC0C340E8;
        Mon, 31 Jan 2022 11:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627486;
        bh=JhNyRXEnciQM5KD9GQGTUIzpN68e3QP+BIvXRa1scdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwUxm9owMBPx3WbWipqncC9XysHutlQIXkyMiLFPxMAuEzLKaMejTCL/XiqNxGQ1z
         5YkKOatEsQ7vcD9Z6+hpIIpGLi2lo/AgFBpyRsgyKBrcpw9XOY/LcRWqV2+nU8YCs4
         Vjq/63JyswANaB1kAlnEG3MfgNKzcCn5e3fqSRHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        "Theodore Tso" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 066/171] jbd2: export jbd2_journal_[grab|put]_journal_head
Date:   Mon, 31 Jan 2022 11:55:31 +0100
Message-Id: <20220131105232.273781500@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 4cd1103d8c66b2cdb7e64385c274edb0ac5e8887 upstream.

Patch series "ocfs2: fix a deadlock case".

This fixes a deadlock case in ocfs2.  We firstly export jbd2 symbols
jbd2_journal_[grab|put]_journal_head as preparation and later use them
in ocfs2 insread of jbd_[lock|unlock]_bh_journal_head to fix the
deadlock.

This patch (of 2):

This exports symbols jbd2_journal_[grab|put]_journal_head, which will be
used outside modules, e.g.  ocfs2.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2970,6 +2970,7 @@ struct journal_head *jbd2_journal_grab_j
 	jbd_unlock_bh_journal_head(bh);
 	return jh;
 }
+EXPORT_SYMBOL(jbd2_journal_grab_journal_head);
 
 static void __journal_remove_journal_head(struct buffer_head *bh)
 {
@@ -3022,6 +3023,7 @@ void jbd2_journal_put_journal_head(struc
 		jbd_unlock_bh_journal_head(bh);
 	}
 }
+EXPORT_SYMBOL(jbd2_journal_put_journal_head);
 
 /*
  * Initialize jbd inode head


