Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE0B2011C8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391802AbgFSPpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393567AbgFSP1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:27:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB6F121941;
        Fri, 19 Jun 2020 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580455;
        bh=TW6j57xA4M2KvkhtMtP8V3nsqFz0J5n9lmoDknQHfxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biqfrAHhrEO9lJmMcDyW309+IF8W8Hg91F62BJ0afWAzH+8hNijlfmycJLQnkrioj
         Y11TzrRwf7j/EQUqTM6RIoCHtaTSUmxtTX5YshqrBp1wJgkxYWjM+XPPYSsoMvl4M9
         PVO7m7ESbQM8ny6ys07grXCP73JbNjolKjWZVVLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 256/376] btrfs: free alien device after device add
Date:   Fri, 19 Jun 2020 16:32:54 +0200
Message-Id: <20200619141722.444467186@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 7f551d969037cc128eca60688d9c5a300d84e665 upstream.

When an old device has new fsid through 'btrfs device add -f <dev>' our
fs_devices list has an alien device in one of the fs_devices lists.

By having an alien device in fs_devices, we have two issues so far

1. missing device does not not show as missing in the userland

2. degraded mount will fail

Both issues are caused by the fact that there's an alien device in the
fs_devices list. (Alien means that it does not belong to the filesystem,
identified by fsid, or does not contain btrfs filesystem at all, eg. due
to overwrite).

A device can be scanned/added through the control device ioctls
SCAN_DEV, DEVICES_READY or by ADD_DEV.

And device coming through the control device is checked against the all
other devices in the lists, but this was not the case for ADD_DEV.

This patch fixes both issues above by removing the alien device.

CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2663,8 +2663,18 @@ int btrfs_init_new_device(struct btrfs_f
 		ret = btrfs_commit_transaction(trans);
 	}
 
-	/* Update ctime/mtime for libblkid */
+	/*
+	 * Now that we have written a new super block to this device, check all
+	 * other fs_devices list if device_path alienates any other scanned
+	 * device.
+	 * We can ignore the return value as it typically returns -EINVAL and
+	 * only succeeds if the device was an alien.
+	 */
+	btrfs_forget_devices(device_path);
+
+	/* Update ctime/mtime for blkid or udev */
 	update_dev_time(device_path);
+
 	return ret;
 
 error_sysfs:


