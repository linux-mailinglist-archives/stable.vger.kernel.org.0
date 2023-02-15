Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1524698654
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjBOUtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBOUsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:48:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271AF442EC;
        Wed, 15 Feb 2023 12:47:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB0AAB823C6;
        Wed, 15 Feb 2023 20:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F31C4339B;
        Wed, 15 Feb 2023 20:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494024;
        bh=pIDsHQIxAP8j2mYopzv7l61g1GseLYSPEJsRHssoCJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=er+r/SsvmkCvESVvSv/S6CsVd3n1HZRKA6Z2MkOG4BXD2ZXFjpzfezsP2gaUrBahO
         VK2sqqv+sGCOcaJdiToQ4ZSThh6W52lJUwQ7rbWEczUc1U72WmfMax6iLlm1rEtRSx
         NDQIfgS6+E82PFdZvKq8TqQjHKV2vdjfNxYDVSZAP9mSvla7CkXB9nqx8JxVaf1YCb
         Fe65vpl74XmPme9kqHDyCQltTVbeoBx1jQZsdKGLYGWSOh/8ZJUJiM1QvlzxVyT3Cx
         IAhLtK4iStYUNAbdCGbuXvlOevkQ2EpMbjLvqVhsSfvcL+w5lbDu0+0zVB5iQzG+D0
         9FmQbcYOQFncw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        syzbot+4376a9a073770c173269@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 4/7] btrfs: send: limit number of clones and allocated memory size
Date:   Wed, 15 Feb 2023 15:46:56 -0500
Message-Id: <20230215204700.2761331-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204700.2761331-1-sashal@kernel.org>
References: <20230215204700.2761331-1-sashal@kernel.org>
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
index fb1996980d265..97417b5569a98 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7347,10 +7347,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
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

