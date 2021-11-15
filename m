Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137D4451EB3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355240AbhKPAhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344937AbhKOTZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8FED633F6;
        Mon, 15 Nov 2021 19:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003240;
        bh=6f4VUdBvd8lHtxHTCQk1LctYvu4r1mLYmhfa68VAWWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuHfAT9yd/281M60xToNlQWx7zmGtrhvoOt++yp75ef4RDdOPYr59+NNyFK9qtiVT
         O7JSBmg2xMRnuDjy+79KIpLxraj6k3rnO2+pFuXDT9bVAEWf44b3LFS+EKykdWOXsx
         e/XegZpbRTTaErqFQ0x92D8tjd2roVuJUyZRxcuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 862/917] f2fs: fix UAF in f2fs_available_free_memory
Date:   Mon, 15 Nov 2021 18:05:57 +0100
Message-Id: <20211115165458.258912088@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit 5429c9dbc9025f9a166f64e22e3a69c94fd5b29b upstream.

if2fs_fill_super
-> f2fs_build_segment_manager
   -> create_discard_cmd_control
      -> f2fs_start_discard_thread

It invokes kthread_run to create a thread and run issue_discard_thread.

However, if f2fs_build_node_manager fails, the control flow goes to
free_nm and calls f2fs_destroy_node_manager. This function will free
sbi->nm_info. However, if issue_discard_thread accesses sbi->nm_info
after the deallocation, but before the f2fs_stop_discard_thread, it will
cause UAF(Use-after-free).

-> f2fs_destroy_segment_manager
   -> destroy_discard_cmd_control
      -> f2fs_stop_discard_thread

Fix this by stopping discard thread before f2fs_destroy_node_manager.

Note that, the commit d6d2b491a82e1 introduces the call of
f2fs_available_free_memory into issue_discard_thread.

Cc: stable@vger.kernel.org
Fixes: d6d2b491a82e ("f2fs: allow to change discard policy based on cached discard cmds")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4352,6 +4352,8 @@ free_node_inode:
 free_stats:
 	f2fs_destroy_stats(sbi);
 free_nm:
+	/* stop discard thread before destroying node manager */
+	f2fs_stop_discard_thread(sbi);
 	f2fs_destroy_node_manager(sbi);
 free_sm:
 	f2fs_destroy_segment_manager(sbi);


