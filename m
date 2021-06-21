Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFE13AEE2B
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhFUQ0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232071AbhFUQYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:24:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 435C061378;
        Mon, 21 Jun 2021 16:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292480;
        bh=p0DFBrSnvxVD4MSeELjn0doLekILJPIc78yHqPnq5xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TeggcH0hGLmMuSV0feMiVKIlqjFmBLkdbD+6ww4oTfOaVP32KiiDtypN62ioxMKae
         IWaOJxZUYeFiatjdNak/vsv0NOj3SVzW+tDnbV47KtkIZIxnGcMffZUyN2XozuEvzC
         8mQGKIhROzLWVDdCTPBH4HsIm2QwSv2vjTFq4BIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/146] afs: Fix an IS_ERR() vs NULL check
Date:   Mon, 21 Jun 2021 18:13:58 +0200
Message-Id: <20210621154911.530992343@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a33d62662d275cee22888fa7760fe09d5b9cd1f9 ]

The proc_symlink() function returns NULL on error, it doesn't return
error pointers.

Fixes: 5b86d4ff5dce ("afs: Implement network namespacing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/YLjMRKX40pTrJvgf@mwanda/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/main.c b/fs/afs/main.c
index b2975256dadb..179004b15566 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -203,8 +203,8 @@ static int __init afs_init(void)
 		goto error_fs;
 
 	afs_proc_symlink = proc_symlink("fs/afs", NULL, "../self/net/afs");
-	if (IS_ERR(afs_proc_symlink)) {
-		ret = PTR_ERR(afs_proc_symlink);
+	if (!afs_proc_symlink) {
+		ret = -ENOMEM;
 		goto error_proc;
 	}
 
-- 
2.30.2



