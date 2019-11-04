Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C7FEF17D
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 01:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbfKDX7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 18:59:53 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39396 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729714AbfKDX7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 18:59:52 -0500
Received: by mail-qt1-f196.google.com with SMTP id t8so26772668qtc.6;
        Mon, 04 Nov 2019 15:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LMhymltIw4we4fZsZLdmQ/16XCXhEvoGcZblYC0fAkI=;
        b=sqhJlONVSwk7PR1KsI0/z7ceSN3Yxbham9y89DftqEQCIhYyFExXMklDI1poiTc5dc
         478Ypm29RblYnPiZVNQ/XltUCHE0b4AUQw8BE5b0ruvd1hV77jxiJ98p0h5Y+UADNkEM
         FkCZDZmIqbJm4SB3A/N8NVQ3E181FsliQa+otNX3bFuaD+2Qe/dZWwNZgMDc87g8tkrK
         HdQE7gADZBjojBd6+XivqHB+Rslbe6gHaZvlKn8RKGUX6I0gjxjRfsa9M+tKZuqOCGxD
         DGYOLQvqs4xvmSOX4IODQlJizmEyMM1TCCCR6Ysx9hitXpLg1VS8chyK/IPaKBJ+zQYB
         UwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=LMhymltIw4we4fZsZLdmQ/16XCXhEvoGcZblYC0fAkI=;
        b=PA5OMpAR6UHQMb3RAsVITQVAILSB5pSOmJD9xBK4XOLQhyuO2IezPMJjoS+q5VC7cv
         CcAIuQam9g/i6HDJWNvb+6sWHzGSRsdvg9jEon156RIwyoU0Tk+bsXqLAbVqRHGdhRDz
         Bpth3Oeuwuw9XwCSltHBlVTkOnaqYXrs0DDCxKx2lGja8kscn19DAlOQmMTcUn4W3nYJ
         BKPvmDgr/5GjjBAq6+NN+w4ZEQRe3NyLhDI7rm94SFgBkJrtUp5YVlisTdJ9GVBMN5WK
         kSQTNTBDRl+m4QJFux9wfvW3nkIq6zSa5STqycGaot7KYgBDiP2veplbZc6zYZkB/bYA
         rJNA==
X-Gm-Message-State: APjAAAXIahP/gcv1lKoACIRsxWVbq8QElIxQMAZDabdqMoY94guiAv5c
        6bwzlakvdi/yoLCd0WfohqI=
X-Google-Smtp-Source: APXvYqw63LOmaG1YBScyx6JNA9MBRDMgAuDKk/mM6juvIH+XKkMPhOyzTt59GeD8vuAdPu058m52dw==
X-Received: by 2002:a0c:b918:: with SMTP id u24mr24982185qvf.212.1572911991031;
        Mon, 04 Nov 2019 15:59:51 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::3:51f8])
        by smtp.gmail.com with ESMTPSA id x203sm9292720qkb.11.2019.11.04.15.59.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Nov 2019 15:59:50 -0800 (PST)
From:   Tejun Heo <tj@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     kernel-team@fb.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 01/10] kernfs: fix ino wrap-around detection
Date:   Mon,  4 Nov 2019 15:59:35 -0800
Message-Id: <20191104235944.3470866-2-tj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191104235944.3470866-1-tj@kernel.org>
References: <20191104235944.3470866-1-tj@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the 32bit ino wraps around, kernfs increments the generation
number to distinguish reused ino instances.  The wrap-around detection
tests whether the allocated ino is lower than what the cursor but the
cursor is pointing to the next ino to allocate so the condition never
triggers.

Fix it by remembering the last ino and comparing against that.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 4a3ef68acacf ("kernfs: implement i_generation")
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org # v4.14+
---
 fs/kernfs/dir.c        | 5 ++---
 include/linux/kernfs.h | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 6ebae6bbe6a5..7d4af6cea2a6 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -622,7 +622,6 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 {
 	struct kernfs_node *kn;
 	u32 gen;
-	int cursor;
 	int ret;
 
 	name = kstrdup_const(name, GFP_KERNEL);
@@ -635,11 +634,11 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 
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
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 936b61bd504e..f797ccc650e7 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -187,6 +187,7 @@ struct kernfs_root {
 
 	/* private fields, do not use outside kernfs proper */
 	struct idr		ino_idr;
+	u32			last_ino;
 	u32			next_generation;
 	struct kernfs_syscall_ops *syscall_ops;
 
-- 
2.17.1

