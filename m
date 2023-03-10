Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CFF6B42FE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjCJOJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbjCJOJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:09:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB131719
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:08:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 296DCB822DA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968B0C433D2;
        Fri, 10 Mar 2023 14:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457286;
        bh=Ee1y8A6nDfdqR+9Rsyrbw+XNkkE5/pHUDG8G7vgpae0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2UphsAEnBQ5pi5cgGN6c3fvnKnipRNn2bCnIPuq3FEgxAJ0nRD5FprGtf1TLXGkG
         ZzP1BXA1sObO0PJwmTY2UVQu+H5nqfl0ZpKJTPst7+k8adIgEiCf59uxFOyqbIEC49
         aYD545U4Pj0fvDW8Ve/GSvzSoRGPc+O7WyD7Yf6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Yi <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/200] ext4: fix incorrect options show of original mount_opt and extend mount_opt2
Date:   Fri, 10 Mar 2023 14:38:11 +0100
Message-Id: <20230310133719.685191770@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit e3645d72f8865ffe36f9dc811540d40aa3c848d3 ]

Current _ext4_show_options() do not distinguish MOPT_2 flag, so it mixed
extend sbi->s_mount_opt2 options with sbi->s_mount_opt, it could lead to
show incorrect options, e.g. show fc_debug_force if we mount with
errors=continue mode and miss it if we set.

  $ mkfs.ext4 /dev/pmem0
  $ mount -o errors=remount-ro /dev/pmem0 /mnt
  $ cat /proc/fs/ext4/pmem0/options | grep fc_debug_force
    #empty
  $ mount -o remount,errors=continue /mnt
  $ cat /proc/fs/ext4/pmem0/options | grep fc_debug_force
    fc_debug_force
  $ mount -o remount,errors=remount-ro,fc_debug_force /mnt
  $ cat /proc/fs/ext4/pmem0/options | grep fc_debug_force
    #empty

Fixes: 995a3ed67fc8 ("ext4: add fast_commit feature and handling for extended mount options")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230129034939.3702550-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/super.c | 28 +++++++++++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4e739902dc03a..a2bc440743ae4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1529,6 +1529,7 @@ struct ext4_sb_info {
 	unsigned int s_mount_opt2;
 	unsigned long s_mount_flags;
 	unsigned int s_def_mount_opt;
+	unsigned int s_def_mount_opt2;
 	ext4_fsblk_t s_sb_block;
 	atomic64_t s_resv_clusters;
 	kuid_t s_resuid;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 22ddd89c868aa..8011600999586 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2894,7 +2894,7 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	int def_errors, def_mount_opt = sbi->s_def_mount_opt;
+	int def_errors;
 	const struct mount_opts *m;
 	char sep = nodefs ? '\n' : ',';
 
@@ -2906,15 +2906,28 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 
 	for (m = ext4_mount_opts; m->token != Opt_err; m++) {
 		int want_set = m->flags & MOPT_SET;
+		int opt_2 = m->flags & MOPT_2;
+		unsigned int mount_opt, def_mount_opt;
+
 		if (((m->flags & (MOPT_SET|MOPT_CLEAR)) == 0) ||
 		    m->flags & MOPT_SKIP)
 			continue;
-		if (!nodefs && !(m->mount_opt & (sbi->s_mount_opt ^ def_mount_opt)))
-			continue; /* skip if same as the default */
+
+		if (opt_2) {
+			mount_opt = sbi->s_mount_opt2;
+			def_mount_opt = sbi->s_def_mount_opt2;
+		} else {
+			mount_opt = sbi->s_mount_opt;
+			def_mount_opt = sbi->s_def_mount_opt;
+		}
+		/* skip if same as the default */
+		if (!nodefs && !(m->mount_opt & (mount_opt ^ def_mount_opt)))
+			continue;
+		/* select Opt_noFoo vs Opt_Foo */
 		if ((want_set &&
-		     (sbi->s_mount_opt & m->mount_opt) != m->mount_opt) ||
-		    (!want_set && (sbi->s_mount_opt & m->mount_opt)))
-			continue; /* select Opt_noFoo vs Opt_Foo */
+		     (mount_opt & m->mount_opt) != m->mount_opt) ||
+		    (!want_set && (mount_opt & m->mount_opt)))
+			continue;
 		SEQ_OPTS_PRINT("%s", token2str(m->token));
 	}
 
@@ -2942,7 +2955,7 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 	if (nodefs || sbi->s_stripe)
 		SEQ_OPTS_PRINT("stripe=%lu", sbi->s_stripe);
 	if (nodefs || EXT4_MOUNT_DATA_FLAGS &
-			(sbi->s_mount_opt ^ def_mount_opt)) {
+			(sbi->s_mount_opt ^ sbi->s_def_mount_opt)) {
 		if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 			SEQ_OPTS_PUTS("data=journal");
 		else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
@@ -5087,6 +5100,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		goto failed_mount;
 
 	sbi->s_def_mount_opt = sbi->s_mount_opt;
+	sbi->s_def_mount_opt2 = sbi->s_mount_opt2;
 
 	err = ext4_check_opt_consistency(fc, sb);
 	if (err < 0)
-- 
2.39.2



