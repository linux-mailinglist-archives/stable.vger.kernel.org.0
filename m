Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B86D1FE7FE
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgFRBLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727825AbgFRBLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBA2B21D93;
        Thu, 18 Jun 2020 01:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442661;
        bh=jqpU5mQo/WRf0mgPkzlyjkWGZbn3JmjBFcNLaPQbtmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7kL1IB2a6507HTzQZF0lLFSXGsOkuooKAtOGp7bC0JZ3k9vT0rc6DbJhD5KYXAKv
         XkV20/48/3/SynHEMBmVm7JuO4lrYLQagrBpomU8+feeVi1pcsmksX+of8BpE7JkyS
         FRq7t0rVP39MIEGBEhzsfshy8U05tiS0kZrgDnL4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 132/388] fuse: BUG_ON correction in fuse_dev_splice_write()
Date:   Wed, 17 Jun 2020 21:03:49 -0400
Message-Id: <20200618010805.600873-132-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 0e9fb6f17ad5b386b75451328975a07d7d953c6d ]

commit 963545357202 ("fuse: reduce allocation size for splice_write")
changed size of bufs array, so BUG_ON which checks the index of the array
shold also be fixed.

[SzM: turn BUG_ON into WARN_ON]

Fixes: 963545357202 ("fuse: reduce allocation size for splice_write")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 97eec7522bf2..5c155437a455 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1977,8 +1977,9 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
 		struct pipe_buffer *ibuf;
 		struct pipe_buffer *obuf;
 
-		BUG_ON(nbuf >= pipe->ring_size);
-		BUG_ON(tail == head);
+		if (WARN_ON(nbuf >= count || tail == head))
+			goto out_free;
+
 		ibuf = &pipe->bufs[tail & mask];
 		obuf = &bufs[nbuf];
 
-- 
2.25.1

