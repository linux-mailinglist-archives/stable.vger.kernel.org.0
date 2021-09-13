Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E736F40A056
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349187AbhIMWi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343736AbhIMWgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 922DA6121F;
        Mon, 13 Sep 2021 22:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572499;
        bh=JJxAlnMO1RtxGCmp4Tk/rVED7CmQ4t0m16eubjcGGEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSIxIAvEdTqEGcHqKvQZPdoowaLZI/xKeUio0VLutqa4jhorx25KZUA7WHVEzC6gF
         UwxpaQ4RNGjBR8HjUY6+P4I9V+YPut8Fk1CQOgdvICnEGxRpCidACQsfy1v43w8qrY
         QvNqXCGT5l2wGmr8oFzh4S1G6FEo9WhaNWasykfT1caCwYDH4qDpItEO3zZRcnOr44
         ObdpPnVXpNcfiufTTgieHGSMc9nGKuwmG7DSfGByQ6OFC/MrTPU7nC9ZHrNzcWEOnA
         awC1BytW+1shuMltweYIhH0fNrCpjFjso2ChilWHyu6vP5viiJ0Vp8zlZMwrs0Ey+z
         dxu6ZcF849bOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/16] nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
Date:   Mon, 13 Sep 2021 18:34:39 -0400
Message-Id: <20210913223442.435885-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223442.435885-1-sashal@kernel.org>
References: <20210913223442.435885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit 24f8cb1ed057c840728167dab33b32e44147c86f ]

If kobject_init_and_add return with error, kobject_put() is needed here to
avoid memory leak, because kobject_init_and_add may return error without
freeing the memory associated with the kobject it allocated.

Link: https://lkml.kernel.org/r/20210629022556.3985106-4-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-4-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 43f660beb9b4..5dc468ff5903 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -92,8 +92,8 @@ static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
 	err = kobject_init_and_add(kobj, &nilfs_##name##_ktype, parent, \
 				    #name); \
 	if (err) \
-		return err; \
-	return 0; \
+		kobject_put(kobj); \
+	return err; \
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-- 
2.30.2

