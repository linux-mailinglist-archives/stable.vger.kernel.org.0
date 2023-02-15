Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B69697723
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 08:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjBOHH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 02:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbjBOHHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 02:07:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8830035261;
        Tue, 14 Feb 2023 23:07:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1815CE22D7;
        Wed, 15 Feb 2023 07:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380A8C4339E;
        Wed, 15 Feb 2023 07:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676444783;
        bh=GMg/MDV5+3bAf1EEuNmh63jupI3sron3HOnW10+I5+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZ/CCkcJ0M4oUCKPs3GJVCQ0wY8vIKhnrjzdLFN/ucpiCWBhbTKkLimRlhkiq2mWX
         VRmxR3goeEXQkEw/UZ/fzDQrkBcL4TLkvTGny9sZMZmicpcfhrX8ydNnjboQ8Unrqt
         GPhIQC7yIOvhwK80QshaoVN9N7AOwDoY1jwmYIWCQnyHeJY6lrAoBJiZ3XI9WvfyG9
         MhP9TBdeT/BLPaVMKdAMzVF6KRIeIn0lkCt/veiFdkXUF9Z79hNK1PVkfHVVU3WkS0
         MJ7PiaMlW9pWqXw0VtgSonG/iKE72cyPaLR16hGKNjCFkDhtPwc/tu/BWTQy/95V43
         6RhiHSGHH3aXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Potapenko <glider@google.com>,
        syzbot+14d9e7602ebdf7ec0a60@syzkaller.appspotmail.com,
        David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 03/93] btrfs: zlib: zero-initialize zlib workspace
Date:   Wed, 15 Feb 2023 02:04:50 -0500
Message-Id: <20230215070620.2718851-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215070620.2718851-1-sashal@kernel.org>
References: <20230215070620.2718851-1-sashal@kernel.org>
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

From: Alexander Potapenko <glider@google.com>

commit eadd7deca0ad8a83edb2b894d8326c78e78635d6 upstream.

KMSAN reports uses of uninitialized memory in zlib's longest_match()
called on memory originating from zlib_alloc_workspace().
This issue is known by zlib maintainers and is claimed to be harmless,
but to be on the safe side we'd better initialize the memory.

Link: https://zlib.net/zlib_faq.html#faq36
Reported-by: syzbot+14d9e7602ebdf7ec0a60@syzkaller.appspotmail.com
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zlib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index b4f44662cda7c..94d06a76edb17 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -63,7 +63,7 @@ struct list_head *zlib_alloc_workspace(unsigned int level)
 
 	workspacesize = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
 			zlib_inflate_workspacesize());
-	workspace->strm.workspace = kvmalloc(workspacesize, GFP_KERNEL);
+	workspace->strm.workspace = kvzalloc(workspacesize, GFP_KERNEL);
 	workspace->level = level;
 	workspace->buf = NULL;
 	/*
-- 
2.39.0

