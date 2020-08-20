Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223BF24B54D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbgHTKWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731579AbgHTKV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:21:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC4CE2072D;
        Thu, 20 Aug 2020 10:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918919;
        bh=bVvddrK+qoU01hUbXwqrKFPxQVIC31GFgroVKcw9PwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baEoAGEVobTiznF2cHvluSu0q71UbeuPQRZ+6u5dmBnuAt7oBJKw+AbSWpG/C17Qy
         umpVK4BuSaiD8dLq6KGVJCiBNFdAESGXyvGxBwtl64m/UHKUWO022FSAi+dG6GN/Ih
         jSw9aXMew7SuWDw86gk1VrKNBYxDoW9FFuUsDBZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 4.4 115/149] 9p: Fix memory leak in v9fs_mount
Date:   Thu, 20 Aug 2020 11:23:12 +0200
Message-Id: <20200820092131.267368313@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

commit cb0aae0e31c632c407a2cab4307be85a001d4d98 upstream.

v9fs_mount
  v9fs_session_init
    v9fs_cache_session_get_cookie
      v9fs_random_cachetag                     -->alloc cachetag
      v9ses->fscache = fscache_acquire_cookie  -->maybe NULL
  sb = sget                                    -->fail, goto clunk
clunk_fid:
  v9fs_session_close
    if (v9ses->fscache)                        -->NULL
      kfree(v9ses->cachetag)

Thus memleak happens.

Link: http://lkml.kernel.org/r/20200615012153.89538-1-zhengbin13@huawei.com
Fixes: 60e78d2c993e ("9p: Add fscache support to 9p")
Cc: <stable@vger.kernel.org> # v2.6.32+
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/9p/v9fs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -457,10 +457,9 @@ void v9fs_session_close(struct v9fs_sess
 	}
 
 #ifdef CONFIG_9P_FSCACHE
-	if (v9ses->fscache) {
+	if (v9ses->fscache)
 		v9fs_cache_session_put_cookie(v9ses);
-		kfree(v9ses->cachetag);
-	}
+	kfree(v9ses->cachetag);
 #endif
 	kfree(v9ses->uname);
 	kfree(v9ses->aname);


