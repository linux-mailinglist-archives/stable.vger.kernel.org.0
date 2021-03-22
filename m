Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9883441F0
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhCVMhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230482AbhCVMfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F38A0619A5;
        Mon, 22 Mar 2021 12:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416529;
        bh=SsPxUMl91mMndEVeOOH1YAIyfprEI7gPDLok/0xY0CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arYjPN8gmUbhI83HHC/BO+dhEbysu2txh1mWfQzWHg2VI3JSp3lPAEdVnRWd5VopV
         WPZvo8elPgSakip3zbtTV/w5FrimcsxedUOuPxLeVRxePxjLOn3Y7TPHrRkCT10mZv
         hTiZhk9Jk/beBDCK4Myc8D4qR1wSRyTOjkDquxZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 020/157] btrfs: fix slab cache flags for free space tree bitmap
Date:   Mon, 22 Mar 2021 13:26:17 +0100
Message-Id: <20210322121934.413017595@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
@@ -8811,7 +8811,7 @@ int __init btrfs_init_cachep(void)
 
 	btrfs_free_space_bitmap_cachep = kmem_cache_create("btrfs_free_space_bitmap",
 							PAGE_SIZE, PAGE_SIZE,
-							SLAB_RED_ZONE, NULL);
+							SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_free_space_bitmap_cachep)
 		goto fail;
 


