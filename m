Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A518698635
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjBOUs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjBOUrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:47:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F8042BE5;
        Wed, 15 Feb 2023 12:47:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9862FB823B4;
        Wed, 15 Feb 2023 20:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040A3C433D2;
        Wed, 15 Feb 2023 20:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494015;
        bh=Bten+99sPVsDdM0CvDxWdS7kL5uUfLWUk6B7Uc8QbuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrsUNgsPqalD7v7+4mQgsWoC3mU22yaYsetf3vYeG8I90bGF6Ipay0gK3qUkE9a7+
         P1gkQuakRkXSE/+A7XLT9eSZEvhwt8EpRZmD1gohyDGqV6sT3tcPq8U1Y7MFX45SgZ
         2MXg3N3FVmOmoU6t8uZKl0h3Zi/T9dIhjFN0U5lhS0f7A4+KoKpTH/V3xPb1gilhJ4
         6h9klsBkJn1MpuLjsRvdsU7DBMY/PvJQyx6E1nLLzRV/9yegPNSJ+oeSxPHMbrSqzc
         5FCOCh21CXymwvK3R7CWLQCEkuc9UKAAiCFUVYFyNu7MT75HA/f7js9OHIge82jTVx
         15BTOe1IVWNQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        syzbot+4376a9a073770c173269@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 5/8] btrfs: send: limit number of clones and allocated memory size
Date:   Wed, 15 Feb 2023 15:46:46 -0500
Message-Id: <20230215204649.2761225-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204649.2761225-1-sashal@kernel.org>
References: <20230215204649.2761225-1-sashal@kernel.org>
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
index 4a6ba0997e399..b081b61e97c8d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7276,10 +7276,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
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

