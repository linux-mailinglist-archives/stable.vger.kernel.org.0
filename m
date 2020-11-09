Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEFD2ABB7F
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbgKINJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:09:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731794AbgKINJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE8CC2083B;
        Mon,  9 Nov 2020 13:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927344;
        bh=WDKk+UPeIRY8w8AwhkrS1+qUoIF2lOtRMFUGgca2mwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfbgJu/Kj3scDYyQSDQgjuFyO8svgw1PJYilNiDJeXklSdalg6EhmxiAuILG60LoI
         bBymw9o3o6c0UcAyQTDbm5LF9HbjEsytXf1aWvL9CG1xw2gySQAyBSqQtzOLPgyATJ
         laXufnCVeAlhwCddeYiGx8+e5cFLyWHyV6XPrPXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 27/71] btrfs: tree-checker: Fix wrong check on max devid
Date:   Mon,  9 Nov 2020 13:55:21 +0100
Message-Id: <20201109125021.183039143@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 8bb177d18f114358a57d8ae7e206861b48b8b4de upstream.

[BUG]
The following script will cause false alert on devid check.
  #!/bin/bash

  dev1=/dev/test/test
  dev2=/dev/test/scratch1
  mnt=/mnt/btrfs

  umount $dev1 &> /dev/null
  umount $dev2 &> /dev/null
  umount $mnt &> /dev/null

  mkfs.btrfs -f $dev1

  mount $dev1 $mnt

  _fail()
  {
          echo "!!! FAILED !!!"
          exit 1
  }

  for ((i = 0; i < 4096; i++)); do
          btrfs dev add -f $dev2 $mnt || _fail
          btrfs dev del $dev1 $mnt || _fail
          dev_tmp=$dev1
          dev1=$dev2
          dev2=$dev_tmp
  done

[CAUSE]
Tree-checker uses BTRFS_MAX_DEVS() and BTRFS_MAX_DEVS_SYS_CHUNK() as
upper limit for devid.  But we can have devid holes just like above
script.

So the check for devid is incorrect and could cause false alert.

[FIX]
Just remove the whole devid check.  We don't have any hard requirement
for devid assignment.

Furthermore, even devid could get corrupted by a bitflip, we still have
dev extents verification at mount time, so corrupted data won't sneak
in.

This fixes fstests btrfs/194.

Reported-by: Anand Jain <anand.jain@oracle.com>
Fixes: ab4ba2e13346 ("btrfs: tree-checker: Verify dev item")
CC: stable@vger.kernel.org # 5.2+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.19: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -629,7 +629,6 @@ static int check_dev_item(struct btrfs_f
 			  struct btrfs_key *key, int slot)
 {
 	struct btrfs_dev_item *ditem;
-	u64 max_devid = max(BTRFS_MAX_DEVS(fs_info), BTRFS_MAX_DEVS_SYS_CHUNK);
 
 	if (key->objectid != BTRFS_DEV_ITEMS_OBJECTID) {
 		dev_item_err(fs_info, leaf, slot,
@@ -637,12 +636,6 @@ static int check_dev_item(struct btrfs_f
 			     key->objectid, BTRFS_DEV_ITEMS_OBJECTID);
 		return -EUCLEAN;
 	}
-	if (key->offset > max_devid) {
-		dev_item_err(fs_info, leaf, slot,
-			     "invalid devid: has=%llu expect=[0, %llu]",
-			     key->offset, max_devid);
-		return -EUCLEAN;
-	}
 	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
 	if (btrfs_device_id(leaf, ditem) != key->offset) {
 		dev_item_err(fs_info, leaf, slot,


