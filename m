Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D871E65B09B
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbjABL0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjABL0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:26:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5345F65B7
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:24:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05518B80D1A
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59017C433D2;
        Mon,  2 Jan 2023 11:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658682;
        bh=eyeVpSgs7yyNN4VmDie4YgP3ASJGu3G+9zEUJiQqs5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcB1UlLJOHfEO57KZqj726vmyBCCQDBQQlAL5JTZQN+K/fyttnDL/YmHMTPoIvBPd
         hU6Y6u9F4hWUG0rUJCmdklrZOV6/TuK6U5fsW25FPYZUwVmi6zNOJqoltmoHZ/pqPQ
         noT+xb6wpYxHc1V0QfSNmPqTLiciviEImSEynXIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzot <syzbot+33f3faaa0c08744f7d40@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/71] fs/ntfs3: Use __GFP_NOWARN allocation at ntfs_fill_super()
Date:   Mon,  2 Jan 2023 12:21:55 +0100
Message-Id: <20230102110552.704939764@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
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
index 94f9e4b775a7..8e2fe0f69203 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1141,7 +1141,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
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



