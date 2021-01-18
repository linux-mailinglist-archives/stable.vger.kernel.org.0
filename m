Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2788C2F9E87
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390415AbhARLmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390725AbhARLlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BBAA229CA;
        Mon, 18 Jan 2021 11:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970067;
        bh=q5EQyfRzMh5WThnQtpfYpW1dPBfAe1U5nSydJKDRdNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kvo22KgYPdLRd2jdqxQyqFsug6mzxnGGeWKEyUF7FW7p8WiXSXCOaq+AQ18DqmXG6
         iO30G53mzSHkdBB/sw7eGMt0pXg1rIEJFEK+uVDj4TrK4RtnD/vAda3xJAj1pqOaIz
         EopFhGnYZNgo6KaRL/epwDNaQwieE0E/iNKQAUWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 023/152] cifs: check pointer before freeing
Date:   Mon, 18 Jan 2021 12:33:18 +0100
Message-Id: <20210118113353.889449311@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 77b6ec01c29aade01701aa30bf1469acc7f2be76 upstream.

clang static analysis reports this problem

dfs_cache.c:591:2: warning: Argument to kfree() is a constant address
  (18446744073709551614), which is not memory allocated by malloc()
        kfree(vi);
        ^~~~~~~~~

In dfs_cache_del_vol() the volume info pointer 'vi' being freed
is the return of a call to find_vol().  The large constant address
is find_vol() returning an error.

Add an error check to dfs_cache_del_vol() similar to the one done
in dfs_cache_update_vol().

Fixes: 54be1f6c1c37 ("cifs: Add DFS cache routines")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
CC: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/dfs_cache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1317,7 +1317,8 @@ void dfs_cache_del_vol(const char *fullp
 	vi = find_vol(fullpath);
 	spin_unlock(&vol_list_lock);
 
-	kref_put(&vi->refcnt, vol_release);
+	if (!IS_ERR(vi))
+		kref_put(&vi->refcnt, vol_release);
 }
 
 /**


