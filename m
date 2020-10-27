Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F9929BF0D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814877AbgJ0RAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755361AbgJ0PIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:08:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25FE621D24;
        Tue, 27 Oct 2020 15:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811333;
        bh=i892Am8JcUqWpZVV4ZyYZjchzORclpVQquaP8i3w2To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFdUvTqIrWpyAnk61PZZCY/5ZB6JLG7OV3UsoqmGhqjVUOWgm47T+Hdew+OvTvUey
         cRK9tglmw9yxP21kCH5zXSdc1NVqwZx2U+rzDBNngPmCikS/CQhVRjollKg19EU07c
         wEq7LMLlQnX4VjL44K5lVvSL8YQtXyJC53g+VVUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Jan Kara <jack@suse.cz>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 457/633] ext4: fix dead loop in ext4_mb_new_blocks
Date:   Tue, 27 Oct 2020 14:53:20 +0100
Message-Id: <20201027135544.152034382@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 70022da804f0f3f152115688885608c39182082e ]

As we test disk offline/online with running fsstress, we find fsstress
process is keeping running state.
kworker/u32:3-262   [004] ...1   140.787471: ext4_mb_discard_preallocations: dev 8,32 needed 114
....
kworker/u32:3-262   [004] ...1   140.787471: ext4_mb_discard_preallocations: dev 8,32 needed 114

ext4_mb_new_blocks
repeat:
        ext4_mb_discard_preallocations_should_retry(sb, ac, &seq)
                freed = ext4_mb_discard_preallocations
                        ext4_mb_discard_group_preallocations
                                this_cpu_inc(discard_pa_seq);
                ---> freed == 0
                seq_retry = ext4_get_discard_pa_seq_sum
                        for_each_possible_cpu(__cpu)
                                __seq += per_cpu(discard_pa_seq, __cpu);
                if (seq_retry != *seq) {
                        *seq = seq_retry;
                        ret = true;
                }

As we see seq_retry is sum of discard_pa_seq every cpu, if
ext4_mb_discard_group_preallocations return zero discard_pa_seq in this
cpu maybe increase one, so condition "seq_retry != *seq" have always
been met.
Ritesh Harjani suggest to in ext4_mb_discard_group_preallocations function we
only increase discard_pa_seq when there is some PA to free.

Fixes: 07b5b8e1ac40 ("ext4: mballoc: introduce pcpu seqcnt for freeing PA to improve ENOSPC handling")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/20200916113859.1556397-3-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e88eff999bd15..787a894f5d1da 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4066,7 +4066,6 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 	INIT_LIST_HEAD(&list);
 repeat:
 	ext4_lock_group(sb, group);
-	this_cpu_inc(discard_pa_seq);
 	list_for_each_entry_safe(pa, tmp,
 				&grp->bb_prealloc_list, pa_group_list) {
 		spin_lock(&pa->pa_lock);
@@ -4083,6 +4082,9 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 		/* seems this one can be freed ... */
 		ext4_mb_mark_pa_deleted(sb, pa);
 
+		if (!free)
+			this_cpu_inc(discard_pa_seq);
+
 		/* we can trust pa_free ... */
 		free += pa->pa_free;
 
-- 
2.25.1



