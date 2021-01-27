Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E5430510A
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 05:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239288AbhA0Ejk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 23:39:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:39066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404732AbhA0BoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 20:44:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BE3E6AD0B;
        Wed, 27 Jan 2021 01:21:25 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 366415BD6DE; Tue, 26 Jan 2021 17:21:24 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH] fnic: fixup patch to resolve stack frame issues
Date:   Tue, 26 Jan 2021 17:21:24 -0800
Message-Id: <20210127012124.22241-1-leeman.duncan@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Commit 42ec15ceaea7 fixed a gcc issue with unused variables, but
introduced errors since it allocated an array of two u64-s but
then used more than that. Set the arrays to the proper size.

Fixes: 42ec15ceaea74b5f7a621fc6686cbf69ca66c4cf
Cc: stable@vger.kernel.org
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/fnic/vnic_dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 5988c300cc82..d29999064b89 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -697,7 +697,7 @@ int vnic_dev_hang_notify(struct vnic_dev *vdev)
 
 int vnic_dev_mac_addr(struct vnic_dev *vdev, u8 *mac_addr)
 {
-	u64 a[2] = {};
+	u64 a[ETH_ALEN] = {};
 	int wait = 1000;
 	int err, i;
 
@@ -734,7 +734,7 @@ void vnic_dev_packet_filter(struct vnic_dev *vdev, int directed, int multicast,
 
 void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a[2] = {};
+	u64 a[ETH_ALEN] = {};
 	int wait = 1000;
 	int err;
 	int i;
@@ -749,7 +749,7 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a[2] = {};
+	u64 a[ETH_ALEN] = {};
 	int wait = 1000;
 	int err;
 	int i;
-- 
2.26.2

