Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77312474D5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392075AbgHQTQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387433AbgHQPji (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:39:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0417122C9F;
        Mon, 17 Aug 2020 15:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678777;
        bh=8cLVw7nzYeeb/D1UEPPeffAQwZifocd6+H+cQwWUp8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1fKrUYoEFdj8Jp2zOc2FvA+AUpRd4SlmJ77HX1X1p4lJjFPpcziBVluXdjWVlYNh
         ib+d3AO9r5T8lSWr92T2JitguQbGCmp+DirGbX0CrnnBGFd28OqjhSgAANTxnJAAO7
         nfanmv/ECRWL+Y3zQ7Eo+JCZn5NIDzO0eG/vk4EI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.8 420/464] 9p: Fix memory leak in v9fs_mount
Date:   Mon, 17 Aug 2020 17:16:13 +0200
Message-Id: <20200817143853.891906569@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
@@ -500,10 +500,9 @@ void v9fs_session_close(struct v9fs_sess
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


