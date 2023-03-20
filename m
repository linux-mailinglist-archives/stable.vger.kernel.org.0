Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D326C17B8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjCTPQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbjCTPQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4335130E90
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FD9C615A1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08C9C433D2;
        Mon, 20 Mar 2023 15:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325092;
        bh=H86i0pfEXKyVRTLsGvt2vGQ3Xc0J3lDRY8JaftqgaI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2oeQNlNG4EjjFV0DEjKI2vNDTrUy5YwZWGQX7fP2qOL/VQvbCRplMIdB1e8p5L43d
         BQAZMSoXwZMPsuBGCiGssCLkPV+ihj0dcGRIdt/tp9qsrErW/91gD1OPU7R5P6AwaB
         Hi9/xEtgHFuA1O1rZpnsRT6oc+DLo+rdAr/WJZ8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Baokun Li <libaokun1@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/115] ext4: update s_journal_inum if it changes after journal replay
Date:   Mon, 20 Mar 2023 15:54:39 +0100
Message-Id: <20230320145452.221260026@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



