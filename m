Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46181682012
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 00:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjA3Xwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 18:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjA3Xwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 18:52:36 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D55E2F7BF
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 15:52:35 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id a18-20020a62bd12000000b0056e7b61ec78so6194936pff.17
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 15:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bjp+KKEOnhzbgB8kmAf1T1EGrTfC2MuzBSYSlw19yMA=;
        b=kRRbFm4SHDA4vd7IGm685cCR9D16EDzuuBovNteeMrCUaGh+pJvF+N6uCP+Bbat3MG
         ruVeKMg7yhd+upZR7IbUU7dPdMRyMednVxWjospLzP6T7rXYl//ASPnzCdULEFTQTSWO
         6t5m9TEcgcVYDKcgdSvB6onM4sKl3sG084Libed7FTIqNRD8RB9BdXjKFx0m4EO+K4U/
         klmDWCSjSQoQyU/3pcZSgNehSoePM0Rv+ToWJ6LB9zeNT7SKTqaaic4ClKR7O0ctOYIe
         0YdUAlFQ7T/6RZy1AWE8ItJcDhhkhyGmt6sStCeJF09QG7tk9x2MhPXN0tYCbOO5/pDw
         j33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bjp+KKEOnhzbgB8kmAf1T1EGrTfC2MuzBSYSlw19yMA=;
        b=rlQYycm9qanMVcM5fiKkTvOaA94HVWVEpd867ScU0DSXaAfkMkwNHIIb6vLocKJN5x
         UNiyrFARw1MaIrTg2R6js0K1TeuPp/Eg99lRzfqM4LpilCd7B123e+V9wUUiaIraDcL5
         8dl5bTgOJrE+Ju2WWkyFMtn6UIQb9ePuJZrVLWJXhDuTabvfBhw22NJz5Ho1SZL8R0cz
         8ykF9N3PMZ5ri/rvkgmfRtAQBbEcTdzgepETRpWIrbLc7GQjY4w8GhaS5HDM1muoZdfX
         vkY/XkaG06n8CeaaxPzK3u132rmkM89e3QSAqQ9+I8zxkbwAPn/kn22i9HVcGQeB4y7o
         uC0w==
X-Gm-Message-State: AO0yUKXHro8GgJPUB/z+yjOFQPqEY979SlXv1LN3HywGMYFkpp28ohJm
        pId6PP5ogb8c3h9HHdVSlMx4KCGPLHyI+WLs9zOngkkQV1gwAxTNyv/givqc0HMziminvKYavbM
        6ag3hGEMEbSsfO0RuqNbuLNefMy491m7x37YLokB7Uvhzq9CDp/F66Q==
X-Google-Smtp-Source: AK7set9akpsvZ1QbfbOpOEz3inaHaVE86NrDuxXoNa9GkhxBr6Aav5E64SrrxIm66XAHsVJex9MKGhs=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a17:903:2342:b0:196:8445:56d5 with SMTP id
 c2-20020a170903234200b00196844556d5mr937382plh.13.1675122754760; Mon, 30 Jan
 2023 15:52:34 -0800 (PST)
Date:   Mon, 30 Jan 2023 23:52:12 +0000
In-Reply-To: <20230130235212.698665-1-ovt@google.com>
Mime-Version: 1.0
References: <20230130235212.698665-1-ovt@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230130235212.698665-2-ovt@google.com>
Subject: [PATCH 5.15 v2 1/1] ext4: fix bad checksum after online resize
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     stable@vger.kernel.org
Cc:     Baokun Li <libaokun1@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        stable@kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Oleksandr Tymoshenko <ovt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit a408f33e895e455f16cf964cb5cd4979b658db7b upstream.

When online resizing is performed twice consecutively, the error message
"Superblock checksum does not match superblock" is displayed for the
second time. Here's the reproducer:

	mkfs.ext4 -F /dev/sdb 100M
	mount /dev/sdb /tmp/test
	resize2fs /dev/sdb 5G
	resize2fs /dev/sdb 6G

To solve this issue, we moved the update of the checksum after the
es->s_overhead_clusters is updated.

Fixes: 026d0d27c488 ("ext4: reduce computation of overhead during resize")
Fixes: de394a86658f ("ext4: update s_overhead_clusters in the superblock during an on-line resize")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221117040341.1380702-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
---
 fs/ext4/resize.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 405c68085055..589ed99856f3 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1445,8 +1445,6 @@ static void ext4_update_super(struct super_block *sb,
 	 * active. */
 	ext4_r_blocks_count_set(es, ext4_r_blocks_count(es) +
 				reserved_blocks);
-	ext4_superblock_csum_set(sb);
-	unlock_buffer(sbi->s_sbh);
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeclusters_counter,
@@ -1474,6 +1472,8 @@ static void ext4_update_super(struct super_block *sb,
 	ext4_calculate_overhead(sb);
 	es->s_overhead_clusters = cpu_to_le32(sbi->s_overhead);
 
+	ext4_superblock_csum_set(sb);
+	unlock_buffer(sbi->s_sbh);
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT4-fs: added group %u:"
 		       "%llu blocks(%llu free %llu reserved)\n", flex_gd->count,
-- 
2.39.1.456.gfc5497dd1b-goog

