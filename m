Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83852657B8D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiL1PXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbiL1PWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318F61402A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2CC06154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1976C433D2;
        Wed, 28 Dec 2022 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240970;
        bh=XZbEQknCyg1jcKzd9RfraxZOjt78kJ1E9oqPv1n3/h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GW9Pf8fvxcNcC/8l9dpcQXH3lFyyhcOogTPvc3kOYpBSLfabxmBEW8fXKL8swD5/W
         LDAlyMVB+SfEeDOA6WtyfkXjP5hGduIvy8Kq0lOVUj6yuh+g2ftRx+JLmH/dqhh/YS
         sGPO7FMjBVcl/dXbHTHbJeNcVDraHEkeeUu+DL8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ZhangPeng <zhangpeng362@huawei.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        syzbot+dc3b1cf9111ab5fe98e7@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0190/1146] hfs: Fix OOB Write in hfs_asc2mac
Date:   Wed, 28 Dec 2022 15:28:49 +0100
Message-Id: <20221228144335.310498975@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: ZhangPeng <zhangpeng362@huawei.com>

[ Upstream commit c53ed55cb275344086e32a7080a6b19cb183650b ]

Syzbot reported a OOB Write bug:

loop0: detected capacity change from 0 to 64
==================================================================
BUG: KASAN: slab-out-of-bounds in hfs_asc2mac+0x467/0x9a0
fs/hfs/trans.c:133
Write of size 1 at addr ffff88801848314e by task syz-executor391/3632

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:284
 print_report+0x107/0x1f0 mm/kasan/report.c:395
 kasan_report+0xcd/0x100 mm/kasan/report.c:495
 hfs_asc2mac+0x467/0x9a0 fs/hfs/trans.c:133
 hfs_cat_build_key+0x92/0x170 fs/hfs/catalog.c:28
 hfs_lookup+0x1ab/0x2c0 fs/hfs/dir.c:31
 lookup_open fs/namei.c:3391 [inline]
 open_last_lookups fs/namei.c:3481 [inline]
 path_openat+0x10e6/0x2df0 fs/namei.c:3710
 do_filp_open+0x264/0x4f0 fs/namei.c:3740

If in->len is much larger than HFS_NAMELEN(31) which is the maximum
length of an HFS filename, a OOB write could occur in hfs_asc2mac(). In
that case, when the dst reaches the boundary, the srclen is still
greater than 0, which causes a OOB write.
Fix this by adding a check on dstlen in while() before writing to dst
address.

Link: https://lkml.kernel.org/r/20221202030038.1391945-1-zhangpeng362@huawei.com
Fixes: 328b92278650 ("[PATCH] hfs: NLS support")
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Reported-by: <syzbot+dc3b1cf9111ab5fe98e7@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfs/trans.c b/fs/hfs/trans.c
index 39f5e343bf4d..fdb0edb8a607 100644
--- a/fs/hfs/trans.c
+++ b/fs/hfs/trans.c
@@ -109,7 +109,7 @@ void hfs_asc2mac(struct super_block *sb, struct hfs_name *out, const struct qstr
 	if (nls_io) {
 		wchar_t ch;
 
-		while (srclen > 0) {
+		while (srclen > 0 && dstlen > 0) {
 			size = nls_io->char2uni(src, srclen, &ch);
 			if (size < 0) {
 				ch = '?';
-- 
2.35.1



