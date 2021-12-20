Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A79847AF2A
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbhLTPKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238267AbhLTPIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:08:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556A4C08EAFB;
        Mon, 20 Dec 2021 06:54:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11652B80EDA;
        Mon, 20 Dec 2021 14:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DCBC36AE7;
        Mon, 20 Dec 2021 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012044;
        bh=Vs5Y+ew32lh5XNVuTAxWLV5SCd3hCFHFCm2tsUJl5lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycsjQm8IxNSyF8oE/dIWyLrcVlfH2V2wlRp2b0EUOzW6GZD6angPwPWvGt7qbDi5e
         N2ZElAFUcItp6fIiCrgJDHjZjFej6YgCbSuCyXNS5Q0t4RhVa4tY03WNT0nL4HvNZ9
         1cbpkeMacrVL88yM5yixyCqTqyAFNsa4MIC8vOKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 033/177] btrfs: remove stale comment about the btrfs_show_devname
Date:   Mon, 20 Dec 2021 15:33:03 +0100
Message-Id: <20211220143041.211479664@linuxfoundation.org>
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

Commit cdccc03a8a369b59cff5e7ea3292511cfa551120 upstream.

There were few lockdep warnings because btrfs_show_devname() was using
device_list_mutex as recorded in the commits:

  0ccd05285e7f ("btrfs: fix a possible umount deadlock")
  779bf3fefa83 ("btrfs: fix lock dep warning, move scratch dev out of device_list_mutex and uuid_mutex")

And finally, commit 88c14590cdd6 ("btrfs: use RCU in btrfs_show_devname
for device list traversal") removed the device_list_mutex from
btrfs_show_devname for performance reasons.

This patch removes a stale comment about the function
btrfs_show_devname and device_list_mutex.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2312,13 +2312,6 @@ void btrfs_destroy_dev_replace_tgtdev(st
 
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-	/*
-	 * The update_dev_time() with in btrfs_scratch_superblocks()
-	 * may lead to a call to btrfs_show_devname() which will try
-	 * to hold device_list_mutex. And here this device
-	 * is already out of device list, so we don't have to hold
-	 * the device_list_mutex lock.
-	 */
 	btrfs_scratch_superblocks(tgtdev->fs_info, tgtdev->bdev,
 				  tgtdev->name->str);
 


