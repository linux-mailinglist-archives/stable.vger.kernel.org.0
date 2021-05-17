Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD13383731
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244964AbhEQPko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244966AbhEQPi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:38:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3196B61946;
        Mon, 17 May 2021 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262466;
        bh=qAYjFm1d6REHx7asIHAbKhI6yyXQ1YitqL0796GaLa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRXCMWaeNXdZACJC8uNPSgpmuUtNA7krW+fQmuMWgfB+qfPdtlYN+vvgxXx/G9ikP
         7UW3YUlni8Q68gu+wsuBBtgRj/Z/D4aITLaSTXygy0wdiXCCaCoRcbEEt7UFaeo5ar
         Yv8E5yQj6Z6ZeuOM8s/Wqaf7XrHgYlpUtyRmoNus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/289] f2fs: avoid unneeded data copy in f2fs_ioc_move_range()
Date:   Mon, 17 May 2021 16:01:58 +0200
Message-Id: <20210517140311.605707433@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 3a1b9eaf727b4ab84ebf059e09c38fc6a53e5614 ]

Fields in struct f2fs_move_range won't change in f2fs_ioc_move_range(),
let's avoid copying this structure's data to userspace.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9f857e5709b6..5c74b2997197 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2913,12 +2913,6 @@ static int __f2fs_ioc_move_range(struct file *filp,
 					range->pos_out, range->len);
 
 	mnt_drop_write_file(filp);
-	if (err)
-		goto err_out;
-
-	if (copy_to_user((struct f2fs_move_range __user *)arg,
-						&range, sizeof(range)))
-		err = -EFAULT;
 err_out:
 	fdput(dst);
 	return err;
-- 
2.30.2



