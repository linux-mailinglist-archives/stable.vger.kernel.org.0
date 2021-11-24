Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB5445BE4B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243959AbhKXMqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:46:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345745AbhKXMoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:44:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 545C761414;
        Wed, 24 Nov 2021 12:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756765;
        bh=HLFGrcMjV97T3iyLXp9wtvnYcM1bCXkP25NWyU2//2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hG8F9NMI0eon8OUt6nmog1g9pMO/QlsK/9Y1aLX/FKPZGqh9gaBFvg0siN4AL+l3Q
         7rfvMVgnQGYhs/87y2DA988Js9YhTdYNRtyeRRbfW9eNixDovWy+mvTvBTBkFzxc6u
         4WZoxCQnAgmgGmJJcPIWjL5F7/YapMzgHpX4exoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaoying Xu <shaoyi@amazon.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 198/251] ext4: fix lazy initialization next schedule time computation in more granular unit
Date:   Wed, 24 Nov 2021 12:57:20 +0100
Message-Id: <20211124115717.151357766@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaoying Xu <shaoyi@amazon.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2952,8 +2952,8 @@ static int ext4_run_li_request(struct ex
 	struct ext4_group_desc *gdp = NULL;
 	ext4_group_t group, ngroups;
 	struct super_block *sb;
-	unsigned long timeout = 0;
 	int ret = 0;
+	u64 start_time;
 
 	sb = elr->lr_super;
 	ngroups = EXT4_SB(sb)->s_groups_count;
@@ -2973,13 +2973,12 @@ static int ext4_run_li_request(struct ex
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


