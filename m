Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FB5344112
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhCVMab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230478AbhCVMaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C0526198E;
        Mon, 22 Mar 2021 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416210;
        bh=GWjbw7gr5vh7AP3ZN/gxWbA0PVuORrE/QD9lVF6Yuto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/IB8s6Q+iaQ1vyaA9PCMRNPfnuuz6efdyAvwa/Jieen0TgQvKT2FRk1T/Yr8NvMt
         EEu1OqpSgyGl2CN/1ighhnVdrFhOwAo7I5OM4ZSf6gNcWIpNMdGYNA9/r7HFzffxUZ
         wq6MguMiEnIu5eFT+aLp0HfNYkAf1VadiJ6bJR0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 020/120] btrfs: fix slab cache flags for free space tree bitmap
Date:   Mon, 22 Mar 2021 13:26:43 +0100
Message-Id: <20210322121930.341582581@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit 34e49994d0dcdb2d31d4d2908d04f4e9ce57e4d7 upstream.

The free space tree bitmap slab cache is created with SLAB_RED_ZONE but
that's a debugging flag and not always enabled. Also the other slabs are
created with at least SLAB_MEM_SPREAD that we want as well to average
the memory placement cost.

Reported-by: Vlastimil Babka <vbabka@suse.cz>
Fixes: 3acd48507dc4 ("btrfs: fix allocation of free space cache v1 bitmap pages")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8806,7 +8806,7 @@ int __init btrfs_init_cachep(void)
 
 	btrfs_free_space_bitmap_cachep = kmem_cache_create("btrfs_free_space_bitmap",
 							PAGE_SIZE, PAGE_SIZE,
-							SLAB_RED_ZONE, NULL);
+							SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_free_space_bitmap_cachep)
 		goto fail;
 


