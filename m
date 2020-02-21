Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B32D167507
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732338AbgBUIWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388260AbgBUIWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:22:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B53D24672;
        Fri, 21 Feb 2020 08:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273332;
        bh=xQM0uPjZsooTMpC1WG3wcbR5D1vL5bOUNcfjkmPiN3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebARFfQcdEVexjTwf8vOdDFCvgj2epKvmWPwOf35nVJF5BSNWyiGeeT7S7TBxv+my
         Jo5zWBAt7ptFlY+DnBU/LDM2b4w+NcsC5Eq+PpAawmcjfVQO0m5r5SDH9QGrGREsXS
         HHdMYlK9/Ar93wgA/IsKdk55dTPcRbww+qSyWlVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiewei Ke <kejiewei.cn@gmail.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/191] RDMA/rxe: Fix error type of mmap_offset
Date:   Fri, 21 Feb 2020 08:41:06 +0100
Message-Id: <20200221072302.181547119@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6a75f96b90962..b4e24362edbb0 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -407,7 +407,7 @@ struct rxe_dev {
 	struct list_head	pending_mmaps;
 
 	spinlock_t		mmap_offset_lock; /* guard mmap_offset */
-	int			mmap_offset;
+	u64			mmap_offset;
 
 	atomic64_t		stats_counters[RXE_NUM_OF_COUNTERS];
 
-- 
2.20.1



