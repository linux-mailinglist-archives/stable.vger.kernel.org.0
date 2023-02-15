Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6B069868A
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjBOUvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjBOUu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:50:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F7C46085;
        Wed, 15 Feb 2023 12:48:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B71EEB823BF;
        Wed, 15 Feb 2023 20:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B8AC433A1;
        Wed, 15 Feb 2023 20:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494031;
        bh=iiPK7T1EqMObnDz3nUiRtuXd2lrqrU/nX4PMSHEMI+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXY+q0EEbMyad9mSRNPG0nxFZPIenxbDse4Ss5p3Sc4/O0PLLj7qnG9Ocw5CPB4v8
         k9SD5WIu0sOtbIzT3sL3qSnBTAjDSi6WjKDpXUFP89VFRiCeNuu65KQfDvBMEkilVL
         xbpfILM7fAnfh7xL6jib4xx72QLRwXDVgnP3dd6FJ/JNhKTH39DrqOXCnI/2ezOiy1
         R3WmlURHewzOBmPD8VZNDJTkI8OiWZoEVg9G2Jk1coYfyA0kWpQvcWBHfeb6GtUzY5
         iAKQvxa/undi4+Gvv7uj1FgzFiY305IbtN3LbVx0SIuCEC1rnZsfrB1/f6XA57L1g9
         /K5c1zc8d8Gpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        syzbot+4376a9a073770c173269@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/4] btrfs: send: limit number of clones and allocated memory size
Date:   Wed, 15 Feb 2023 15:47:07 -0500
Message-Id: <20230215204708.2761432-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204708.2761432-1-sashal@kernel.org>
References: <20230215204708.2761432-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 33e17b3f5ab74af12aca58c515bc8424ff69a343 ]

The arg->clone_sources_count is u64 and can trigger a warning when a
huge value is passed from user space and a huge array is allocated.
Limit the allocated memory to 8MiB (can be increased if needed), which
in turn limits the number of clone sources to 8M / sizeof(struct
clone_root) = 8M / 40 = 209715.  Real world number of clones is from
tens to hundreds, so this is future proof.

Reported-by: syzbot+4376a9a073770c173269@syzkaller.appspotmail.com
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 80d248e88761d..1f535cd990d3c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6826,10 +6826,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 	/*
 	 * Check that we don't overflow at later allocations, we request
 	 * clone_sources_count + 1 items, and compare to unsigned long inside
-	 * access_ok.
+	 * access_ok. Also set an upper limit for allocation size so this can't
+	 * easily exhaust memory. Max number of clone sources is about 200K.
 	 */
-	if (arg->clone_sources_count >
-	    ULONG_MAX / sizeof(struct clone_root) - 1) {
+	if (arg->clone_sources_count > SZ_8M / sizeof(struct clone_root)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.39.0

