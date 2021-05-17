Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD0F38339E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241280AbhEQPAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241729AbhEQO6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C45E619B5;
        Mon, 17 May 2021 14:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261565;
        bh=ytXTiaDKBX+Xnj5S+5IPA8W2ZFBxBSfHmKmSNUnLtAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOr3tYFvm3KI7p2IqZ17bUiyHCgaGlD+o3t32jqvMTsnP34mEFl4ZWCl7+m1LjBTQ
         8TGkusHOOglvQKq37d/cOwqFlvcsEOy4XrHdmS4tpXiKkcSo+3XJNjq+oT/xfMiH1K
         5tVD0p+ED+8bGG5myzy+2D43vrsoeqYvoIGT7u5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 129/329] f2fs: fix to cover __allocate_new_section() with curseg_lock
Date:   Mon, 17 May 2021 16:00:40 +0200
Message-Id: <20210517140306.475967255@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index ab0a2d2de9a9..73db79d958bd 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2955,19 +2955,23 @@ static void __allocate_new_section(struct f2fs_sb_info *sbi, int type)
 
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



