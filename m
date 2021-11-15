Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7314524E7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357565AbhKPBqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241472AbhKOSUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:20:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09F7A63406;
        Mon, 15 Nov 2021 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998750;
        bh=fEbnSOt5Pcq/vKuqfP50KBU9MhAd2dD/dmkkqbh8vbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lf2cAA7DO4wsHtsyvRjKlGJDqcFsbSSu1hvnU781KhOzQh46sFSlHBh1W/z/xNi5D
         BIkm2l1Ofz12W2HaEIzHMScZSFYGIov2fQLM3q7lU9tj8M54OW5EWH6escwdW7hM9N
         GhiWl45YftZxCH+2R0VUzQh81Fub2XX6NucpGXLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaoying Xu <shaoyi@amazon.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.14 048/849] ext4: fix lazy initialization next schedule time computation in more granular unit
Date:   Mon, 15 Nov 2021 17:52:11 +0100
Message-Id: <20211115165421.634877863@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
@@ -3427,9 +3427,9 @@ static int ext4_run_li_request(struct ex
 	struct super_block *sb = elr->lr_super;
 	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
 	ext4_group_t group = elr->lr_next_group;
-	unsigned long timeout = 0;
 	unsigned int prefetch_ios = 0;
 	int ret = 0;
+	u64 start_time;
 
 	if (elr->lr_mode == EXT4_LI_MODE_PREFETCH_BBITMAP) {
 		elr->lr_next_group = ext4_mb_prefetch(sb, group,
@@ -3466,14 +3466,13 @@ static int ext4_run_li_request(struct ex
 		ret = 1;
 
 	if (!ret) {
-		timeout = jiffies;
+		start_time = ktime_get_real_ns();
 		ret = ext4_init_inode_table(sb, group,
 					    elr->lr_timeout ? 0 : 1);
 		trace_ext4_lazy_itable_init(sb, group);
 		if (elr->lr_timeout == 0) {
-			timeout = (jiffies - timeout) *
-				EXT4_SB(elr->lr_super)->s_li_wait_mult;
-			elr->lr_timeout = timeout;
+			elr->lr_timeout = nsecs_to_jiffies((ktime_get_real_ns() - start_time) *
+				EXT4_SB(elr->lr_super)->s_li_wait_mult);
 		}
 		elr->lr_next_sched = jiffies + elr->lr_timeout;
 		elr->lr_next_group = group + 1;


