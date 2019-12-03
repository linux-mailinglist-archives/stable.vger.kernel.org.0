Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542D5111EA3
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbfLCWxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:53:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729974AbfLCWxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21DE920863;
        Tue,  3 Dec 2019 22:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413585;
        bh=nlJQSV6D7K30L7axStfXLfJKfWWZC5V9NsCTqszuzXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJKp6mgCZ1JG2AQqucbuhj862XbyIS2ArdyEaH727+fkRZQuPNNxhNcrIQGuypNph
         hDfuYaXw/mCaRe1tRYgEbB7xjjv9AbeI7LazhzI40O255k9+LimG6KkIB+p3dAwpXb
         5EA8+w2X7Gr31teDWzjmhPcXnvg+rNYa4SJNk7Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuyang Sun <sunqiuyang@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 185/321] f2fs: fix block address for __check_sit_bitmap
Date:   Tue,  3 Dec 2019 23:34:11 +0100
Message-Id: <20191203223436.747401927@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiuyang Sun <sunqiuyang@huawei.com>

[ Upstream commit 9249dded7b5cb539a8c8698b25d08a3c15261470 ]

Should use lstart (logical start address) instead of start (in dev) here.
This fixes a bug in multi-device scenarios.

Signed-off-by: Qiuyang Sun <sunqiuyang@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 43a07514c3574..a807a8d5e38f0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1103,7 +1103,7 @@ submit:
 		list_move_tail(&dc->list, wait_list);
 
 		/* sanity check on discard range */
-		__check_sit_bitmap(sbi, start, start + len);
+		__check_sit_bitmap(sbi, lstart, lstart + len);
 
 		bio->bi_private = dc;
 		bio->bi_end_io = f2fs_submit_discard_endio;
-- 
2.20.1



