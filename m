Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AC66DFA9
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfGSEAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727577AbfGSEAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:00:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF48321852;
        Fri, 19 Jul 2019 04:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508812;
        bh=LQdY3nh7+3V5/CjhVYbG4HiDks5DVAZNmWucKy8b1j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/aHluIowNUs7Ap4i2FNEsqdAHCAbg30lq0Nfw9O/G1zqLiZEILZnQ++EoAcauL57
         bg2nqdHjiHzqB0pdJNQXVDAwrT2azkWOPAuV+RDohFQp0QxjXk3wa9DD7Q90V0HRgh
         C8ZMf+Muleic1ikDAjOVUlRcENQ3bOlqEJfw5cbU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.2 104/171] f2fs: fix is_idle() check for discard type
Date:   Thu, 18 Jul 2019 23:55:35 -0400
Message-Id: <20190719035643.14300-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit 56659ce838456c6f2315ce8a4bd686ac4b23e9d1 ]

The discard thread should issue upto dpolicy->max_requests at once
and wait for all those discard requests at once it reaches
dpolicy->max_requests. It should then sleep for dpolicy->min_interval
timeout before issuing the next batch of discard requests. But in the
current code of is_idle(), it checks for dcc_info->queued_discard and
aborts issuing the discard batch of max_requests. This
dcc_info->queued_discard will be true always once one discard command
is issued.

It is thus resulting into this type of discard request pattern -

- Issue discard request#1
- is_idle() returns false, discard thread waits for request#1 and then
  sleeps for min_interval 50ms.
- Issue discard request#2
- is_idle() returns false, discard thread waits for request#2 and then
  sleeps for min_interval 50ms.
- and so on for all other discard requests, assuming f2fs is idle w.r.t
  other conditions.

With this fix, the pattern will look like this -

- Issue discard request#1
- Issue discard request#2
  and so on upto max_requests of 8
- Issue discard request#8
- wait for min_interval 50ms.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9e6721e15b24..cbdc2f88a98c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2204,7 +2204,7 @@ static inline bool is_idle(struct f2fs_sb_info *sbi, int type)
 		get_pages(sbi, F2FS_DIO_WRITE))
 		return false;
 
-	if (SM_I(sbi) && SM_I(sbi)->dcc_info &&
+	if (type != DISCARD_TIME && SM_I(sbi) && SM_I(sbi)->dcc_info &&
 			atomic_read(&SM_I(sbi)->dcc_info->queued_discard))
 		return false;
 
-- 
2.20.1

