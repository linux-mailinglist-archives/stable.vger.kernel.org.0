Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740D74173A1
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344722AbhIXM7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344253AbhIXM4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:56:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B81E461355;
        Fri, 24 Sep 2021 12:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487903;
        bh=xiyZqlbaRpJ8num4MXbLXtQ5Tpeb4qTgDghpzXiLJwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1DxvrBF4coY99UiKwrNffUV5YgxII7CLYmVQOwZ9FfiC+R2od3oZfYQgu+UV/bMn
         Z4NwSqY/O3b/VUaSc4ghPfKWh+yXpNlwIAtlinIzeZYfBONErDVot9SEg/CjgirDlE
         BUCBjcjXBs7Q3o6LmBEt4iZ+SYOYm7dHhKmtxY+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/50] nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
Date:   Fri, 24 Sep 2021 14:44:31 +0200
Message-Id: <20210924124333.670564674@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 31d640a87b59..195f42192a15 100644
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
2.33.0



