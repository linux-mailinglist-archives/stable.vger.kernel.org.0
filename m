Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEA029A007
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442553AbgJ0A0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410091AbgJZXx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18C212151B;
        Mon, 26 Oct 2020 23:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756407;
        bh=jdioljDCgQBbBlSFSWdq8Y6Bpb0NAauLqq+vhRl05Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKg0g5AYLj0C/9ZZlWX1JnwkOghAZ1swRriL1RIn12Zp+U3Ys2QA9XUFGuZ1XLpw6
         wTVJ/giPoM+Z244+MFsoiYJj6IGT11BkT2z0m83aAiKxe0UDJKjAJWIggiQsXNcKub
         JH3TrlsICOE0XOtx10DUDy9R4Ma6levhwg8GgOYU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lang Dai <lang.dai@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 066/132] uio: free uio id after uio file node is freed
Date:   Mon, 26 Oct 2020 19:50:58 -0400
Message-Id: <20201026235205.1023962-66-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Dai <lang.dai@intel.com>

[ Upstream commit 8fd0e2a6df262539eaa28b0a2364cca10d1dc662 ]

uio_register_device() do two things.
1) get an uio id from a global pool, e.g. the id is <A>
2) create file nodes like /sys/class/uio/uio<A>

uio_unregister_device() do two things.
1) free the uio id <A> and return it to the global pool
2) free the file node /sys/class/uio/uio<A>

There is a situation is that one worker is calling uio_unregister_device(),
and another worker is calling uio_register_device().
If the two workers are X and Y, they go as below sequence,
1) X free the uio id <AAA>
2) Y get an uio id <AAA>
3) Y create file node /sys/class/uio/uio<AAA>
4) X free the file note /sys/class/uio/uio<AAA>
Then it will failed at the 3rd step and cause the phenomenon we saw as it
is creating a duplicated file node.

Failure reports as follows:
sysfs: cannot create duplicate filename '/class/uio/uio10'
Call Trace:
   sysfs_do_create_link_sd.isra.2+0x9e/0xb0
   sysfs_create_link+0x25/0x40
   device_add+0x2c4/0x640
   __uio_register_device+0x1c5/0x576 [uio]
   adf_uio_init_bundle_dev+0x231/0x280 [intel_qat]
   adf_uio_register+0x1c0/0x340 [intel_qat]
   adf_dev_start+0x202/0x370 [intel_qat]
   adf_dev_start_async+0x40/0xa0 [intel_qat]
   process_one_work+0x14d/0x410
   worker_thread+0x4b/0x460
   kthread+0x105/0x140
 ? process_one_work+0x410/0x410
 ? kthread_bind+0x40/0x40
 ret_from_fork+0x1f/0x40
 Code: 85 c0 48 89 c3 74 12 b9 00 10 00 00 48 89 c2 31 f6 4c 89 ef
 e8 ec c4 ff ff 4c 89 e2 48 89 de 48 c7 c7 e8 b4 ee b4 e8 6a d4 d7
 ff <0f> 0b 48 89 df e8 20 fa f3 ff 5b 41 5c 41 5d 5d c3 66 0f 1f 84
---[ end trace a7531c1ed5269e84 ]---
 c6xxvf b002:00:00.0: Failed to register UIO devices
 c6xxvf b002:00:00.0: Failed to register UIO devices

Signed-off-by: Lang Dai <lang.dai@intel.com>

Link: https://lore.kernel.org/r/1600054002-17722-1-git-send-email-lang.dai@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 73efb80815db8..6dca744e39e95 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -1048,8 +1048,6 @@ void uio_unregister_device(struct uio_info *info)
 
 	idev = info->uio_dev;
 
-	uio_free_minor(idev);
-
 	mutex_lock(&idev->info_lock);
 	uio_dev_del_attributes(idev);
 
@@ -1064,6 +1062,8 @@ void uio_unregister_device(struct uio_info *info)
 
 	device_unregister(&idev->dev);
 
+	uio_free_minor(idev);
+
 	return;
 }
 EXPORT_SYMBOL_GPL(uio_unregister_device);
-- 
2.25.1

