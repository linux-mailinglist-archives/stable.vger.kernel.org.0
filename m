Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EEF47AF17
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbhLTPJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237233AbhLTPHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:07:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1A5C09CE54;
        Mon, 20 Dec 2021 06:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C279611CE;
        Mon, 20 Dec 2021 14:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E78AC36AEE;
        Mon, 20 Dec 2021 14:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012014;
        bh=X6VePYfZH28BaunTf9YQy6pAVcUR/JHXf2PRBZPvHZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neUOsDUlzL5IGm3GQNHcNclFeDNaaUfdhg+mx3Zo6i+sw5boV73u27hPbTBuVIugD
         ff36Q/4crKBAzAK3EEFgQLL3b2OCjcTBzcPjBwgF3U/SlZ4a6nkCHYwMxsBNabplVi
         TFk2DDUnHbZ9xZ7Vi/4ukdB2+8sNyiLrlEt36V+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Su Yue <l@damenly.su>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 032/177] btrfs: update latest_dev when we create a sprout device
Date:   Mon, 20 Dec 2021 15:33:02 +0100
Message-Id: <20211220143041.178245113@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

Commit b7cb29e666fe79dda5dbe5f57fb7c92413bf161c upstream.

When we add a device to the seed filesystem (sprouting) it is a new
filesystem (and fsid) on the device added. Update the latest_dev so
that /proc/self/mounts shows the correct device.

Example:

  $ btrfstune -S1 /dev/vg/seed
  $ mount /dev/vg/seed /btrfs
  mount: /btrfs: WARNING: device write-protected, mounted read-only.

  $ cat /proc/self/mounts | grep btrfs
  /dev/mapper/vg-seed /btrfs btrfs ro,relatime,space_cache,subvolid=5,subvol=/ 0 0

  $ btrfs dev add -f /dev/vg/new /btrfs

Before:

  $ cat /proc/self/mounts | grep btrfs
  /dev/mapper/vg-seed /btrfs btrfs ro,relatime,space_cache,subvolid=5,subvol=/ 0 0

After:

  $ cat /proc/self/mounts | grep btrfs
  /dev/mapper/vg-new /btrfs btrfs ro,relatime,space_cache,subvolid=5,subvol=/ 0 0

Tested-by: Su Yue <l@damenly.su>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2634,6 +2634,8 @@ int btrfs_init_new_device(struct btrfs_f
 			btrfs_abort_transaction(trans, ret);
 			goto error_trans;
 		}
+		btrfs_assign_next_active_device(fs_info->fs_devices->latest_dev,
+						device);
 	}
 
 	device->fs_devices = fs_devices;


