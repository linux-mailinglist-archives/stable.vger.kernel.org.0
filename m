Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0751064F2
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfKVGUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:20:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728659AbfKVFwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA5BB20721;
        Fri, 22 Nov 2019 05:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401964;
        bh=zYB41gfG09mqdRPWxWlUgH4vOV0svqU0ru6XZw2f+fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVGilCmF8MINlzYUHOHTFM8xcg4SCnmbr7l8oY0D2MikRnwsMTZ8k3/nX4nMYT7m5
         D8JBeKovtVQRK4MhfxM7zz9tesdm7Ohy3cAr361BVNkCJTX8+ny6NzFfu0VmRLr/Ra
         mMcWxR+GskYdMV/l26tvBmBurjWVjjp5c6cNXkIw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 185/219] blktrace: Show requests without sector
Date:   Fri, 22 Nov 2019 00:48:37 -0500
Message-Id: <20191122054911.1750-178-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 0803de78049fe1b0baf44bcddc727b036fb9139b ]

Currently, blktrace will not show requests that don't have any data as
rq->__sector is initialized to -1 which is out of device range and thus
discarded by act_log_check(). This is most notably the case for cache
flush requests sent to the device. Fix the problem by making
blk_rq_trace_sector() return 0 for requests without initialized sector.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blktrace_api.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 8804753805ac5..7bb2d8de9f308 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -116,7 +116,13 @@ extern void blk_fill_rwbs(char *rwbs, unsigned int op, int bytes);
 
 static inline sector_t blk_rq_trace_sector(struct request *rq)
 {
-	return blk_rq_is_passthrough(rq) ? 0 : blk_rq_pos(rq);
+	/*
+	 * Tracing should ignore starting sector for passthrough requests and
+	 * requests where starting sector didn't get set.
+	 */
+	if (blk_rq_is_passthrough(rq) || blk_rq_pos(rq) == (sector_t)-1)
+		return 0;
+	return blk_rq_pos(rq);
 }
 
 static inline unsigned int blk_rq_trace_nr_sectors(struct request *rq)
-- 
2.20.1

