Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E215E4DEE
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394757AbfJYN47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394748AbfJYN47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:56:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 603DA222BD;
        Fri, 25 Oct 2019 13:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011818;
        bh=4FHOxC6pqpm6oT3yQASFq8lb6G3bbj8VfuKwrmRl9U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fma8qiktMWbvOdt9cTdube+DU4Vvk8ssNpNek84xUtG6/s0CA5nOOpq1vfFdiR6hJ
         gdp/dtugh0YWElB7+iTjs/S7ApNAVR/CQLncZ0d1jdIB/xoWfYTpjs3GwV7aC0Kyj2
         dBt7zI+vCtuFxsXJTqwSy8fwtGW6krYO6QoLD5b0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 29/37] jbd2: flush_descriptor(): Do not decrease buffer head's ref count
Date:   Fri, 25 Oct 2019 09:55:53 -0400
Message-Id: <20191025135603.25093-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandan Rajendra <chandan@linux.ibm.com>

[ Upstream commit 547b9ad698b434eadca46319cb47e5875b55ef03 ]

When executing generic/388 on a ppc64le machine, we notice the following
call trace,

VFS: brelse: Trying to free free buffer
WARNING: CPU: 0 PID: 6637 at /root/repos/linux/fs/buffer.c:1195 __brelse+0x84/0xc0

Call Trace:
 __brelse+0x80/0xc0 (unreliable)
 invalidate_bh_lru+0x78/0xc0
 on_each_cpu_mask+0xa8/0x130
 on_each_cpu_cond_mask+0x130/0x170
 invalidate_bh_lrus+0x44/0x60
 invalidate_bdev+0x38/0x70
 ext4_put_super+0x294/0x560
 generic_shutdown_super+0xb0/0x170
 kill_block_super+0x38/0xb0
 deactivate_locked_super+0xa4/0xf0
 cleanup_mnt+0x164/0x1d0
 task_work_run+0x110/0x160
 do_notify_resume+0x414/0x460
 ret_from_except_lite+0x70/0x74

The warning happens because flush_descriptor() drops bh reference it
does not own. The bh reference acquired by
jbd2_journal_get_descriptor_buffer() is owned by the log_bufs list and
gets released when this list is processed. The reference for doing IO is
only acquired in write_dirty_buffer() later in flush_descriptor().

Reported-by: Harish Sriram <harish@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/revoke.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 69b9bc329964f..f08073d7bbf57 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -638,10 +638,8 @@ static void flush_descriptor(journal_t *journal,
 {
 	jbd2_journal_revoke_header_t *header;
 
-	if (is_journal_aborted(journal)) {
-		put_bh(descriptor);
+	if (is_journal_aborted(journal))
 		return;
-	}
 
 	header = (jbd2_journal_revoke_header_t *)descriptor->b_data;
 	header->r_count = cpu_to_be32(offset);
-- 
2.20.1

