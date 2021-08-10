Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222373E5DB1
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242361AbhHJOWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242719AbhHJOS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:18:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14311610FF;
        Tue, 10 Aug 2021 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628605006;
        bh=qHc2rfSYFv/TMHp2CozCBZWjbBMZ0+ljM3C6bgtbvcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcafgsHiXThF74DV8KdyHF3xdzNljwXPHmP5Nsyv4NSTnqZSys0FSpG8hrYbwVCEG
         dth2OW7EhrdR9T3+ituBglP581/WV9w5Op5/sHEciZ2y0d1giFejynssyv3TqJja0L
         6B4zmAL24nG2vsTLQvQGc9eKhpEC7YBdNfFcCuryfW/SC2IlaEhdD8QfVyxWmzKTua
         VFz9pi6sdFDU3mnJb9g3If0IE3ahnDeYa6e4JlXbJg8IoFCgoTPYT2Csq9cgpBMjmB
         S0PBrH0rV8ywP1ghB4WzZL3QTrnlXLpnHQ62jyDqvwuMIEPd1PA5d/XzY9ymbm+2tc
         3nsf6IUQ0BzqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/10] scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()
Date:   Tue, 10 Aug 2021 10:16:35 -0400
Message-Id: <20210810141641.3118360-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141641.3118360-1-sashal@kernel.org>
References: <20210810141641.3118360-1-sashal@kernel.org>
MIME-Version: 1.0
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
index 65b6f6ace3a5..8ec308c5970f 100644
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
@@ -739,6 +743,7 @@ ioctl_done(uioc_t *kioc)
 	uint32_t	adapno;
 	int		iterator;
 	mraid_mmadp_t*	adapter;
+	bool		is_found;
 
 	/*
 	 * When the kioc returns from driver, make sure it still doesn't
@@ -761,19 +766,23 @@ ioctl_done(uioc_t *kioc)
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

