Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7C3561CE3
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbiF3OLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbiF3OKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC567B37D;
        Thu, 30 Jun 2022 06:55:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39DA3620F8;
        Thu, 30 Jun 2022 13:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488C5C34115;
        Thu, 30 Jun 2022 13:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597336;
        bh=3WLcYukPkXG7NFO+D+klbHU8iLwKoIcsQ0dd21l1KOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xuTXCPDIuCujJMwn0QkfCUmE5eeZBGJ6MYaWL0AcD2fGaldHWeE9BvZ2cJ/JebBWL
         FCSIWIZ/7ZKCRg8aW2qeyG2uRJGLzXlcmWfCpAWMzh/hyjje7bY3wiF0/hJAIXiLTT
         KVrINRACbs/dxVNF3Uj6zGsT26DdthQoIl5roAsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.15 21/28] fs: add i_user_ns() helper
Date:   Thu, 30 Jun 2022 15:47:17 +0200
Message-Id: <20220630133233.552883181@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit a1ec9040a2a9122605ac26e5725c6de019184419 upstream.

Since we'll be passing the filesystem's idmapping in even more places in
the following patches and we do already dereference struct inode to get
to the filesystem's idmapping multiple times add a tiny helper.

Link: https://lore.kernel.org/r/20211123114227.3124056-10-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-10-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-10-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1602,6 +1602,11 @@ struct super_block {
 	struct list_head	s_inodes_wb;	/* writeback inodes */
 } __randomize_layout;
 
+static inline struct user_namespace *i_user_ns(const struct inode *inode)
+{
+	return inode->i_sb->s_user_ns;
+}
+
 /* Helper functions so that in most cases filesystems will
  * not need to deal directly with kuid_t and kgid_t and can
  * instead deal with the raw numeric values that are stored
@@ -1609,22 +1614,22 @@ struct super_block {
  */
 static inline uid_t i_uid_read(const struct inode *inode)
 {
-	return from_kuid(inode->i_sb->s_user_ns, inode->i_uid);
+	return from_kuid(i_user_ns(inode), inode->i_uid);
 }
 
 static inline gid_t i_gid_read(const struct inode *inode)
 {
-	return from_kgid(inode->i_sb->s_user_ns, inode->i_gid);
+	return from_kgid(i_user_ns(inode), inode->i_gid);
 }
 
 static inline void i_uid_write(struct inode *inode, uid_t uid)
 {
-	inode->i_uid = make_kuid(inode->i_sb->s_user_ns, uid);
+	inode->i_uid = make_kuid(i_user_ns(inode), uid);
 }
 
 static inline void i_gid_write(struct inode *inode, gid_t gid)
 {
-	inode->i_gid = make_kgid(inode->i_sb->s_user_ns, gid);
+	inode->i_gid = make_kgid(i_user_ns(inode), gid);
 }
 
 /**


