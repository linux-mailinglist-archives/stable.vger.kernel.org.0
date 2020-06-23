Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C262062C6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391585AbgFWUfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391581AbgFWUfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:35:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC7392064B;
        Tue, 23 Jun 2020 20:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944506;
        bh=H4g1p8Txj5EXRnPJ0ZgNnkJmqASI8EjsxqgyuYnyGyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p02txnxUhZ1gYb40Y7QWprEdxYZNM7tao7K/sf2B7kp0zFYbQo3D7Gaycsvs7tsna
         ObVG3Mp6Q2US5rXEmYp6t5HE5nSnVu3Al5v3fs4LJIGUhu3LK9t2RGjrTdYEuXzJcJ
         p7w9TgkBMW6R+eThi6gD14R5Hzwbk9uqtFIabLY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/206] f2fs: report delalloc reserve as non-free in statfs for project quota
Date:   Tue, 23 Jun 2020 21:55:45 +0200
Message-Id: <20200623195317.814547634@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit baaa7ebf25c78c5cb712fac16b7f549100beddd3 ]

This reserved space isn't committed yet but cannot be used for
allocations. For userspace it has no difference from used space.

See the same fix in ext4 commit f06925c73942 ("ext4: report delalloc
reserve as non-free in statfs for project quota").

Fixes: ddc34e328d06 ("f2fs: introduce f2fs_statfs_project")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 45f8f6ec22a55..9782250c98156 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1154,7 +1154,8 @@ static int f2fs_statfs_project(struct super_block *sb,
 		limit >>= sb->s_blocksize_bits;
 
 	if (limit && buf->f_blocks > limit) {
-		curblock = dquot->dq_dqb.dqb_curspace >> sb->s_blocksize_bits;
+		curblock = (dquot->dq_dqb.dqb_curspace +
+			    dquot->dq_dqb.dqb_rsvspace) >> sb->s_blocksize_bits;
 		buf->f_blocks = limit;
 		buf->f_bfree = buf->f_bavail =
 			(buf->f_blocks > curblock) ?
-- 
2.25.1



