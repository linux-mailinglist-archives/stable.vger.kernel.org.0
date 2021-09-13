Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBE940A0FD
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349535AbhIMWnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348901AbhIMWlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38D1A61264;
        Mon, 13 Sep 2021 22:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572571;
        bh=ekuu+j5sqteKEeoM1Rl8ALM+PbUP6fGe4Cn6hDSMX+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHWdVTWoGjGSU3MBopymatCBLKgoi/k29Wswk+Go+0c+svgRWTwoIpKoaGqRtwRpm
         cfOri/Lh77HRs7xj2RSzDMqrVFLNsG+2ftOM+2x8mVmsCF3c18Kc/USJcqHxf0meUj
         Dsi/mb0eST/kxJ7cGZ3bBzoYcXeqB2u6uityFlSw8UrWJQPalhCMTuLgsuDOBa2Aoq
         2xanY1rZffoaZRHECl/WfG/yQDU31D0hVQvT53PgktXRK1AHTfj7ijL/QwYCGTq8WR
         dobERjFZZoD1Has6PVG+SIJLswisdQJ79+hTuDOSTHlNdQabOkPPT8fuCixfmgSm74
         +D3vQ2DADrwlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 7/8] nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
Date:   Mon, 13 Sep 2021 18:36:00 -0400
Message-Id: <20210913223601.436675-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223601.436675-1-sashal@kernel.org>
References: <20210913223601.436675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit b2fe39c248f3fa4bbb2a20759b4fdd83504190f7 ]

If kobject_init_and_add returns with error, kobject_put() is needed here
to avoid memory leak, because kobject_init_and_add may return error
without freeing the memory associated with the kobject it allocated.

Link: https://lkml.kernel.org/r/20210629022556.3985106-6-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-6-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 8a0af1e378c1..73d872a24a21 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -217,9 +217,9 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 	}
 
 	if (err)
-		return err;
+		kobject_put(&root->snapshot_kobj);
 
-	return 0;
+	return err;
 }
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
-- 
2.30.2

