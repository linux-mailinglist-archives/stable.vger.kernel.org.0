Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9CD1AC9C8
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502562AbgDPPZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731456AbgDPNoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:44:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA0C20732;
        Thu, 16 Apr 2020 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044683;
        bh=EkOBFVCYfHMSHV79LZ+glFm4WQ53lVX1OwA+34TvyF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITe8tmpXsRSLonWi8KLGRDTH1I8bvuZ0OWgj2g74lSMCT650f99fkBb/68+hMG0en
         JzwJTZBWdtB0dYaS6+rdc6s5sA3OcOwZABHNHToHEWIKJ9SYR/JLE9l2HNhFVNo92z
         k+NXaF7KqpdYJQYkwNNFaH2L4Ixr8HGVj5EWVwsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/232] md: check arrays is suspended in mddev_detach before call quiesce operations
Date:   Thu, 16 Apr 2020 15:22:34 +0200
Message-Id: <20200416131322.988212325@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit 6b40bec3b13278d21fa6c1ae7a0bdf2e550eed5f ]

Don't call quiesce(1) and quiesce(0) if array is already suspended,
otherwise in level_store, the array is writable after mddev_detach
in below part though the intention is to make array writable after
resume.

	mddev_suspend(mddev);
	mddev_detach(mddev);
	...
	mddev_resume(mddev);

And it also causes calltrace as follows in [1].

[48005.653834] WARNING: CPU: 1 PID: 45380 at kernel/kthread.c:510 kthread_park+0x77/0x90
[...]
[48005.653976] CPU: 1 PID: 45380 Comm: mdadm Tainted: G           OE     5.4.10-arch1-1 #1
[48005.653979] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./J4105-ITX, BIOS P1.40 08/06/2018
[48005.653984] RIP: 0010:kthread_park+0x77/0x90
[48005.654015] Call Trace:
[48005.654039]  r5l_quiesce+0x3c/0x70 [raid456]
[48005.654052]  raid5_quiesce+0x228/0x2e0 [raid456]
[48005.654073]  mddev_detach+0x30/0x70 [md_mod]
[48005.654090]  level_store+0x202/0x670 [md_mod]
[48005.654099]  ? security_capable+0x40/0x60
[48005.654114]  md_attr_store+0x7b/0xc0 [md_mod]
[48005.654123]  kernfs_fop_write+0xce/0x1b0
[48005.654132]  vfs_write+0xb6/0x1a0
[48005.654138]  ksys_write+0x67/0xe0
[48005.654146]  do_syscall_64+0x4e/0x140
[48005.654155]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[48005.654161] RIP: 0033:0x7fa0c8737497

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=206161

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e7c9f398bc66..6b69a12ca2d80 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6040,7 +6040,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 static void mddev_detach(struct mddev *mddev)
 {
 	md_bitmap_wait_behind_writes(mddev);
-	if (mddev->pers && mddev->pers->quiesce) {
+	if (mddev->pers && mddev->pers->quiesce && !mddev->suspended) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
 	}
-- 
2.20.1



