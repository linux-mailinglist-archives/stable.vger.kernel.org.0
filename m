Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D885A417486
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345359AbhIXNHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345137AbhIXNFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:05:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A83096135F;
        Fri, 24 Sep 2021 12:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488148;
        bh=R3FBaVI5gSbiX45ow1p1r6+3Nbyf4/BGWGda0NcCl2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkOKRb0YmoRooF1esH/KlSP2X37ogRAPgvCMYku1Y9tN6z8KWsmcBHGeUdWEhPwEz
         SFIp6NRxqT/Ty6EjScul/YKCA/ypTmL3DoTt70Tcxw3wkZH/lKKHS4Hth2WU58b9mg
         5alYTrsYnMuYcYXODScr1gjJYE+TrVwhQKEgc0Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 073/100] nilfs2: fix NULL pointer in nilfs_##name##_attr_release
Date:   Fri, 24 Sep 2021 14:44:22 +0200
Message-Id: <20210924124343.881533500@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit dbc6e7d44a514f231a64d9d5676e001b660b6448 ]

In nilfs_##name##_attr_release, kobj->parent should not be referenced
because it is a NULL pointer.  The release() method of kobject is always
called in kobject_put(kobj), in the implementation of kobject_put(), the
kobj->parent will be assigned as NULL before call the release() method.
So just use kobj to get the subgroups, which is more efficient and can fix
a NULL pointer reference problem.

Link: https://lkml.kernel.org/r/20210629022556.3985106-3-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-3-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index d2d8ea89937a..ec85ac53720d 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -51,11 +51,9 @@ static const struct sysfs_ops nilfs_##name##_attr_ops = { \
 #define NILFS_DEV_INT_GROUP_TYPE(name, parent_name) \
 static void nilfs_##name##_attr_release(struct kobject *kobj) \
 { \
-	struct nilfs_sysfs_##parent_name##_subgroups *subgroups; \
-	struct the_nilfs *nilfs = container_of(kobj->parent, \
-						struct the_nilfs, \
-						ns_##parent_name##_kobj); \
-	subgroups = nilfs->ns_##parent_name##_subgroups; \
+	struct nilfs_sysfs_##parent_name##_subgroups *subgroups = container_of(kobj, \
+						struct nilfs_sysfs_##parent_name##_subgroups, \
+						sg_##name##_kobj); \
 	complete(&subgroups->sg_##name##_kobj_unregister); \
 } \
 static struct kobj_type nilfs_##name##_ktype = { \
-- 
2.33.0



