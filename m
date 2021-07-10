Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6BC3C3156
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhGJClN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235611AbhGJCji (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D70ED613DC;
        Sat, 10 Jul 2021 02:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884528;
        bh=AxcRIq/z8eifYW10F8v9/RyGoCJ5kpcBD/0zKisuXcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbMafLH8Ze+UNIxpWKlGkvHOcVa651o2uWoQQsX/jXI2V079+K6vZVi8EnwTZrIon
         DiJHQCjvefrXI61dOoafytypOsr6huYQVWwtcBdqrHva76O/zvXw1tYA8wbz1sZYUU
         i+vo1JEFvUhlREBb0w1b14yQZnx+NXr2iUzYrAZJQNwWc0qaNuFAhbNBkEt4XQw8sb
         xP1d/SNdCQty0weu6C7+W1M5dxJcd+gHFL7wEeSfriIvzEihhfm00Mh8J6JEHa80po
         /mGXU7m1Bm0bGX6ojtWwjDRS83KcPqXTKUCaIAMtfYeF1xSeMQFAve1VcOe0odRUAL
         l2XquAQBwr2FQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 10/33] fs/jfs: Fix missing error code in lmLogInit()
Date:   Fri,  9 Jul 2021 22:34:52 -0400
Message-Id: <20210710023516.3172075-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023516.3172075-1-sashal@kernel.org>
References: <20210710023516.3172075-1-sashal@kernel.org>
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
index 0e5d412c0b01..794c2acb6822 100644
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

