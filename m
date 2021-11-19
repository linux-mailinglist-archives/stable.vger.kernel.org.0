Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E008457600
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbhKSRno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237150AbhKSRnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 485D86120F;
        Fri, 19 Nov 2021 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343610;
        bh=JzZuXbcsQGKQ8Z1OZ8lt1YPnM5RuBbBIcY/avHpZH7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcktDnXRIiN06eKkZWvPFVKNBnezPoBPdeP8p24RgwYx9bHEDmin0PHFgnxxWImAC
         V09NpMqWif/pYNZsW46EyR/jQvycZdh/pJFap5PxT/bHm/e2WBDGqLfM3+rp5crUO+
         d17iVAcUQf5+7FcrfAqEvumHSWZ4NHyDxEE7DdUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 09/20] btrfs: check for relocation inodes on zoned btrfs in should_nocow
Date:   Fri, 19 Nov 2021 18:39:27 +0100
Message-Id: <20211119171444.959705952@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 2adada886b26e998b5a624e72f0834ebfdc54cc7 upstream

Prepare for allowing preallocation for relocation inodes.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1945,7 +1945,15 @@ int btrfs_run_delalloc_range(struct btrf
 	const bool zoned = btrfs_is_zoned(inode->root->fs_info);
 
 	if (should_nocow(inode, start, end)) {
-		ASSERT(!zoned);
+		/*
+		 * Normally on a zoned device we're only doing COW writes, but
+		 * in case of relocation on a zoned filesystem we have taken
+		 * precaution, that we're only writing sequentially. It's safe
+		 * to use run_delalloc_nocow() here, like for  regular
+		 * preallocated inodes.
+		 */
+		ASSERT(!zoned ||
+		       (zoned && btrfs_is_data_reloc_root(inode->root)));
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, nr_written);
 	} else if (!inode_can_compress(inode) ||


