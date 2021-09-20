Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB3941219C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358497AbhITSGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357697AbhITSEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBF9061A0D;
        Mon, 20 Sep 2021 17:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158241;
        bh=5vK+fJ8dY2bj6KrzhYEdSa5hXdeIdt136qX0sfEdUh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGPdT+o1JBEiG5tSrfI11kRRdGqGZ9JjrTTFoo+ZGaA0hjglDGxMA+/JRaHgFOt1D
         TRB8XuqVt1HscL43eq+P7mfUjVTPo/6xAgdNkzVpNoGqJbn0kMOLNR9Nl+9aIdtxE1
         li1iWG8aeBhrNOByJcWUqob4J0BF3fidOhqqJFVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/260] f2fs: fix to account missing .skipped_gc_rwsem
Date:   Mon, 20 Sep 2021 18:41:24 +0200
Message-Id: <20210920163933.372870549@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index 6b13a1a89206..4b6c36208f55 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1095,8 +1095,10 @@ static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
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



