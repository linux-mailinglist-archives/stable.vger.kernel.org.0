Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE8920D30F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgF2SzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729915AbgF2SzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:55:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE0EB25576;
        Mon, 29 Jun 2020 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446141;
        bh=0bQKSbV06uF3Fy86wdZrTACqP+ZgxQPNSlkVIp9y6To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdScB9VmfKJRGP+k1OBK8m2REXCCVxNVEWbAaoVErQXxoJXewRVZeBfvlu5fF0lue
         CgVbd/Gc4BaDIXlSiXRlfUpqcrfzaBNVecp5L3yO+CEyTgD8tp5U83Eamq0ONuO4+H
         lx72MjtHziRvzvVo7c1BLvuideeI3n9s5wzd9j+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Jeff Layton <jlayton@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 129/135] sunrpc: fixed rollback in rpc_gssd_dummy_populate()
Date:   Mon, 29 Jun 2020 11:53:03 -0400
Message-Id: <20200629155309.2495516-130-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit b7ade38165ca0001c5a3bd5314a314abbbfbb1b7 upstream.

__rpc_depopulate(gssd_dentry) was lost on error path

cc: stable@vger.kernel.org
Fixes: commit 4b9a445e3eeb ("sunrpc: create a new dummy pipe for gssd to hold open")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/rpc_pipe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 9103dd15511cc..12dd5cc499c1e 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -1347,6 +1347,7 @@ rpc_gssd_dummy_populate(struct dentry *root, struct rpc_pipe *pipe_data)
 	q.len = strlen(gssd_dummy_clnt_dir[0].name);
 	clnt_dentry = d_hash_and_lookup(gssd_dentry, &q);
 	if (!clnt_dentry) {
+		__rpc_depopulate(gssd_dentry, gssd_dummy_clnt_dir, 0, 1);
 		pipe_dentry = ERR_PTR(-ENOENT);
 		goto out;
 	}
-- 
2.25.1

