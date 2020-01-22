Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5941451B0
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgAVJc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730117AbgAVJc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:32:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52CC52467A;
        Wed, 22 Jan 2020 09:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685547;
        bh=Ei0WUn/7hawY4OURlT4CiEtiWn271M8zq9cHlqLxs1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6Jw0FOf767NAUbnnn0SkYJYTRRLwOeU9yeCtpjTv/7h7711MjtFuoRu1LSSUGrXZ
         bWpjlOcAqCjIddug08um1UjusyBxLKiL+Z0IFvh/qO08wUrA/BHzvR2cSsFc8j8TPN
         /zuRU3dzlLZOgKkEvHgY7g2t6A+4AK0IWPieGHUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hiral Patel <hiralpat@cisco.com>,
        Suma Ramars <sramars@cisco.com>,
        Tom Tucker <tom@opengridcomputing.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 58/76] scsi: fnic: use kernels %pM format option to print MAC
Date:   Wed, 22 Jan 2020 10:29:14 +0100
Message-Id: <20200122092759.764337340@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 36fe90b0f0bdc9d030e88ba2153f3c8d6b6a5964 ]

Instead of supplying each byte through stack let's use %pM specifier.

Cc: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>
Acked-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/vnic_dev.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 9795d6f3e197..ba69d6112fa1 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -499,10 +499,7 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 
 	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
 	if (err)
-		printk(KERN_ERR
-			"Can't add addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
-			err);
+		pr_err("Can't add addr [%pM], %d\n", addr, err);
 }
 
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
@@ -517,10 +514,7 @@ void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 
 	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
 	if (err)
-		printk(KERN_ERR
-			"Can't del addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
-			err);
+		pr_err("Can't del addr [%pM], %d\n", addr, err);
 }
 
 int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
-- 
2.20.1



