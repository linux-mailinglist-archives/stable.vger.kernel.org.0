Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6141B3C2FAF
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhGJCcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234152AbhGJCae (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CBC861420;
        Sat, 10 Jul 2021 02:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884053;
        bh=YpocWr17IC73lrDXfQ8pQR21WQ1hbjgFYsS/FrqkNUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mc318lkViGqyh/BbEXCJZqwpOAibvdxDdp1PXzwz5KkGLI7N0PHT436OHzvUA/7xW
         25ffUCVTvlxRvGUUGr7NF4JG/ZOearNE9QivVoL2+Mz9oanBqNrUHiY8XvskdgFRBc
         Uio+SQ0bkU39+nyZIdv/gfPwPffUDltWX1BmbcrnOPkEKDUQoadBVB2O/eaj3TH5iE
         JU6+KToIMXRh8Z3OLmiMn8pXw1FtezXzlE/VTFw+sxz7Z1/+ALSt2OBSeBCLb01u3D
         xMrUjseNv/FyNyJxX+mmTSlUCOrFW6uz6twkoauuj3YHKpeGhRQ+ePWl99e1LkzFmY
         GSnEQWhcPlyeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 19/63] fs/jfs: Fix missing error code in lmLogInit()
Date:   Fri,  9 Jul 2021 22:26:25 -0400
Message-Id: <20210710022709.3170675-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
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

