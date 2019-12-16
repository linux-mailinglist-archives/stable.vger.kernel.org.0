Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C341218DE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfLPSqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:46:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728145AbfLPR4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:56:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B60220733;
        Mon, 16 Dec 2019 17:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518961;
        bh=bOCEoTcvdDfPaHOhajk1tunpiBuyvJShyLlO5Cu5dX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKKif3XrbBMIz5xhGPFpQH3mfj+B0/RzTVg+eGUMKCVKR2iciELRaDrd8fZKusVla
         ZN/tYEtJSjYoPy9QCR6l42byeaJzgE87H44rPlsXZPSlkTTyeFEEbsVv8JkwcWiL1c
         aGvAFoy1vu1Q1iiYuM2hWUBTRq7iv7hcEYm5Bigg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 4.14 137/267] kernfs: fix ino wrap-around detection
Date:   Mon, 16 Dec 2019 18:47:43 +0100
Message-Id: <20191216174908.845079069@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
@@ -623,7 +623,6 @@ static struct kernfs_node *__kernfs_new_
 {
 	struct kernfs_node *kn;
 	u32 gen;
-	int cursor;
 	int ret;
 
 	name = kstrdup_const(name, GFP_KERNEL);
@@ -636,11 +635,11 @@ static struct kernfs_node *__kernfs_new_
 
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
@@ -185,6 +185,7 @@ struct kernfs_root {
 
 	/* private fields, do not use outside kernfs proper */
 	struct idr		ino_idr;
+	u32			last_ino;
 	u32			next_generation;
 	struct kernfs_syscall_ops *syscall_ops;
 


