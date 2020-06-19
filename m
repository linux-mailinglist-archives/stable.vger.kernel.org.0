Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC60B201039
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391085AbgFSP1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393579AbgFSP1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:27:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88BDB218AC;
        Fri, 19 Jun 2020 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580458;
        bh=k+RT4ra8HZVN8ceO6WwOrSW3uphgh9ngo3vHcxY/p1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doSyZmnG1cCfQKoe1U3Y9mN2O/IinyMkVAbrH4bnoV3UPmIts2gtq10aI4XL0hAZD
         mzgpnZWT5riFBOjT2ly62wxaMzYDJNOfUviOIYJGB4JRfz4PNHiZT7LrDCpjl+Y6b5
         DgsU1Sd1fa22P7a7vUu5TZAVNYvOJ56yVHRSw8Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 257/376] btrfs: include non-missing as a qualifier for the latest_bdev
Date:   Fri, 19 Jun 2020 16:32:55 +0200
Message-Id: <20200619141722.492382514@linuxfoundation.org>
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

commit 998a0671961f66e9fad4990ed75f80ba3088c2f1 upstream.

btrfs_free_extra_devids() updates fs_devices::latest_bdev to point to
the bdev with greatest device::generation number.  For a typical-missing
device the generation number is zero so fs_devices::latest_bdev will
never point to it.

But if the missing device is due to alienation [1], then
device::generation is not zero and if it is greater or equal to the rest
of device  generations in the list, then fs_devices::latest_bdev ends up
pointing to the missing device and reports the error like [2].

[1] We maintain devices of a fsid (as in fs_device::fsid) in the
fs_devices::devices list, a device is considered as an alien device
if its fsid does not match with the fs_device::fsid

Consider a working filesystem with raid1:

  $ mkfs.btrfs -f -d raid1 -m raid1 /dev/sda /dev/sdb
  $ mount /dev/sda /mnt-raid1
  $ umount /mnt-raid1

While mnt-raid1 was unmounted the user force-adds one of its devices to
another btrfs filesystem:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt-single
  $ btrfs dev add -f /dev/sda /mnt-single

Now the original mnt-raid1 fails to mount in degraded mode, because
fs_devices::latest_bdev is pointing to the alien device.

  $ mount -o degraded /dev/sdb /mnt-raid1

[2]
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

  kernel: BTRFS warning (device sdb): devid 1 uuid 072a0192-675b-4d5a-8640-a5cf2b2c704d is missing
  kernel: BTRFS error (device sdb): failed to read devices
  kernel: BTRFS error (device sdb): open_ctree failed

Fix the root cause by checking if the device is not missing before it
can be considered for the fs_devices::latest_bdev.

CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1042,6 +1042,8 @@ again:
 							&device->dev_state)) {
 			if (!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
 			     &device->dev_state) &&
+			    !test_bit(BTRFS_DEV_STATE_MISSING,
+				      &device->dev_state) &&
 			     (!latest_dev ||
 			      device->generation > latest_dev->generation)) {
 				latest_dev = device;


