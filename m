Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9CC11AF36
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfLKPLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730036AbfLKPLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04ACD208C3;
        Wed, 11 Dec 2019 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077108;
        bh=NGnFn9nHpuHhYGvP9pAM7mshyTnwuL5ajlVrjkVg0OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UoLEAcAeGBBgJcrnVt9G1AX4ONE2snadu84rskyua0SLN1NLAEjt5EZtiTrNKEYBJ
         5x95Q7X4SEWEyA+eUL/hl0bxkBXIjrsEpMN56YdFxJ7Cdrdf2FdivmzCuYW9JoMzjW
         EwvN3gMkU9tChFIOoLaGAA+DHzh0IxYv8tDU7l6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thibaut Sautereau <thibaut@sautereau.fr>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 020/105] cgroup: dont put ERR_PTR() into fc->root
Date:   Wed, 11 Dec 2019 16:05:09 +0100
Message-Id: <20191211150226.742272740@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 630faf81b3e61bcc90dc6d8b497800657d2752a5 ]

the caller of ->get_tree() expects NULL left there on error...

Reported-by: Thibaut Sautereau <thibaut@sautereau.fr>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 8be1da1ebd9a4..f23862fa15146 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2119,11 +2119,12 @@ int cgroup_do_get_tree(struct fs_context *fc)
 
 		nsdentry = kernfs_node_dentry(cgrp->kn, sb);
 		dput(fc->root);
-		fc->root = nsdentry;
 		if (IS_ERR(nsdentry)) {
-			ret = PTR_ERR(nsdentry);
 			deactivate_locked_super(sb);
+			ret = PTR_ERR(nsdentry);
+			nsdentry = NULL;
 		}
+		fc->root = nsdentry;
 	}
 
 	if (!ctx->kfc.new_sb_created)
-- 
2.20.1



