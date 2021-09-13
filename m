Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C4740A0B5
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349547AbhIMWlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349331AbhIMWjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:39:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A170B6135D;
        Mon, 13 Sep 2021 22:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572544;
        bh=oDGtwJ4FGpZDTscMcKSwGi6dBJcwpVGUXU9QH395xKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmbf8+MyMgcgQkyB4ewvwYgi3vSL3KPDEOGOxIpxeKvvotH1eBEjtrrQJsT05YvZp
         bXmHl5iAgzi1FwsIwcG9FIdqm2hk4sbYtff1KITEtFAun7nJxJ8Be5o+kWSiLMpXlG
         XsK+ImHUhNUMNJR0Aqb+CowTAZdjfxwBsOn1tWACbZoMv6qHT2AQZB6jzo2RughwRc
         aKMb+yth3fu2l/0D6WWchzQZgFjuNus4Gbj3oXMblligtKihyWBQedwQ5Nlv/pzdFF
         PcUGEZ8HCm9+ezIX/tGQS3/1nLG4W0ZU1IDpuVY/07wLNqP3OnAHnl3NmL7qWJF4wS
         OSRS8jFgRNo/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 6/9] nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
Date:   Mon, 13 Sep 2021 18:35:32 -0400
Message-Id: <20210913223535.436405-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223535.436405-1-sashal@kernel.org>
References: <20210913223535.436405-1-sashal@kernel.org>
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
index 027a50bc0765..eab7bd68da12 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -101,8 +101,8 @@ static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
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

