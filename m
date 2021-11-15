Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680614516D1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 22:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349007AbhKOVqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 16:46:04 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:53497 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347554AbhKOVpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 16:45:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1637012535; x=1668548535;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=pqbCtQijo7ZvG7ww9bOqA65CvhjNzDwMAa0KdPGQFTI=;
  b=dJ0fE2x9Jhgjpu1WtqH7nJGxgxAQzgmikUBfhJlptpRkV5uvlECFt4k6
   iOOHCQ3WOMg0bymEWpYM5C4TZHcZcpVSgcroJAV82wgHdYE/zMJm+d8tC
   iJrI+CMiaR9Af8SGwrh1ImJfjctsHG0uAOW2MlEUGIkdQfuEoCZrsW/Ec
   M=;
X-IronPort-AV: E=Sophos;i="5.87,237,1631577600"; 
   d="scan'208";a="174161695"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 15 Nov 2021 21:42:14 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com (Postfix) with ESMTPS id 2E4C91414FA
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 21:42:13 +0000 (UTC)
Received: from EX13D46UWB004.ant.amazon.com (10.43.161.204) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 15 Nov 2021 21:42:13 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D46UWB004.ant.amazon.com (10.43.161.204) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 15 Nov 2021 21:42:13 +0000
Received: from dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (172.22.152.76)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Mon, 15 Nov 2021 21:42:12 +0000
Received: by dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (Postfix, from userid 13116433)
        id 5C72842867; Mon, 15 Nov 2021 21:42:12 +0000 (UTC)
Date:   Mon, 15 Nov 2021 21:42:12 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <shaoyi@amazon.com>
Subject: [PATCH 5.4] ext4: fix lazy initialization next schedule time
 computation in more granular unit
Message-ID: <20211115214212.GA18940@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 39fec6889d15a658c3a3ebb06fd69d3584ddffd3 upstream.

Ext4 file system has default lazy inode table initialization setup once
it is mounted. However, it has issue on computing the next schedule time
that makes the timeout same amount in jiffies but different real time in
secs if with various HZ values. Therefore, fix by measuring the current
time in a more granular unit nanoseconds and make the next schedule time
independent of the HZ value.

Fixes: bfff68738f1c ("ext4: add support for lazy inode table initialization")
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210902164412.9994-2-shaoyi@amazon.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
Member lr_sbi was removed from the struct ext4_li_request since kernel 5.9 
so the way to access s_li_wait_mult was also changed. To adapt to the old 
kernel versions, adjust the upstream fix by following the old ext4_li_request
strucutre. 

 fs/ext4/super.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1211ae203fac..f68dfef5939f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3071,8 +3071,8 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 	struct ext4_group_desc *gdp = NULL;
 	ext4_group_t group, ngroups;
 	struct super_block *sb;
-	unsigned long timeout = 0;
 	int ret = 0;
+	u64 start_time;
 
 	sb = elr->lr_super;
 	ngroups = EXT4_SB(sb)->s_groups_count;
@@ -3092,13 +3092,12 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 		ret = 1;
 
 	if (!ret) {
-		timeout = jiffies;
+		start_time = ktime_get_real_ns();
 		ret = ext4_init_inode_table(sb, group,
 					    elr->lr_timeout ? 0 : 1);
 		if (elr->lr_timeout == 0) {
-			timeout = (jiffies - timeout) *
-				  elr->lr_sbi->s_li_wait_mult;
-			elr->lr_timeout = timeout;
+			elr->lr_timeout = nsecs_to_jiffies((ktime_get_real_ns() - start_time) *
+				  elr->lr_sbi->s_li_wait_mult);
 		}
 		elr->lr_next_sched = jiffies + elr->lr_timeout;
 		elr->lr_next_group = group + 1;
-- 
2.16.6

