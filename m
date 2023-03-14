Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0971F6B94C5
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbjCNMtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjCNMsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:48:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA38FA4017;
        Tue, 14 Mar 2023 05:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DAA16176E;
        Tue, 14 Mar 2023 12:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0599C4339C;
        Tue, 14 Mar 2023 12:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797832;
        bh=H86i0pfEXKyVRTLsGvt2vGQ3Xc0J3lDRY8JaftqgaI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=annDt4wAtcoIhxIZJvAlkY7+5oDCBhcp5eudEV0ICziDWxidobDOl5IG/kKapv6Gd
         EK6WJbt27UssSqAKyRgx+0hiY54E1UO9OfVmCXG/hNsrHkipzM2fMu1irjJ9rIkfth
         h4DMFIDp5yH3bGEmhosS3N8S3x9W29WbgHBnITssoWp5m0FzEdB3+2VVflxVVl14KE
         OpUIxJ/XF1GfI7KOKNWqPTkgKWKHgK9jytg11tkRj/rjme1WPO3urKr5lfGA1ff1+l
         sOxPwwpkcEUOUYOVbAuulHeNyYIuDvuxKFBY8SRxC//ABmAS5QU8ajyeIjelmotkXQ
         86oW7dl4h4yIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baokun Li <libaokun1@huawei.com>,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/10] ext4: update s_journal_inum if it changes after journal replay
Date:   Tue, 14 Mar 2023 08:43:39 -0400
Message-Id: <20230314124344.471127-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124344.471127-1-sashal@kernel.org>
References: <20230314124344.471127-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 3039d8b8692408438a618fac2776b629852663c3 ]

When mounting a crafted ext4 image, s_journal_inum may change after journal
replay, which is obviously unreasonable because we have successfully loaded
and replayed the journal through the old s_journal_inum. And the new
s_journal_inum bypasses some of the checks in ext4_get_journal(), which
may trigger a null pointer dereference problem. So if s_journal_inum
changes after the journal replay, we ignore the change, and rewrite the
current journal_inum to the superblock.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216541
Reported-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230107032126.4165860-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 802ca160d31ed..6df4da084190f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5385,8 +5385,11 @@ static int ext4_load_journal(struct super_block *sb,
 	if (!really_read_only && journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
 		es->s_journal_dev = cpu_to_le32(journal_devnum);
-
-		/* Make sure we flush the recovery flag to disk. */
+		ext4_commit_super(sb);
+	}
+	if (!really_read_only && journal_inum &&
+	    journal_inum != le32_to_cpu(es->s_journal_inum)) {
+		es->s_journal_inum = cpu_to_le32(journal_inum);
 		ext4_commit_super(sb);
 	}
 
-- 
2.39.2

