Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0634C49A4EA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2372077AbiAYAKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363961AbiAXXq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822B5C0BD131;
        Mon, 24 Jan 2022 13:41:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EFF6B811FC;
        Mon, 24 Jan 2022 21:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689E9C340E4;
        Mon, 24 Jan 2022 21:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060458;
        bh=W4KbRk8KStS1Cen/vo17BeVo9TAlDXgRj6zyPHssjsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IULL+BMIOO6KI6SZghSCPjxYpWi9X2NXs1d5xCABRSL2ZrveHnc+8tJZhDOjAY+Fe
         u8rj6JbVsy2jD1J5fc9EwwnqCaL0VYZ1y4XTMPKGkGuhAyC7JsQ5JMyj/DUPLnsV9Y
         vMhhYZnmpaAGrHlKSIlXS2yU1z2dfVEk11v9l/L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.16 0955/1039] f2fs: fix to avoid panic in is_alive() if metadata is inconsistent
Date:   Mon, 24 Jan 2022 19:45:44 +0100
Message-Id: <20220124184157.388411875@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit f6db43076d190d9bf75559dec28e18b9d12e4ce5 upstream.

As report by Wenqing Liu in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215231

If we enable CONFIG_F2FS_CHECK_FS config, and with fuzzed image attached
in above link, we will encounter panic when executing below script:

1. mkdir mnt
2. mount -t f2fs tmp1.img mnt
3. touch tmp

F2FS-fs (loop11): mismatched blkaddr 5765 (source_blkaddr 1) in seg 3
kernel BUG at fs/f2fs/gc.c:1042!
 do_garbage_collect+0x90f/0xa80 [f2fs]
 f2fs_gc+0x294/0x12a0 [f2fs]
 f2fs_balance_fs+0x2c5/0x7d0 [f2fs]
 f2fs_create+0x239/0xd90 [f2fs]
 lookup_open+0x45e/0xa90
 open_last_lookups+0x203/0x670
 path_openat+0xae/0x490
 do_filp_open+0xbc/0x160
 do_sys_openat2+0x2f1/0x500
 do_sys_open+0x5e/0xa0
 __x64_sys_openat+0x28/0x40

Previously, f2fs tries to catch data inconcistency exception in between
SSA and SIT table during GC, however once the exception is caught, it will
call f2fs_bug_on to hang kernel, it's not needed, instead, let's set
SBI_NEED_FSCK flag and skip migrating current block.

Fixes: bbf9f7d90f21 ("f2fs: Fix indefinite loop in f2fs_gc()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1042,7 +1042,7 @@ static bool is_alive(struct f2fs_sb_info
 			if (!test_and_set_bit(segno, SIT_I(sbi)->invalid_segmap)) {
 				f2fs_err(sbi, "mismatched blkaddr %u (source_blkaddr %u) in seg %u",
 					 blkaddr, source_blkaddr, segno);
-				f2fs_bug_on(sbi, 1);
+				set_sbi_flag(sbi, SBI_NEED_FSCK);
 			}
 		}
 #endif


