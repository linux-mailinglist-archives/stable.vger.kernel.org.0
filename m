Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FC440E66B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344403AbhIPRVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351154AbhIPRSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:18:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1902D61A0B;
        Thu, 16 Sep 2021 16:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810460;
        bh=KtnG62f5Ux0LFIE8Iv0eocACMITqISmfOk3pbxWLlt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAEh5+n0BLKjHdRrKdCZozZ7VUZm2jwLfmvS9edpcEUhYuKtdK/bGbSnNcLvhK9mB
         uKvTlL/8NNMckcNYUsqf0WKnVDN/PkgA5J/lt7JuayLU3An8TbPzStqG9VMlWLQeh6
         mgxdAtjfyWun9lHZ4hduaAfteui0ASCZ5bekN0lU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 149/432] f2fs: fix to account missing .skipped_gc_rwsem
Date:   Thu, 16 Sep 2021 17:58:18 +0200
Message-Id: <20210916155815.801480033@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit ad126ebddecbf696e0cf214ff56c7b170fa9f0f7 ]

There is a missing place we forgot to account .skipped_gc_rwsem, fix it.

Fixes: 6f8d4455060d ("f2fs: avoid fi->i_gc_rwsem[WRITE] lock in f2fs_gc")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 0e42ee5f7770..70234a7040c8 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1497,8 +1497,10 @@ static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 			int err;
 
 			if (S_ISREG(inode->i_mode)) {
-				if (!down_write_trylock(&fi->i_gc_rwsem[READ]))
+				if (!down_write_trylock(&fi->i_gc_rwsem[READ])) {
+					sbi->skipped_gc_rwsem++;
 					continue;
+				}
 				if (!down_write_trylock(
 						&fi->i_gc_rwsem[WRITE])) {
 					sbi->skipped_gc_rwsem++;
-- 
2.30.2



