Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF435150B06
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgBCQUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:20:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728938AbgBCQUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:20:38 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 853072087E;
        Mon,  3 Feb 2020 16:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580746838;
        bh=EdMuJ7yqmWC4R5RIM0NDeWZslstOXQIvTHoX46Q3MjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jn+9lTLZ/5lCq+OrZoJIncZt23KHywNd5VyXLjjdDlh2YVPtUnsHz26IJY9+ayZG5
         K9LavSdedUt3BAv+E+3fAZVlxDzqcBBXOpAD0q6sm2NdyYDEQlEVf51dncwIcnI9oX
         z+qXJhMIzCpGiDbAORNn0/AzcBgQaD3/doNfOelk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1c6756baf4b16b94d2a6@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4.4 27/53] reiserfs: Fix memory leak of journal device string
Date:   Mon,  3 Feb 2020 16:19:19 +0000
Message-Id: <20200203161908.058528884@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
References: <20200203161902.714326084@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 5474ca7da6f34fa95e82edc747d5faa19cbdfb5c upstream.

When a filesystem is mounted with jdev mount option, we store the
journal device name in an allocated string in superblock. However we
fail to ever free that string. Fix it.

Reported-by: syzbot+1c6756baf4b16b94d2a6@syzkaller.appspotmail.com
Fixes: c3aa077648e1 ("reiserfs: Properly display mount options in /proc/mounts")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -599,6 +599,7 @@ static void reiserfs_put_super(struct su
 	reiserfs_write_unlock(s);
 	mutex_destroy(&REISERFS_SB(s)->lock);
 	destroy_workqueue(REISERFS_SB(s)->commit_wq);
+	kfree(REISERFS_SB(s)->s_jdev);
 	kfree(s->s_fs_info);
 	s->s_fs_info = NULL;
 }
@@ -2208,6 +2209,7 @@ error_unlocked:
 			kfree(qf_names[j]);
 	}
 #endif
+	kfree(sbi->s_jdev);
 	kfree(sbi);
 
 	s->s_fs_info = NULL;


