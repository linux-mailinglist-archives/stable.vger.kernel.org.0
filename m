Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D5F5487CF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351754AbiFMMes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354944AbiFMMdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:33:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46001192A6;
        Mon, 13 Jun 2022 04:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD0D9B80D31;
        Mon, 13 Jun 2022 11:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB3CC34114;
        Mon, 13 Jun 2022 11:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118455;
        bh=k/D5J55DGOPHu+CtgfOk8/cAeltQ3W05ljaoIyGNbpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdGZOECtukcVWeo1t0lL+A89hv6scjza6A1oQ/v80uAsONL+biLbcJ8RmQnBHJRp6
         B97uWQSDjc0Ep1wXC91ifqUFZO8OuNA6CD2tUPopt4tFxItodRrGMeT6ES3X3wIhMF
         4eyuXiAxS7bVthUOU+ej0n9yPtsmiTx/z/ejjVmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+763ae12a2ede1d99d4dc@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/172] f2fs: remove WARN_ON in f2fs_is_valid_blkaddr
Date:   Mon, 13 Jun 2022 12:10:42 +0200
Message-Id: <20220613094910.086919920@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit dc2f78e2d4cc844a1458653d57ce1b54d4a29f21 ]

Syzbot triggers two WARNs in f2fs_is_valid_blkaddr and
__is_bitmap_valid. For example, in f2fs_is_valid_blkaddr,
if type is DATA_GENERIC_ENHANCE or DATA_GENERIC_ENHANCE_READ,
it invokes WARN_ON if blkaddr is not in the right range.
The call trace is as follows:

 f2fs_get_node_info+0x45f/0x1070
 read_node_page+0x577/0x1190
 __get_node_page.part.0+0x9e/0x10e0
 __get_node_page
 f2fs_get_node_page+0x109/0x180
 do_read_inode
 f2fs_iget+0x2a5/0x58b0
 f2fs_fill_super+0x3b39/0x7ca0

Fix these two WARNs by replacing WARN_ON with dump_stack.

Reported-by: syzbot+763ae12a2ede1d99d4dc@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 77f30320f862..1c49b9959b32 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -148,7 +148,7 @@ static bool __is_bitmap_valid(struct f2fs_sb_info *sbi, block_t blkaddr,
 		f2fs_err(sbi, "Inconsistent error blkaddr:%u, sit bitmap:%d",
 			 blkaddr, exist);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
-		WARN_ON(1);
+		dump_stack();
 	}
 	return exist;
 }
@@ -186,7 +186,7 @@ bool f2fs_is_valid_blkaddr(struct f2fs_sb_info *sbi,
 			f2fs_warn(sbi, "access invalid blkaddr:%u",
 				  blkaddr);
 			set_sbi_flag(sbi, SBI_NEED_FSCK);
-			WARN_ON(1);
+			dump_stack();
 			return false;
 		} else {
 			return __is_bitmap_valid(sbi, blkaddr, type);
-- 
2.35.1



