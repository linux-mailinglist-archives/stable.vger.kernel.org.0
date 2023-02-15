Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCD0698672
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjBOUuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjBOUt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:49:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7E1457CE;
        Wed, 15 Feb 2023 12:47:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1BE4CCE2703;
        Wed, 15 Feb 2023 20:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3006BC433D2;
        Wed, 15 Feb 2023 20:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494034;
        bh=/o5aTQCwWvTFLqNoUWpmBlA6hFO2Voqtey/ttM49cGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jp2Nz4RCa0Fo822li2C1MkPBi1PEKWDpQuxOKlvpwmHHwxKUsrTuK1RmbaebdeIzt
         cB0oGsnckEdgN07AiyZuCaK9UWcNCCmXY+dsuYr3XoiOngENXfKogeyR28UOKCR8Ms
         iklaWsdWCxR8PxNOYZtd8pz89GUfIIvRY75k3lOhclxT9nZCKmNAHES3Zg1SUMlz7L
         eDrEUvSMzBVFq24p/VSjnBkc4UnbMGOBzzq8oFyd+nz6jcaTfQQNZFVmXX5wnodSzo
         a5qL7ULVvo7YC4Mv1vf79Hir6jzWcEW3Mo33TwM7hkVKuDL10QUpKqzYO+AE6QToYM
         MpYzQoZGr2Ztw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        syzbot+4376a9a073770c173269@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/3] btrfs: send: limit number of clones and allocated memory size
Date:   Wed, 15 Feb 2023 15:47:11 -0500
Message-Id: <20230215204712.2761492-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204712.2761492-1-sashal@kernel.org>
References: <20230215204712.2761492-1-sashal@kernel.org>
MIME-Version: 1.0
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
index efab9446eac87..b08e7fcd8c34d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6646,10 +6646,10 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
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

