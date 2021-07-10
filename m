Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305C63C30AD
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhGJCg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53317 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhGJCfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1F00613D9;
        Sat, 10 Jul 2021 02:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884339;
        bh=Q1c5JGV5YQnVsTvRoWkgxCNaBmJQ/SpMquTXLSKYiy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Btva0o9ONgat297BO/cyUOz6TbYo3OallqNgXJ55T6VZV9qvfzDXnuVXK8kLiLhBb
         BlDYo0aMBqhvsBs+dQf5ZQpb/B+hwoRCGA4DBer5gTQo00nvUcnA01U7Z53YMAZetk
         Op6gbcgC8o31qd27uOevNIOuHLjj7CVrAhLbPbZGZycmAYO64cIggu5sRYem1TUCbz
         WCiTPRu6PQ8k53za5NCxM4LMrnHmdXNW5fSoA5e++l+JOaSRtD9EIcyb8SgAjM1G6t
         LLZKfjveZtGKvGe2PFtv+Y4Q2fA8FwZNc7MUFjxv4XjlZIUmPmC8hGTrsrggN4g5S5
         3sXVxu0gdWqzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 12/39] fs/jfs: Fix missing error code in lmLogInit()
Date:   Fri,  9 Jul 2021 22:31:37 -0400
Message-Id: <20210710023204.3171428-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 492109333c29e1bb16d8732e1d597b02e8e0bf2e ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'rc.

Eliminate the follow smatch warning:

fs/jfs/jfs_logmgr.c:1327 lmLogInit() warn: missing error code 'rc'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_logmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 6b68df395892..356d1fcf7119 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1338,6 +1338,7 @@ int lmLogInit(struct jfs_log * log)
 		} else {
 			if (memcmp(logsuper->uuid, log->uuid, 16)) {
 				jfs_warn("wrong uuid on JFS log device");
+				rc = -EINVAL;
 				goto errout20;
 			}
 			log->size = le32_to_cpu(logsuper->size);
-- 
2.30.2

