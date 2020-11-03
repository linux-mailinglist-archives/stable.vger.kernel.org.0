Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692E62A587D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbgKCUrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:47:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730015AbgKCUrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C88422409;
        Tue,  3 Nov 2020 20:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436435;
        bh=iqUVc2vMxgr3pgFmwM1P55J8MtW5EoW3z+p9zzf4/XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LT/coIrh7MLnGYqJV0xvKAsQJWliMr3XYY5BMTK4ApWvFt4K+kCF7F641Qsyro8O1
         yLRJUL2uw2ip3GbnnKrO9ZDlWKqLr+NIyFdzPpT3kvxREdLV0laeQITqoBWWBByf16
         RLr1uXRQGN/RNXPSG+QCCke4SoiE4rj/jpi86nSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 222/391] btrfs: improve device scanning messages
Date:   Tue,  3 Nov 2020 21:34:33 +0100
Message-Id: <20201103203401.926199135@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 79dae17d8d44b2d15779e332180080af45df5352 upstream.

Systems booting without the initramfs seems to scan an unusual kind
of device path (/dev/root). And at a later time, the device is updated
to the correct path. We generally print the process name and PID of the
process scanning the device but we don't capture the same information if
the device path is rescanned with a different pathname.

The current message is too long, so drop the unnecessary UUID and add
process name and PID.

While at this also update the duplicate device warning to include the
process name and PID so the messages are consistent

CC: stable@vger.kernel.org # 4.19+
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=89721
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -942,16 +942,18 @@ static noinline struct btrfs_device *dev
 				bdput(path_bdev);
 				mutex_unlock(&fs_devices->device_list_mutex);
 				btrfs_warn_in_rcu(device->fs_info,
-			"duplicate device fsid:devid for %pU:%llu old:%s new:%s",
-					disk_super->fsid, devid,
-					rcu_str_deref(device->name), path);
+	"duplicate device %s devid %llu generation %llu scanned by %s (%d)",
+						  path, devid, found_transid,
+						  current->comm,
+						  task_pid_nr(current));
 				return ERR_PTR(-EEXIST);
 			}
 			bdput(path_bdev);
 			btrfs_info_in_rcu(device->fs_info,
-				"device fsid %pU devid %llu moved old:%s new:%s",
-				disk_super->fsid, devid,
-				rcu_str_deref(device->name), path);
+	"devid %llu device path %s changed to %s scanned by %s (%d)",
+					  devid, rcu_str_deref(device->name),
+					  path, current->comm,
+					  task_pid_nr(current));
 		}
 
 		name = rcu_string_strdup(path, GFP_NOFS);


