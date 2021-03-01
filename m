Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055C6328CA4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhCASzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234837AbhCAStl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:49:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE4CD65248;
        Mon,  1 Mar 2021 17:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619659;
        bh=nSiaW/OjZpuOy3q63iX/DV1X59gPOFmiUbN5Dd7e5sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COGkaXlh795BLYZxTdT9oso0BGNs9pPqPRKhXO4bpFAh+1skng5vU6p3No+ODUNw1
         6fjQQPZY0LUPPYDsoARWPq66iAl9qP4EjnlIUOjEWOVxaHMfEDZ9IqSrgIOqfqWIKg
         5Io+9oA6Umt2iwqU0PkVLvTV1qA32lWx08dbJ1yE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 535/663] btrfs: fix reloc root leak with 0 ref reloc roots on recovery
Date:   Mon,  1 Mar 2021 17:13:03 +0100
Message-Id: <20210301161208.322718165@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit c78a10aebb275c38d0cfccae129a803fe622e305 upstream.

When recovering a relocation, if we run into a reloc root that has 0
refs we simply add it to the reloc_control->reloc_roots list, and then
clean it up later.  The problem with this is __del_reloc_root() doesn't
do anything if the root isn't in the radix tree, which in this case it
won't be because we never call __add_reloc_root() on the reloc_root.

This exit condition simply isn't correct really.  During normal
operation we can remove ourselves from the rb tree and then we're meant
to clean up later at merge_reloc_roots() time, and this happens
correctly.  During recovery we're depending on free_reloc_roots() to
drop our references, but we're short-circuiting.

Fix this by continuing to check if we're on the list and dropping
ourselves from the reloc_control root list and dropping our reference
appropriately.  Change the corresponding BUG_ON() to an ASSERT() that
does the correct thing if we aren't in the rb tree.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -669,9 +669,7 @@ static void __del_reloc_root(struct btrf
 			RB_CLEAR_NODE(&node->rb_node);
 		}
 		spin_unlock(&rc->reloc_root_tree.lock);
-		if (!node)
-			return;
-		BUG_ON((struct btrfs_root *)node->data != root);
+		ASSERT(!node || (struct btrfs_root *)node->data == root);
 	}
 
 	/*


