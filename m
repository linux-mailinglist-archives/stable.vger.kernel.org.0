Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8AA797AA
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390287AbfG2TuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389880AbfG2TuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:50:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BEE92054F;
        Mon, 29 Jul 2019 19:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429812;
        bh=YT0Kd2W3fZQBfMb/+keZDlejzkDQF5rC1uaRgJMDZnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fy9u3dYT5jwhtfUutmNxIanG/csVgkgXFbATn1hHWLCDJIW4qq3jmtsHXgBpI9R6P
         LVqJXy2ja92Slm5lQ9LMp47JXMGkluLR2K8ph8kAmR4vQwyp3x4QJkTXwltE1P9/4r
         ntlUN0NQZbsHQ+7C7SBtBujfx86GVXxk8Y6U3nr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 102/215] f2fs: fix is_idle() check for discard type
Date:   Mon, 29 Jul 2019 21:21:38 +0200
Message-Id: <20190729190756.728874297@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



