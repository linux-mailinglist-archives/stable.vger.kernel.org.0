Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8771F15E541
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388744AbgBNQkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:40:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393308AbgBNQXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:23:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B0FD24764;
        Fri, 14 Feb 2020 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697380;
        bh=p5e5+dj/rRUMiUhx7SjErNTvVSgmlKbtP28hNVhouik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+NWyJHNCnsZMS5cjpKt67tZdTHTqDlQBkd7SU6N7c/zxQn7r0kqWd2Gd16liCw9W
         o2e43Etq8wMUnrMJ6vpDlyJ2ZaFJCa+MsMJ9W9LxMBmKGromuaXJIUCfSHQOOo0gaC
         6bTy1dFZ2UCihFFt8cqFUbKrIDfONHMkUzAWsm7U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiewei Ke <kejiewei.cn@gmail.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 077/141] RDMA/rxe: Fix error type of mmap_offset
Date:   Fri, 14 Feb 2020 11:20:17 -0500
Message-Id: <20200214162122.19794-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiewei Ke <kejiewei.cn@gmail.com>

[ Upstream commit 6ca18d8927d468c763571f78c9a7387a69ffa020 ]

The type of mmap_offset should be u64 instead of int to match the type of
mminfo.offset. If otherwise, after we create several thousands of CQs, it
will run into overflow issues.

Link: https://lore.kernel.org/r/20191227113613.5020-1-kejiewei.cn@gmail.com
Signed-off-by: Jiewei Ke <kejiewei.cn@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 47003d2a4a46e..dee3853163b60 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -422,7 +422,7 @@ struct rxe_dev {
 	struct list_head	pending_mmaps;
 
 	spinlock_t		mmap_offset_lock; /* guard mmap_offset */
-	int			mmap_offset;
+	u64			mmap_offset;
 
 	struct rxe_port		port;
 	struct list_head	list;
-- 
2.20.1

