Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3DC3830E9
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbhEQOcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238621AbhEQOaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:30:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 963B961876;
        Mon, 17 May 2021 14:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260920;
        bh=/2QN11yCxaU90AlgXlB0oH0bQV4rg6Z61sPQRj3+nkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pd/EcBjtj16xGFQ6Wcp/TeSbfjCbVdbBi64qwJ++vkvzHyCRjLIX2YSS6p5ceVPvl
         izUWw2a0tGHNzaC7wOHGDS7e43XVOxA0CWBl3akLR4EzLKtrVKmK79G8zVMejAxi93
         gEJboC7HqqOPF/TB2n+vovjM8cIsX8e0k+AHuMb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 267/363] btrfs: initialize return variable in cleanup_free_space_cache_v1
Date:   Mon, 17 May 2021 16:02:13 +0200
Message-Id: <20210517140311.640237192@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 77364faf21b4105ee5adbb4844fdfb461334d249 upstream.

Static analysis reports this problem

  free-space-cache.c:3965:2: warning: Undefined or garbage value returned
    return ret;
    ^~~~~~~~~~

ret is set in the node handling loop.  Treat doing nothing as a success
and initialize ret to 0, although it's unlikely the loop would be
skipped. We always have block groups, but as it could lead to
transaction abort in the caller it's better to be safe.

CC: stable@vger.kernel.org # 5.12+
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3942,7 +3942,7 @@ static int cleanup_free_space_cache_v1(s
 {
 	struct btrfs_block_group *block_group;
 	struct rb_node *node;
-	int ret;
+	int ret = 0;
 
 	btrfs_info(fs_info, "cleaning free space cache v1");
 


