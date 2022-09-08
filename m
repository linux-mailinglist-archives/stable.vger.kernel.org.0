Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA935B188A
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 11:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiIHJXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 05:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiIHJXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 05:23:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF9BE1272;
        Thu,  8 Sep 2022 02:21:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C1BB333C1E;
        Thu,  8 Sep 2022 09:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662628896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTIu5g1ARjVeLQJtVEzb05xchksISn6WKWVZuhNYsXg=;
        b=SSzznqIIRfcYlw6A7Cwn98kUCioGK/RDf6uSIrDqvyUZHRYc7/Oi9qpBruzhXiZGxytAqY
        VO4F0Ux4Jr8msYYnShVSpBnsuriXbG36C56qP8StND6P/j+2WsADVYsNqvn/wFTSoMO/Vi
        yRMWxIagdS55Zhp2wkaYskBIj9c7cEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662628896;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTIu5g1ARjVeLQJtVEzb05xchksISn6WKWVZuhNYsXg=;
        b=FkDqDKxBCQNBNLUyGpoWZ89NqCyR9Zdnu9Duv608sGYsSTMmFe3QF05QYO09E5bRjBzDdy
        YipkgDpavOJHAGBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B38A613A6D;
        Thu,  8 Sep 2022 09:21:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Sr85KyC0GWOxRAAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 08 Sep 2022 09:21:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 1690CA0682; Thu,  8 Sep 2022 11:21:36 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCH 2/5] ext4: Avoid unnecessary spreading of allocations among groups
Date:   Thu,  8 Sep 2022 11:21:25 +0200
Message-Id: <20220908092136.11770-2-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220908091301.147-1-jack@suse.cz>
References: <20220908091301.147-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2504; h=from:subject; bh=k7AJpELkbpX88tci6pp+mS3j4X4Sqvl1FyFZXO/4+i8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjGbQUZm3QrW9BFTtpkv6HTcPbBJfWMNIlvzLdMAi6 si70bXmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYxm0FAAKCRCcnaoHP2RA2QIqB/ 9T0I1UEO0EZOU7x0ou7D7tp/7ccdWqnYsigNWkNqWehhxeNcRFWIHcWO/Iszv0QRz5j+e0qKB7I81X ToQQUrEDn93MtFIQL6XT/P35ZyKm/IifBfkmm1V6pw7JzeRdMCJ0ScVF2rHY/m7azgAUqr+rg+hp7c ZQgIpup0JhTcbEgVMW5hGFnF4ZHly81TPqjIjo5qS2fAPFhgWxP17CYpJTUcy+gy/vO2PU9zM6oPZu zmjOAMGMYWzNyIlaC3rt7MoYWCZiwMDGt3Y1MG267DKdSWtEvTOPjbSVduHMHQvnZ4ojnnm2pLDUM/ 9FB5vM8A5mrlkwfPOwJFxFcUSdk0/m
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

mb_set_largest_free_order() updates lists containing groups with largest
chunk of free space of given order. The way it updates it leads to
always moving the group to the tail of the list. Thus allocations
looking for free space of given order effectively end up cycling through
all groups (and due to initialization in last to first order). This
spreads allocations among block groups which reduces performance for
rotating disks or low-end flash media. Change
mb_set_largest_free_order() to only update lists if the order of the
largest free chunk in the group changed.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
CC: stable@vger.kernel.org
Reported-and-tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 41e1cfecac3b..6251b4a6cc63 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1077,23 +1077,25 @@ mb_set_largest_free_order(struct super_block *sb, struct ext4_group_info *grp)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int i;
 
-	if (test_opt2(sb, MB_OPTIMIZE_SCAN) && grp->bb_largest_free_order >= 0) {
+	for (i = MB_NUM_ORDERS(sb) - 1; i >= 0; i--)
+		if (grp->bb_counters[i] > 0)
+			break;
+	/* No need to move between order lists? */
+	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) ||
+	    i == grp->bb_largest_free_order) {
+		grp->bb_largest_free_order = i;
+		return;
+	}
+
+	if (grp->bb_largest_free_order >= 0) {
 		write_lock(&sbi->s_mb_largest_free_orders_locks[
 					      grp->bb_largest_free_order]);
 		list_del_init(&grp->bb_largest_free_order_node);
 		write_unlock(&sbi->s_mb_largest_free_orders_locks[
 					      grp->bb_largest_free_order]);
 	}
-	grp->bb_largest_free_order = -1; /* uninit */
-
-	for (i = MB_NUM_ORDERS(sb) - 1; i >= 0; i--) {
-		if (grp->bb_counters[i] > 0) {
-			grp->bb_largest_free_order = i;
-			break;
-		}
-	}
-	if (test_opt2(sb, MB_OPTIMIZE_SCAN) &&
-	    grp->bb_largest_free_order >= 0 && grp->bb_free) {
+	grp->bb_largest_free_order = i;
+	if (grp->bb_largest_free_order >= 0 && grp->bb_free) {
 		write_lock(&sbi->s_mb_largest_free_orders_locks[
 					      grp->bb_largest_free_order]);
 		list_add_tail(&grp->bb_largest_free_order_node,
-- 
2.35.3

