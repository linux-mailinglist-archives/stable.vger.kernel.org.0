Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA8E6A72FA
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCASLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjCASLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:11:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618674BEAA
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:11:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C95E8CE1DAC
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA31C433EF;
        Wed,  1 Mar 2023 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694277;
        bh=glXiqwWnZkPLHB/TNwJlCB/NEci9DyiBJ9dY7bJxoZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEX+QLCfU8gSoSR9ScqB4MnSE4Y4I+dEAIE7MzcbcgNeG9yzb7rIpIRyjkQh1vmbC
         8vSmXINPwUtq2fRMAvajqYdC/TzhFcBgKHyvwlxUHm+SgcIuTEwAbELotLUsML4qYE
         iiYTAFUzQJmMXjFp8JgESrD+dOQRNE3OaTtM+Hlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+4376a9a073770c173269@syzkaller.appspotmail.com,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/22] btrfs: send: limit number of clones and allocated memory size
Date:   Wed,  1 Mar 2023 19:08:40 +0100
Message-Id: <20230301180652.958581158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
References: <20230301180652.658125575@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9250a17731bdb..692ae2e2f8cc5 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7549,10 +7549,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
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



