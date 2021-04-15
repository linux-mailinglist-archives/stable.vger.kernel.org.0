Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8629360DB3
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbhDOPF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234221AbhDOPB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4095613CF;
        Thu, 15 Apr 2021 14:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498650;
        bh=hYo45/K5k5JyentpGHqkeTjJxnhdksr8oqUsJWKSy8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJNLAmDiR2LW3Yirvc9IveBdhGdXUBcWN4Hm0m/hWw8/coMwDtI1a52aDSHEdW4g2
         KaHDetaBfxC9EtKsXnV9JZ5hD6lvF9GBRndUKvRcMt9s6/bNf/XdrNID6KT76mW4oE
         AgBZUeUsWs6i21l+ijulqO3znWNyViwoZbT6wQDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Andrew Price <anprice@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/25] gfs2: Flag a withdraw if init_threads() fails
Date:   Thu, 15 Apr 2021 16:47:56 +0200
Message-Id: <20210415144413.242862151@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Price <anprice@redhat.com>

[ Upstream commit 62dd0f98a0e5668424270b47a0c2e973795faba7 ]

Interrupting mount with ^C quickly enough can cause the kthread_run()
calls in gfs2's init_threads() to fail and the error path leads to a
deadlock on the s_umount rwsem. The abridged chain of events is:

  [mount path]
  get_tree_bdev()
    sget_fc()
      alloc_super()
        down_write_nested(&s->s_umount, SINGLE_DEPTH_NESTING); [acquired]
    gfs2_fill_super()
      gfs2_make_fs_rw()
        init_threads()
          kthread_run()
            ( Interrupted )
      [Error path]
      gfs2_gl_hash_clear()
        flush_workqueue(glock_workqueue)
          wait_for_completion()

  [workqueue context]
  glock_work_func()
    run_queue()
      do_xmote()
        freeze_go_sync()
          freeze_super()
            down_write(&sb->s_umount) [deadlock]

In freeze_go_sync() there is a gfs2_withdrawn() check that we can use to
make sure freeze_super() is not called in the error path, so add a
gfs2_withdraw_delayed() call when init_threads() fails.

Ref: https://bugzilla.kernel.org/show_bug.cgi?id=212231

Reported-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index ddd40c96f7a2..0581612dd91e 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -169,8 +169,10 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	int error;
 
 	error = init_threads(sdp);
-	if (error)
+	if (error) {
+		gfs2_withdraw_delayed(sdp);
 		return error;
+	}
 
 	j_gl->gl_ops->go_inval(j_gl, DIO_METADATA);
 	if (gfs2_withdrawn(sdp)) {
-- 
2.30.2



