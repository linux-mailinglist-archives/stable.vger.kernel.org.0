Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F4B3835DB
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242634AbhEQPZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244914AbhEQPWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C274613F8;
        Mon, 17 May 2021 14:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262107;
        bh=8riokKxH2sHn+YGY/A9V+kGW3Q3eIEgRBSDmyHjbsgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uH0bVYT/w49a8waIFsb6+dq7dB8bU4D3qThc21XqwtrIcpxz/BRvW2zPYyxxZixIx
         KdOyRR1xCZVFDiDWx+lHpGKG3lT0iBcwHdysjLKz+ExpRzUPKVkYUoC+1XJYSRhUyC
         F7tlOGgFb1XpJ73fUgo21aoHMnpFv4d0Sd6B9gD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/289] f2fs: fix to cover __allocate_new_section() with curseg_lock
Date:   Mon, 17 May 2021 16:00:37 +0200
Message-Id: <20210517140308.944855026@linuxfoundation.org>
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

[ Upstream commit 823d13e12b6cbaef2f6e5d63c648643e7bc094dd ]

In order to avoid race with f2fs_do_replace_block().

Fixes: f5a53edcf01e ("f2fs: support aligned pinned file")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 661b891aa1ca..ddfc3daebe9b 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2948,19 +2948,23 @@ static void __allocate_new_section(struct f2fs_sb_info *sbi, int type)
 
 void f2fs_allocate_new_section(struct f2fs_sb_info *sbi, int type)
 {
+	down_read(&SM_I(sbi)->curseg_lock);
 	down_write(&SIT_I(sbi)->sentry_lock);
 	__allocate_new_section(sbi, type);
 	up_write(&SIT_I(sbi)->sentry_lock);
+	up_read(&SM_I(sbi)->curseg_lock);
 }
 
 void f2fs_allocate_new_segments(struct f2fs_sb_info *sbi)
 {
 	int i;
 
+	down_read(&SM_I(sbi)->curseg_lock);
 	down_write(&SIT_I(sbi)->sentry_lock);
 	for (i = CURSEG_HOT_DATA; i <= CURSEG_COLD_DATA; i++)
 		__allocate_new_segment(sbi, i, false);
 	up_write(&SIT_I(sbi)->sentry_lock);
+	up_read(&SM_I(sbi)->curseg_lock);
 }
 
 static const struct segment_allocation default_salloc_ops = {
-- 
2.30.2



