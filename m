Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1A82A55AE
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731917AbgKCVVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:21:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388110AbgKCVGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6D6F20757;
        Tue,  3 Nov 2020 21:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437566;
        bh=qYF6BAh2DEufx/w93fuY7ZrcXjDyzsulL6SOF3/BtoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAKHYwMsvVVR96zoLOjNpoqF8AmbI9ZgjbByTqWpbdhfgKNu7GNB+SyqmGHjXMiSA
         06wU352L7oz9fJ3WWabQLbo+pFiv9liIKxj6x3xnaSdJdCicvYEP2D8c27I0qbSka3
         YZAD9m2WP6uy9AuRK6LwL2csuFxMAy//IJLRXQ8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/191] btrfs: fix replace of seed device
Date:   Tue,  3 Nov 2020 21:36:25 +0100
Message-Id: <20201103203242.606198520@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit c6a5d954950c5031444173ad2195efc163afcac9 ]

If you replace a seed device in a sprouted fs, it appears to have
successfully replaced the seed device, but if you look closely, it
didn't.  Here is an example.

  $ mkfs.btrfs /dev/sda
  $ btrfstune -S1 /dev/sda
  $ mount /dev/sda /btrfs
  $ btrfs device add /dev/sdb /btrfs
  $ umount /btrfs
  $ btrfs device scan --forget
  $ mount -o device=/dev/sda /dev/sdb /btrfs
  $ btrfs replace start -f /dev/sda /dev/sdc /btrfs
  $ echo $?
  0

  BTRFS info (device sdb): dev_replace from /dev/sda (devid 1) to /dev/sdc started
  BTRFS info (device sdb): dev_replace from /dev/sda (devid 1) to /dev/sdc finished

  $ btrfs fi show
  Label: none  uuid: ab2c88b7-be81-4a7e-9849-c3666e7f9f4f
	  Total devices 2 FS bytes used 256.00KiB
	  devid    1 size 3.00GiB used 520.00MiB path /dev/sdc
	  devid    2 size 3.00GiB used 896.00MiB path /dev/sdb

  Label: none  uuid: 10bd3202-0415-43af-96a8-d5409f310a7e
	  Total devices 1 FS bytes used 128.00KiB
	  devid    1 size 3.00GiB used 536.00MiB path /dev/sda

So as per the replace start command and kernel log replace was successful.
Now let's try to clean mount.

  $ umount /btrfs
  $ btrfs device scan --forget

  $ mount -o device=/dev/sdc /dev/sdb /btrfs
  mount: /btrfs: wrong fs type, bad option, bad superblock on /dev/sdb, missing codepage or helper program, or other error.

  [  636.157517] BTRFS error (device sdc): failed to read chunk tree: -2
  [  636.180177] BTRFS error (device sdc): open_ctree failed

That's because per dev items it is still looking for the original seed
device.

 $ btrfs inspect-internal dump-tree -d /dev/sdb

	item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
		devid 1 total_bytes 3221225472 bytes_used 545259520
		io_align 4096 io_width 4096 sector_size 4096 type 0
		generation 6 start_offset 0 dev_group 0
		seek_speed 0 bandwidth 0
		uuid 59368f50-9af2-4b17-91da-8a783cc418d4  <--- seed uuid
		fsid 10bd3202-0415-43af-96a8-d5409f310a7e  <--- seed fsid
	item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
		devid 2 total_bytes 3221225472 bytes_used 939524096
		io_align 4096 io_width 4096 sector_size 4096 type 0
		generation 0 start_offset 0 dev_group 0
		seek_speed 0 bandwidth 0
		uuid 56a0a6bc-4630-4998-8daf-3c3030c4256a  <- sprout uuid
		fsid ab2c88b7-be81-4a7e-9849-c3666e7f9f4f <- sprout fsid

But the replaced target has the following uuid+fsid in its superblock
which doesn't match with the expected uuid+fsid in its devitem.

  $ btrfs in dump-super /dev/sdc | egrep '^generation|dev_item.uuid|dev_item.fsid|devid'
  generation	20
  dev_item.uuid	59368f50-9af2-4b17-91da-8a783cc418d4
  dev_item.fsid	ab2c88b7-be81-4a7e-9849-c3666e7f9f4f [match]
  dev_item.devid	1

So if you provide the original seed device the mount shall be
successful.  Which so long happening in the test case btrfs/163.

  $ btrfs device scan --forget
  $ mount -o device=/dev/sda /dev/sdb /btrfs

Fix in this patch:
If a seed is not sprouted then there is no replacement of it, because of
its read-only filesystem with a read-only device. Similarly, in the case
of a sprouted filesystem, the seed device is still read only. So, mark
it as you can't replace a seed device, you can only add a new device and
then delete the seed device. If replace is attempted then returns
-EINVAL.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/dev-replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 1b9c8ffb038ff..36c0490156ac5 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -190,7 +190,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	int ret = 0;
 
 	*device_out = NULL;
-	if (fs_info->fs_devices->seeding) {
+	if (srcdev->fs_devices->seeding) {
 		btrfs_err(fs_info, "the filesystem is a seed filesystem!");
 		return -EINVAL;
 	}
-- 
2.27.0



