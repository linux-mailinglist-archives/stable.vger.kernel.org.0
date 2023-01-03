Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1B665BBB2
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbjACIP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjACIPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E44DF3C
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:15:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E06D4B80E49
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DA5C433D2;
        Tue,  3 Jan 2023 08:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733706;
        bh=9G4Pv9Gt39/6SAjBBLxJSaHaXDOBFavoT07Za35EAVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZADW0zGLSUnbtYiHhQvmCp0tgVq0Oi9Q1gAM9acG3RfFlsUWex1N/1+90x701KF4a
         ljQUPcAkt4JiOUv28MmEu3xkJQvt+Xx/Di+utf4/kWNxH2RVOMw/8tIkjlvQVYV8uY
         zXibq1x0LKMOZqJhCzSo7LD5yTZL0PNLqTRa1Emw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 06/63] Make sure nd->path.mnt and nd->path.dentry are always valid pointers
Date:   Tue,  3 Jan 2023 09:13:36 +0100
Message-Id: <20230103081308.942805751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 7d01ef7585c07afaf487759a48486228cd065726 ]

Initialize them in set_nameidata() and make sure that terminate_walk() clears them
once the pointers become potentially invalid (i.e. we leave RCU mode or drop them
in non-RCU one).  Currently we have "path_init() always initializes them and nobody
accesses them outside of path_init()/terminate_walk() segments", which is asking
for trouble.

With that change we would have nd->path.{mnt,dentry}
	1) always valid - NULL or pointing to currently allocated objects.
	2) non-NULL while we are successfully walking
	3) NULL when we are not walking at all
	4) contributing to refcounts whenever non-NULL outside of RCU mode.

Fixes: 6c6ec2b0a3e0 ("fs: add support for LOOKUP_CACHED")
Reported-by: syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com
Tested-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -529,6 +529,8 @@ static void set_nameidata(struct nameida
 	p->stack = p->internal;
 	p->dfd = dfd;
 	p->name = name;
+	p->path.mnt = NULL;
+	p->path.dentry = NULL;
 	p->total_link_count = old ? old->total_link_count : 0;
 	p->saved = old;
 	current->nameidata = p;
@@ -602,6 +604,8 @@ static void terminate_walk(struct nameid
 		rcu_read_unlock();
 	}
 	nd->depth = 0;
+	nd->path.mnt = NULL;
+	nd->path.dentry = NULL;
 }
 
 /* path_put is needed afterwards regardless of success or failure */
@@ -2243,8 +2247,6 @@ static const char *path_init(struct name
 	}
 
 	nd->root.mnt = NULL;
-	nd->path.mnt = NULL;
-	nd->path.dentry = NULL;
 
 	/* Absolute pathname -- fetch the root (LOOKUP_IN_ROOT uses nd->dfd). */
 	if (*s == '/' && !(flags & LOOKUP_IN_ROOT)) {


