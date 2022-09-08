Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF4F5B1883
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 11:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiIHJXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 05:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiIHJXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 05:23:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B37D4190;
        Thu,  8 Sep 2022 02:21:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AC5921FA59;
        Thu,  8 Sep 2022 09:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662628896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BFdL6/nO1VLnFbG0HqZd5h/ZHSiMduV/dSRQ7IXSHl4=;
        b=Qf9m6kbSjVsyMJqlHzsuEsBqavQ9uoGIoKUjJXRzLLhXkpGUX0YCprkYruCmQAYULTklK8
        m0MYUPe7EdB8/tNbo6CWYyigqOsK9BzjXIsKQDLv2ScF4/Yh2zrnCfgqCAtjsV/I1FBRwe
        f74BhSNL46bZtUG0RqLpyj/v4Dlsov0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662628896;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BFdL6/nO1VLnFbG0HqZd5h/ZHSiMduV/dSRQ7IXSHl4=;
        b=SNzTnaC9kM0yRlFRm/wVDXNnZyvMYKwwEEOzpRcu1X7pX7Oj+hJoMEOUJCyOfN5eH+Lr8H
        3TGovyInjOsKImBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9F33F13A6D;
        Thu,  8 Sep 2022 09:21:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RXHXJiC0GWOqRAAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 08 Sep 2022 09:21:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 228E4A0685; Thu,  8 Sep 2022 11:21:36 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCH 4/5] ext4: Use locality group preallocation for small closed files
Date:   Thu,  8 Sep 2022 11:21:27 +0200
Message-Id: <20220908092136.11770-4-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220908091301.147-1-jack@suse.cz>
References: <20220908091301.147-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2713; h=from:subject; bh=oJT4Qwm0EAPv5WsT8A0NaFv4D/W5/EnIQqmSj9R4dTs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjGbQWPYGkjWzbRtTjD1RxlqTqcnEkY8MdcD8nl7VN PWyvH8CJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYxm0FgAKCRCcnaoHP2RA2ZBMB/ 92B5fzS6q3BFihnXiB0W5Df4b9AgH8HfR7ixXtkKhMtltA3dmIDTuWqf0AS4mtRbUlx6XTTOulJFq1 FUTPDLqgoaLZg3vRi5fyhkYl85l59MmQc60oBGOjGFrAM9+ynPBrSqfzM3cWKK4+rPjUpQMXSQ3rhq 4YlrlPlOS8JyWS4LGNFmOeLxYICeQay9noYOZb14uotZePjfLIUKTC09JPkytIgHjfg/ATdDWmIDxs nUjq9KTcss3ZaJ3aAMxOTbtj5FyRhaQCy+LSY4b6+y9vnOoSfjxZHGV+F0Nk2W6mA0NsR7Z4wC+YB5 uPKCikbg7Yc25lvNPQcudmPKvnVt1A
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Curently we don't use any preallocation when a file is already closed
when allocating blocks (from writeback code when converting delayed
allocation). However for small files, using locality group preallocation
is actually desirable as that is not specific to a particular file.
Rather it is a method to pack small files together to reduce
fragmentation and for that the fact the file is closed is actually even
stronger hint the file would benefit from packing. So change the logic
to allow locality group preallocation in this case.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
CC: stable@vger.kernel.org
Reported-and-tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6251b4a6cc63..af1e49c3603f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5195,6 +5195,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	int bsbits = ac->ac_sb->s_blocksize_bits;
 	loff_t size, isize;
+	bool inode_pa_eligible, group_pa_eligible;
 
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return;
@@ -5202,25 +5203,27 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
 		return;
 
+	group_pa_eligible = sbi->s_mb_group_prealloc > 0;
+	inode_pa_eligible = true;
 	size = ac->ac_o_ex.fe_logical + EXT4_C2B(sbi, ac->ac_o_ex.fe_len);
 	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
 		>> bsbits;
 
+	/* No point in using inode preallocation for closed files */
 	if ((size == isize) && !ext4_fs_is_busy(sbi) &&
-	    !inode_is_open_for_write(ac->ac_inode)) {
-		ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;
-		return;
-	}
+	    !inode_is_open_for_write(ac->ac_inode))
+		inode_pa_eligible = false;
 
-	if (sbi->s_mb_group_prealloc <= 0) {
-		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
-		return;
-	}
-
-	/* don't use group allocation for large files */
 	size = max(size, isize);
-	if (size > sbi->s_mb_stream_request) {
-		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
+	/* Don't use group allocation for large files */
+	if (size > sbi->s_mb_stream_request)
+		group_pa_eligible = false;
+
+	if (!group_pa_eligible) {
+		if (inode_pa_eligible)
+			ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
+		else
+			ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;
 		return;
 	}
 
-- 
2.35.3

