Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C334F37C7A1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbhELQB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237953AbhELP44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8B4261C1D;
        Wed, 12 May 2021 15:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833356;
        bh=B4APKrOqsAM9U0/vz34PLAMlzKTDs6SABiAri1nNwaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avtGzJVPU+9mWVbIXU6LfOcuyBaCLA7rblaCKmt6d0yFPjwSw6cgkt8Mc6rgXU4zK
         dr2/iqBuCIYLL4jNukHDjXwVJKNCAmcgtCbtpgs+IugG7XxM+lXvdvUaoKz6rM+f8U
         xu5Wj/fpugcgG/QcAtGGxR/dCGL8Fof2bDmk0Ql8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.11 118/601] ovl: fix missing revert_creds() on error path
Date:   Wed, 12 May 2021 16:43:15 +0200
Message-Id: <20210512144831.719905285@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 7b279bbfd2b230c7a210ff8f405799c7e46bbf48 upstream.

Smatch complains about missing that the ovl_override_creds() doesn't
have a matching revert_creds() if the dentry is disconnected.  Fix this
by moving the ovl_override_creds() until after the disconnected check.

Fixes: aa3ff3c152ff ("ovl: copy up of disconnected dentries")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -932,7 +932,7 @@ static int ovl_copy_up_one(struct dentry
 static int ovl_copy_up_flags(struct dentry *dentry, int flags)
 {
 	int err = 0;
-	const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
+	const struct cred *old_cred;
 	bool disconnected = (dentry->d_flags & DCACHE_DISCONNECTED);
 
 	/*
@@ -943,6 +943,7 @@ static int ovl_copy_up_flags(struct dent
 	if (WARN_ON(disconnected && d_is_dir(dentry)))
 		return -EIO;
 
+	old_cred = ovl_override_creds(dentry->d_sb);
 	while (!err) {
 		struct dentry *next;
 		struct dentry *parent = NULL;


