Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F711B547
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732406AbfLKPwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:52:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732314AbfLKPUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56C1B22527;
        Wed, 11 Dec 2019 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077609;
        bh=RrjGEmMkfHkfY3Tx+yXsKTod4IDENxtczAtuVdxmOB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkh95nG2nwVb+Dpjy/FnX4suXKJUyyZxBNXHE5fbncXBmuaSjKNKWGWUdaWwN27qo
         lC3JnkUvNTuVgy7WxfugvmsWkPk2xViegctpx//BHKJooPDyqVqubPDu8YUxXiC4Tq
         5PJmUmTiRxHrOQwQpwjGUDp1ZdledU86ryuHwMDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/243] f2fs: fix to account preflush command for noflush_merge mode
Date:   Wed, 11 Dec 2019 16:04:24 +0100
Message-Id: <20191211150346.005878786@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit a8075dc484cf10ebdb07bee2b17322fb0a846309 ]

Previously, we only account preflush command for flush_merge mode,
so for noflush_merge mode, we can not know in-flight preflush
command count, fix it.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a807a8d5e38f0..0e3e590a250f7 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -637,7 +637,9 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi, nid_t ino)
 		return 0;
 
 	if (!test_opt(sbi, FLUSH_MERGE)) {
+		atomic_inc(&fcc->issing_flush);
 		ret = submit_flush_wait(sbi, ino);
+		atomic_dec(&fcc->issing_flush);
 		atomic_inc(&fcc->issued_flush);
 		return ret;
 	}
-- 
2.20.1



