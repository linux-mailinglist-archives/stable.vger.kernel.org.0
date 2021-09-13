Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0066740A0F6
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349750AbhIMWnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349521AbhIMWlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3EB561250;
        Mon, 13 Sep 2021 22:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572569;
        bh=cqqhkH49/TaQMJQIfVvYgZWmK7KGBy4IIQERaxebQ0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2vdFBPjpmddNkTJQ9y/lC08vnh81CTBhl1zR76+qp1arqhCxagWZsW75xnfK3lHD
         mJJQ8atoNZ6R/U9tPvhQVty8OOuckuwisPp8gD3VTEtZUjt/Bhpxam5TmSKj6xsgMU
         CdkAowEUJD5ggmx2MGUz6XpSUwXaM5JukodONpBCTifQI+VKYdJtOpwslqlI0Z6d2u
         7ERvOVNEzQSPUVB2gRnjZsSUKQIqb1eJxseQomUrc+DNSmV/La3e+Mb1up4OQ7zgMj
         2PK0KnPBZ7peLrHacFaBAwFp1M4Tc1lITG2TJPDBDfa1v6RAwwY9Pp4ktHcXvAlwdQ
         PNkWwQVXLOmdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 6/8] nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
Date:   Mon, 13 Sep 2021 18:35:59 -0400
Message-Id: <20210913223601.436675-6-sashal@kernel.org>
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

[ Upstream commit a3e181259ddd61fd378390977a1e4e2316853afa ]

The kobject_put() should be used to cleanup the memory associated with the
kobject instead of kobject_del.  See the section "Kobject removal" of
"Documentation/core-api/kobject.rst".

Link: https://lkml.kernel.org/r/20210629022556.3985106-5-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-5-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index e8d4828287c3..8a0af1e378c1 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -106,7 +106,7 @@ static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-	kobject_del(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
+	kobject_put(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
 }
 
 /************************************************************************
-- 
2.30.2

