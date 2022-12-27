Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05280656F39
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiL0Ujq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiL0Uiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:38:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4949BE0ED;
        Tue, 27 Dec 2022 12:34:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AFF56123D;
        Tue, 27 Dec 2022 20:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6F3C433D2;
        Tue, 27 Dec 2022 20:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173291;
        bh=0jM4yyYc3KaGukPdVUK0l6Bb0E5LPX33NldHIMw5RAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S33Gw8Fkr+IrsMwYR2vkuDsyyvFSQF59pFWkZHhp2Sji0IpuTCcILr5Y/3JG1vWBc
         u451POcONqw2jtv9prt3IKuk7edsnvn1gKGBKewrtGYNAFaEZYTyAjX81f9WYG1CFi
         4vk8QuGrn9g7a+g5dc+mUpi77hHOVSiKBIqBwatjLDSkd/RzhIIDUvYoAd9ubZp/uq
         lyaQDRptdE200DGtCO6qoEltT5Ux+W1WF8qHHFzMHAvTeCsGtjpRfn4n+ZVg0fF0aY
         VKA3Fjlr2HJyna32ZEqGiv3ed1XiPNrV0IdmZ3m7+AwvbRa9pRCIAzzxTcmyBD5SIz
         sSv6eWuwjGhzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzot <syzbot+33f3faaa0c08744f7d40@syzkaller.appspotmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 14/22] fs/ntfs3: Use __GFP_NOWARN allocation at ntfs_fill_super()
Date:   Tue, 27 Dec 2022 15:34:24 -0500
Message-Id: <20221227203433.1214255-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203433.1214255-1-sashal@kernel.org>
References: <20221227203433.1214255-1-sashal@kernel.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 59bfd7a483da36bd202532a3d9ea1f14f3bf3aaf ]

syzbot is reporting too large allocation at ntfs_fill_super() [1], for a
crafted filesystem can contain bogus inode->i_size. Add __GFP_NOWARN in
order to avoid too large allocation warning, than exhausting memory by
using kvmalloc().

Link: https://syzkaller.appspot.com/bug?extid=33f3faaa0c08744f7d40 [1]
Reported-by: syzot <syzbot+33f3faaa0c08744f7d40@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 25a9b3691033..0d1093e9682f 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1136,7 +1136,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto put_inode_out;
 	}
 	bytes = inode->i_size;
-	sbi->def_table = t = kmalloc(bytes, GFP_NOFS);
+	sbi->def_table = t = kmalloc(bytes, GFP_NOFS | __GFP_NOWARN);
 	if (!t) {
 		err = -ENOMEM;
 		goto put_inode_out;
-- 
2.35.1

