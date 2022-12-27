Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A26656EC2
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiL0UeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbiL0UdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:33:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAD2DEA2;
        Tue, 27 Dec 2022 12:33:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0993761242;
        Tue, 27 Dec 2022 20:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE44C433F0;
        Tue, 27 Dec 2022 20:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173194;
        bh=Z2C5CMxQAa4njOHE+aJsyDCe4itEyCpQG5gEsMBDQiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/oIk/SyZsIHujTTlbVpA24vougQjZJmqbR20m2ISmuhN6m5c2QhicZJdq5Ms30qx
         RLfWC06wl9VT09H3ej6+BheKp7cbQdCfMBgc4K9L1Ej/EkchT+8d3ZIRXUgD2AtwJv
         l9xpry2mKMfWuRGlpe1+jQ/5Y+aAs2dulwKzquJHeLBUQ2ljEp25t4cJvHFKEqG6XN
         K4uLnvbuuiqI9VCZL/GVoV/LNpyxchvlALhMpc0N/KOqw6iwcYaeEqmylEWvUtQdty
         1hlmZ7aTYfLEl+wUR+WATxwNB+1gZdVL8semHxk+he6d/UEhwgPzkrI6HtE2QpFHu3
         Fkk1nrSpETNfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzot <syzbot+fa4648a5446460b7b963@syzkaller.appspotmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 15/28] fs/ntfs3: Use __GFP_NOWARN allocation at wnd_init()
Date:   Tue, 27 Dec 2022 15:32:36 -0500
Message-Id: <20221227203249.1213526-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203249.1213526-1-sashal@kernel.org>
References: <20221227203249.1213526-1-sashal@kernel.org>
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

[ Upstream commit 0d0f659bf713662fabed973f9996b8f23c59ca51 ]

syzbot is reporting too large allocation at wnd_init() [1], for a crafted
filesystem can become wnd->nwnd close to UINT_MAX. Add __GFP_NOWARN in
order to avoid too large allocation warning, than exhausting memory by
using kvcalloc().

Link: https://syzkaller.appspot.com/bug?extid=fa4648a5446460b7b963 [1]
Reported-by: syzot <syzbot+fa4648a5446460b7b963@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
index e92bbd754365..8d5d8cf4902f 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -661,7 +661,7 @@ int wnd_init(struct wnd_bitmap *wnd, struct super_block *sb, size_t nbits)
 	if (!wnd->bits_last)
 		wnd->bits_last = wbits;
 
-	wnd->free_bits = kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS);
+	wnd->free_bits = kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS | __GFP_NOWARN);
 	if (!wnd->free_bits)
 		return -ENOMEM;
 
-- 
2.35.1

