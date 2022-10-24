Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB59E60BB54
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbiJXU4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbiJXU4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:56:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E600F2413CA;
        Mon, 24 Oct 2022 12:02:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 759A5B81330;
        Mon, 24 Oct 2022 12:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BB6C433D7;
        Mon, 24 Oct 2022 12:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613311;
        bh=QOy3cjI1C0pLjk5Kou9W52sE41We3XgJT9GQSvfzZZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFs6R6hFdr54lQ59ZL1Q+Pex0r8aByLmHA1QoHbklt4VdzvTjEhL/cJlkEHV51qgA
         EJAIlCtmCGpJ+D3MsWr+vt5TJhKdVETKIiZlMdnOqX1Rm8K5tiVXSlLCMGCjWUyh6n
         +RP1YsfK6al72p4i56IDZQ3JJZaiIXWYx0fPISkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert OCallahan <roc@ocallahan.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/255] userfaultfd: open userfaultfds with O_RDONLY
Date:   Mon, 24 Oct 2022 13:29:29 +0200
Message-Id: <20221024113004.455015344@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit abec3d015fdfb7c63105c7e1c956188bf381aa55 ]

Since userfaultfd doesn't implement a write operation, it is more
appropriate to open it read-only.

When userfaultfds are opened read-write like it is now, and such fd is
passed from one process to another, SELinux will check both read and
write permissions for the target process, even though it can't actually
do any write operation on the fd later.

Inspired by the following bug report, which has hit the SELinux scenario
described above:
https://bugzilla.redhat.com/show_bug.cgi?id=1974559

Reported-by: Robert O'Callahan <roc@ocallahan.org>
Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index ec57bbb6bb05..740853465356 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1018,7 +1018,7 @@ static int resolve_userfault_fork(struct userfaultfd_ctx *ctx,
 	int fd;
 
 	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, new,
-			      O_RDWR | (new->flags & UFFD_SHARED_FCNTL_FLAGS));
+			      O_RDONLY | (new->flags & UFFD_SHARED_FCNTL_FLAGS));
 	if (fd < 0)
 		return fd;
 
@@ -1969,7 +1969,7 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	mmgrab(ctx->mm);
 
 	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, ctx,
-			      O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
+			      O_RDONLY | (flags & UFFD_SHARED_FCNTL_FLAGS));
 	if (fd < 0) {
 		mmdrop(ctx->mm);
 		kmem_cache_free(userfaultfd_ctx_cachep, ctx);
-- 
2.35.1



