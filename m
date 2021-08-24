Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C783F6686
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239335AbhHXRZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240496AbhHXRX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:23:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7357D61880;
        Tue, 24 Aug 2021 17:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824624;
        bh=AwqjrjjY94GQuOfdw59ppoeSmcG8CeLfey2xL7hWKXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5aVUkKfS/THBptWdU02y58PG5lxqbb6ANYx0Sbhg2xuZRgz5eG4iHyBdxpt3+GGU
         nkSoCtul4ySDhhBVYdROS6IEsrtbMu5KvHK72kNKDj3HYi9iiwvzGzyH3wCXhurSCu
         zGKu+pkakBGlN93FRSr4YGh4+3pmxTOldX7e3Ib8SRpeViTEGZFiKV5y12F+CatJTY
         W4djdJpqMEF0t3dNvtH8gZAzJuCQwOMLRzKYwAm3xwyuwEubVlzPatixX0J5USm6DU
         DSF7FURazf/Yrr2l0pLChxNlPGAvSD52slq7dv1NC0qZIVxCTjhhWTXmz1Awxzmaiq
         f2QD3RaIukE9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/84] scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()
Date:   Tue, 24 Aug 2021 13:02:20 -0400
Message-Id: <20210824170250.710392-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshvardhan Jha <harshvardhan.jha@oracle.com>

[ Upstream commit 77541f78eadfe9fdb018a7b8b69f0f2af2cf4b82 ]

The list_for_each_entry() iterator, "adapter" in this code, can never be
NULL.  If we exit the loop without finding the correct adapter then
"adapter" points invalid memory that is an offset from the list head.  This
will eventually lead to memory corruption and presumably a kernel crash.

Link: https://lore.kernel.org/r/20210708074642.23599-1-harshvardhan.jha@oracle.com
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_mm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 8428247015db..81df2c94b747 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -250,7 +250,7 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 	mimd_t		mimd;
 	uint32_t	adapno;
 	int		iterator;
-
+	bool		is_found;
 
 	if (copy_from_user(&mimd, umimd, sizeof(mimd_t))) {
 		*rval = -EFAULT;
@@ -266,12 +266,16 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 
 	adapter = NULL;
 	iterator = 0;
+	is_found = false;
 
 	list_for_each_entry(adapter, &adapters_list_g, list) {
-		if (iterator++ == adapno) break;
+		if (iterator++ == adapno) {
+			is_found = true;
+			break;
+		}
 	}
 
-	if (!adapter) {
+	if (!is_found) {
 		*rval = -ENODEV;
 		return NULL;
 	}
@@ -737,6 +741,7 @@ ioctl_done(uioc_t *kioc)
 	uint32_t	adapno;
 	int		iterator;
 	mraid_mmadp_t*	adapter;
+	bool		is_found;
 
 	/*
 	 * When the kioc returns from driver, make sure it still doesn't
@@ -759,19 +764,23 @@ ioctl_done(uioc_t *kioc)
 		iterator	= 0;
 		adapter		= NULL;
 		adapno		= kioc->adapno;
+		is_found	= false;
 
 		con_log(CL_ANN, ( KERN_WARNING "megaraid cmm: completed "
 					"ioctl that was timedout before\n"));
 
 		list_for_each_entry(adapter, &adapters_list_g, list) {
-			if (iterator++ == adapno) break;
+			if (iterator++ == adapno) {
+				is_found = true;
+				break;
+			}
 		}
 
 		kioc->timedout = 0;
 
-		if (adapter) {
+		if (is_found)
 			mraid_mm_dealloc_kioc( adapter, kioc );
-		}
+
 	}
 	else {
 		wake_up(&wait_q);
-- 
2.30.2

