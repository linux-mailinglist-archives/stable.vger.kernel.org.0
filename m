Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F57D40E2BC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhIPQlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243806AbhIPQjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDFA1613A7;
        Thu, 16 Sep 2021 16:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809374;
        bh=PL2fjtyQz7kstaeOcGoYXzrIajW5xStSDU0XM1YcDts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbJtEH7l18VEZ/hzZCaSspq2lovWW7JQijShfk6Y45TD+8D9WZWcKw+upxe9wFMUq
         /1EYjzPIAL1v7PZVQ3UtXYYG0TIhuvHov1gtmPYEV8rCJSwPfRDU8uvDu3IGKGHywE
         DjXeZWbr315tIfMB1eaxmTz/pB7/CQYCh8OI+jH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 131/380] f2fs: fix to account missing .skipped_gc_rwsem
Date:   Thu, 16 Sep 2021 17:58:08 +0200
Message-Id: <20210916155808.499147799@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index 83b0a7872b3c..1c05e156d9d5 100644
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



