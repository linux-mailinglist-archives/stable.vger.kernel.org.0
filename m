Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292B45B7434
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbiIMPTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbiIMPSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:18:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC1357224;
        Tue, 13 Sep 2022 07:35:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3759614AA;
        Tue, 13 Sep 2022 14:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156B7C433D6;
        Tue, 13 Sep 2022 14:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079303;
        bh=KunAitdqsNAr8OHLeGsc+rfXUt+DkWrQu4cvq4FpV7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeRW3xgsmkvXAYd24nHJL8EjDeqDGyI5y+sAgCxz5YlPa3/ekQfn4td5A3e8IYkFw
         WulLqZGLVf2Ys7ALoxRyA33L6N3j1ydRSRhFbU9cTqrFR7OYiI4PUymafh0nULM/e7
         wf/B1tt5nV0OQxCVlY+gt0fT8HILshBlSih///iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Kuyo Chang <kuyo.chang@mediatek.com>
Subject: [PATCH 5.4 081/108] debugfs: add debugfs_lookup_and_remove()
Date:   Tue, 13 Sep 2022 16:06:52 +0200
Message-Id: <20220913140357.110806115@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit dec9b2f1e0455a151a7293c367da22ab973f713e upstream.

There is a very common pattern of using
debugfs_remove(debufs_lookup(..)) which results in a dentry leak of the
dentry that was looked up.  Instead of having to open-code the correct
pattern of calling dput() on the dentry, create
debugfs_lookup_and_remove() to handle this pattern automatically and
properly without any memory leaks.

Cc: stable <stable@kernel.org>
Reported-by: Kuyo Chang <kuyo.chang@mediatek.com>
Tested-by: Kuyo Chang <kuyo.chang@mediatek.com>
Link: https://lore.kernel.org/r/YxIaQ8cSinDR881k@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c      |   22 ++++++++++++++++++++++
 include/linux/debugfs.h |    6 ++++++
 2 files changed, 28 insertions(+)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -743,6 +743,28 @@ void debugfs_remove(struct dentry *dentr
 EXPORT_SYMBOL_GPL(debugfs_remove);
 
 /**
+ * debugfs_lookup_and_remove - lookup a directory or file and recursively remove it
+ * @name: a pointer to a string containing the name of the item to look up.
+ * @parent: a pointer to the parent dentry of the item.
+ *
+ * This is the equlivant of doing something like
+ * debugfs_remove(debugfs_lookup(..)) but with the proper reference counting
+ * handled for the directory being looked up.
+ */
+void debugfs_lookup_and_remove(const char *name, struct dentry *parent)
+{
+	struct dentry *dentry;
+
+	dentry = debugfs_lookup(name, parent);
+	if (!dentry)
+		return;
+
+	debugfs_remove(dentry);
+	dput(dentry);
+}
+EXPORT_SYMBOL_GPL(debugfs_lookup_and_remove);
+
+/**
  * debugfs_remove_recursive - recursively removes a directory
  * @dentry: a pointer to a the dentry of the directory to be removed.  If this
  *          parameter is NULL or an error value, nothing will be done.
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -85,6 +85,8 @@ struct dentry *debugfs_create_automount(
 void debugfs_remove(struct dentry *dentry);
 void debugfs_remove_recursive(struct dentry *dentry);
 
+void debugfs_lookup_and_remove(const char *name, struct dentry *parent);
+
 const struct file_operations *debugfs_real_fops(const struct file *filp);
 
 int debugfs_file_get(struct dentry *dentry);
@@ -216,6 +218,10 @@ static inline void debugfs_remove(struct
 static inline void debugfs_remove_recursive(struct dentry *dentry)
 { }
 
+static inline void debugfs_lookup_and_remove(const char *name,
+					     struct dentry *parent)
+{ }
+
 const struct file_operations *debugfs_real_fops(const struct file *filp);
 
 static inline int debugfs_file_get(struct dentry *dentry)


