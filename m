Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37AD4173A2
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345293AbhIXM7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344653AbhIXM4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:56:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F7ED60E8B;
        Fri, 24 Sep 2021 12:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487900;
        bh=Kw1ekoYG9pMOhpMBdg5yUJvJIespP166y6hX4RuXWLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owg0Ks82ewMlVHuE0/hfWgIuqbxkdEbPJhDC2tgZv4Kmpu39Tp7enoeknDFqs+Kbq
         fR+qUqLzH2syreA9s/o5X2Vtr7znwujTqmhWQy3lPYucbvOiaSIJXao+iPDxD9+WwK
         I3hed9Oo+mr89niI4qRbIutNKyV114nt+YS73ves=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/50] nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
Date:   Fri, 24 Sep 2021 14:44:30 +0200
Message-Id: <20210924124333.636527089@linuxfoundation.org>
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
index ca720d958315..31d640a87b59 100644
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
2.33.0



