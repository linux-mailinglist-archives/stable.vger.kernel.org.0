Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC1532E987
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhCEMdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:33:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231984AbhCEMc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:32:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F4165019;
        Fri,  5 Mar 2021 12:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947576;
        bh=RWkjLAPQOAxQxSizyrixUJabhoEZlh1JbOtkSHid9RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1GSDZIB9gRM9L3LuF7dj/VN7jaUm0iw1jFBtkRePKMDxg+JTcfus3SgC5bgsSAbE
         b4WC2gEsk7scw4QHc9vf64dtinq6g91IDe3BKPwcBUkLv7ukP/1Z1afrJd+j4NPy3A
         zG76ixBM/z72vjMxV9oZreZiKv/97XZ29/3tJ+pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c68f467cd7c45860e8d4@syzkaller.appspotmail.com,
        Chao Yu <yuchao0@huawei.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.4 10/72] erofs: fix shift-out-of-bounds of blkszbits
Date:   Fri,  5 Mar 2021 13:21:12 +0100
Message-Id: <20210305120857.849561219@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
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
@@ -124,8 +124,8 @@ static int erofs_read_superblock(struct
 	blkszbits = dsb->blkszbits;
 	/* 9(512 bytes) + LOG_SECTORS_PER_BLOCK == LOG_BLOCK_SIZE */
 	if (blkszbits != LOG_BLOCK_SIZE) {
-		erofs_err(sb, "blksize %u isn't supported on this platform",
-			  1 << blkszbits);
+		erofs_err(sb, "blkszbits %u isn't supported on this platform",
+			  blkszbits);
 		goto out;
 	}
 


