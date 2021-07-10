Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874103C2DFB
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhGJCZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233040AbhGJCZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE9A7613DF;
        Sat, 10 Jul 2021 02:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883761;
        bh=YpocWr17IC73lrDXfQ8pQR21WQ1hbjgFYsS/FrqkNUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMv9fB+FCSPDLk+EVWIkJg0TeWVM9xt1BlMj1NObKdROWZM0fJ/7QqHkBc6r63Pqf
         mEXUjNS48YGCXxcxLWVTKPxibs8hN8ZD52TLegR4+pMy/uQh7MSxMOyERtBu61Xc/W
         kUQzDGGnI4tuXqS6dMMkKdVmCpW9/lxRoYxlytYtlY2j1NRNgNkute4oe535EnnNRh
         3EKmB1P8yXgFYEQ/THqfEQw4a8zYdJTgfY8LVGcIZ9gWkTMwyp/cTCWf6wwKVvM9b+
         qvAZBKwVv0HGKlHZDjPm+iKX4VBcnHVHpCqFXeKkLpTED4v6/mDPBiahGynASoHpfc
         BBNq4xFZ8wf6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.12 035/104] fs/jfs: Fix missing error code in lmLogInit()
Date:   Fri,  9 Jul 2021 22:20:47 -0400
Message-Id: <20210710022156.3168825-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
index 9330eff210e0..78fd136ac13b 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1324,6 +1324,7 @@ int lmLogInit(struct jfs_log * log)
 		} else {
 			if (!uuid_equal(&logsuper->uuid, &log->uuid)) {
 				jfs_warn("wrong uuid on JFS log device");
+				rc = -EINVAL;
 				goto errout20;
 			}
 			log->size = le32_to_cpu(logsuper->size);
-- 
2.30.2

