Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC9C40A01E
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348662AbhIMWhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348658AbhIMWgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BC1A61247;
        Mon, 13 Sep 2021 22:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572478;
        bh=0Cen5K5IF/Cncx+iVxmo4t1mkkbSP0w1GtgckFBON20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wk93L1nszW9e9lmCgWbG/W0eVx82CtNPOjI3Pv/pvwf5CYwc8R0Np+GF2vSwMg35J
         YoCp+rjg4q8T1K9FKW7k9eu0+YTeKM1IC24WeyQ1fLejEBgoFt1hL68In5ilOpHAm/
         NCZEEbaq8kv1XUdNON0OWdWHTYGioh7vUW6nXX1yURcisoh4xOyjr9KrpG8lKHNIHq
         hXsx3/0Us5WTjGaw0jMEUAHYH8grtChH4G9TzIrJs0atby2Xju7EnwwndifCk8Zrlx
         uJPn95q/JsNdeKRxDdpxHnjHQCjwDdZzf9SDeBABN86Q5o3GK79IhSNVAln7DXvB7q
         AGQeIF96mt8iQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 17/19] nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
Date:   Mon, 13 Sep 2021 18:34:13 -0400
Message-Id: <20210913223415.435654-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223415.435654-1-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
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
index 5dc468ff5903..34893a57a7b9 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -97,7 +97,7 @@ static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-	kobject_del(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
+	kobject_put(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
 }
 
 /************************************************************************
-- 
2.30.2

