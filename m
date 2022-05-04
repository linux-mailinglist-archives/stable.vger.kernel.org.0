Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B4C51A87B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355714AbiEDRLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356885AbiEDRJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB2E4553B;
        Wed,  4 May 2022 09:56:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBE74B82795;
        Wed,  4 May 2022 16:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51567C385A5;
        Wed,  4 May 2022 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683375;
        bh=K32jkouY8bCApJeS1xG/u8VhN90LNIqFe6Zp9teHNIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDEYkk3ZUbqcsm8BIrCFqA/a0mbuAUdxV1M4T5JHh+q+vB7bmsSrs6m4RC0o7HxPu
         d+zrr3vsPEEQsgQP/jjb4gv1fx6VU1sdM6NAGAQv6qm1HJSn0hwds2Lv8/wBq8nsgf
         qyK3+XWs7ON2Y+yygu74cdUJ9GqwWt3miUn8gDxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.17 046/225] f2fs: should not truncate blocks during roll-forward recovery
Date:   Wed,  4 May 2022 18:44:44 +0200
Message-Id: <20220504153114.207957787@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 4d8ec91208196e0e19195f1e7d6be9de5873f242 upstream.

If the file preallocated blocks and fsync'ed, we should not truncate them during
roll-forward recovery which will recover i_size correctly back.

Fixes: d4dd19ec1ea0 ("f2fs: do not expose unwritten blocks to user by DIO")
Cc: <stable@vger.kernel.org> # 5.17+
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 71f232dcf3c2..83639238a1fe 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -550,7 +550,8 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	}
 	f2fs_set_inode_flags(inode);
 
-	if (file_should_truncate(inode)) {
+	if (file_should_truncate(inode) &&
+			!is_sbi_flag_set(sbi, SBI_POR_DOING)) {
 		ret = f2fs_truncate(inode);
 		if (ret)
 			goto bad_inode;
-- 
2.36.0



