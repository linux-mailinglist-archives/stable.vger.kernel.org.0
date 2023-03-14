Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C22F6B947C
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjCNMqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjCNMpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:45:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C148AA18B2;
        Tue, 14 Mar 2023 05:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C78F0B81908;
        Tue, 14 Mar 2023 12:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953EFC433EF;
        Tue, 14 Mar 2023 12:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797814;
        bh=Hv7uNwv1335ZkhvGONfKBtSAlwto6F95Sx8jlnD/bHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2nUE/cNwrE9B6AEcfHF5BTw5vR2JrLF0tKyxgBnqw6azZfAKjbjDPG3nYGGfyATY
         +W2rpz+JAklFipeij/qZ3kdIK9CPbR3nesmktlQ05NfhES9i39HVbGs3cuhwy1TA6U
         BDX1mylVd7BIVVo2WyMnY0+MwyMZMOdOAxoocKgk4xeZwZ3cG4qkemGmNP5kKDdBzg
         pmupwM9lsZ7c+DTPEDzNw7TqZPcmXI48IkHYf1T77+uDAOsHkn59VQiLq3Z/yxygY8
         KnfkhdY9+Ik3NmGx3K83yEPaFOvr7s20HVma+N7YQ2Q+vNJdX/BzEn4PI09M6+h4EG
         JW60xZRvLb/QA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baokun Li <libaokun1@huawei.com>,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/13] ext4: update s_journal_inum if it changes after journal replay
Date:   Tue, 14 Mar 2023 08:43:18 -0400
Message-Id: <20230314124325.470931-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124325.470931-1-sashal@kernel.org>
References: <20230314124325.470931-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 8011600999586..2528e8216c334 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5967,8 +5967,11 @@ static int ext4_load_journal(struct super_block *sb,
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

