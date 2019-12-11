Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723BB11B49B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732636AbfLKPZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732662AbfLKPZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6168D208C3;
        Wed, 11 Dec 2019 15:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077920;
        bh=rOdz90QaNrmcTU1JSwFDpea1oaCw02rQheFZW9Px3q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1JXms+b8NzeIcKBeso/hOfpETaCPEqX7Z1suq0XOcByYA3XJ9PPc2aVnaehrdY+5b
         x7Fb7XWxNuOZLA/+9Ldivwpl3daHQGOLIwisAEehHbUWMYdX05MeJjWcxqvAM08tJo
         GBwuEEl2AGHStfCOAj8DAThZXxn+UprkilApJ/bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 4.19 220/243] kernfs: fix ino wrap-around detection
Date:   Wed, 11 Dec 2019 16:06:22 +0100
Message-Id: <20191211150354.181459010@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit e23f568aa63f64cd6b355094224cc9356c0f696b upstream.

When the 32bit ino wraps around, kernfs increments the generation
number to distinguish reused ino instances.  The wrap-around detection
tests whether the allocated ino is lower than what the cursor but the
cursor is pointing to the next ino to allocate so the condition never
triggers.

Fix it by remembering the last ino and comparing against that.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 4a3ef68acacf ("kernfs: implement i_generation")
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/kernfs/dir.c        |    5 ++---
 include/linux/kernfs.h |    1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -624,7 +624,6 @@ static struct kernfs_node *__kernfs_new_
 {
 	struct kernfs_node *kn;
 	u32 gen;
-	int cursor;
 	int ret;
 
 	name = kstrdup_const(name, GFP_KERNEL);
@@ -637,11 +636,11 @@ static struct kernfs_node *__kernfs_new_
 
 	idr_preload(GFP_KERNEL);
 	spin_lock(&kernfs_idr_lock);
-	cursor = idr_get_cursor(&root->ino_idr);
 	ret = idr_alloc_cyclic(&root->ino_idr, kn, 1, 0, GFP_ATOMIC);
-	if (ret >= 0 && ret < cursor)
+	if (ret >= 0 && ret < root->last_ino)
 		root->next_generation++;
 	gen = root->next_generation;
+	root->last_ino = ret;
 	spin_unlock(&kernfs_idr_lock);
 	idr_preload_end();
 	if (ret < 0)
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -186,6 +186,7 @@ struct kernfs_root {
 
 	/* private fields, do not use outside kernfs proper */
 	struct idr		ino_idr;
+	u32			last_ino;
 	u32			next_generation;
 	struct kernfs_syscall_ops *syscall_ops;
 


