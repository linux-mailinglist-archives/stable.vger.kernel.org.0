Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5CB32E812
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhCEMYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhCEMYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18B1665023;
        Fri,  5 Mar 2021 12:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947071;
        bh=TkQ0G2I7tF1A03yoZaDZF426y33KeiUnafibNYznA04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L67nWOpaVR5Mlt7Q8E6gH3rVsebnNtAhtXoae4FFVCy5X5WhhzNAoPorQVd+99qof
         TzW8uU/znhuW9gcOQnWJW+ooQvg9ULrchCiMK3JwXt70i4F4q4SXMxGYu1uS/9sDIX
         3DEOEzHqZb3yf0wccFo+U9+3FML5MADeQHIWsTOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c68f467cd7c45860e8d4@syzkaller.appspotmail.com,
        Chao Yu <yuchao0@huawei.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.11 008/104] erofs: fix shift-out-of-bounds of blkszbits
Date:   Fri,  5 Mar 2021 13:20:13 +0100
Message-Id: <20210305120903.598578484@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit bde545295b710bdd13a0fcd4b9fddd2383eeeb3a upstream.

syzbot generated a crafted bitszbits which can be shifted
out-of-bounds[1]. So directly print unsupported blkszbits
instead of blksize.

[1] https://lore.kernel.org/r/000000000000c72ddd05b9444d2f@google.com

Link: https://lore.kernel.org/r/20210120013016.14071-1-hsiangkao@aol.com
Reported-by: syzbot+c68f467cd7c45860e8d4@syzkaller.appspotmail.com
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -158,8 +158,8 @@ static int erofs_read_superblock(struct
 	blkszbits = dsb->blkszbits;
 	/* 9(512 bytes) + LOG_SECTORS_PER_BLOCK == LOG_BLOCK_SIZE */
 	if (blkszbits != LOG_BLOCK_SIZE) {
-		erofs_err(sb, "blksize %u isn't supported on this platform",
-			  1 << blkszbits);
+		erofs_err(sb, "blkszbits %u isn't supported on this platform",
+			  blkszbits);
 		goto out;
 	}
 


