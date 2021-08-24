Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA863F67B5
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbhHXRgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242126AbhHXRei (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:34:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AC3961BA8;
        Tue, 24 Aug 2021 17:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824802;
        bh=oGeabWi9WM/jRq9Qk4TZ4TG8oYIuRbdR5vL5RuLGkIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPiJtJFXwfgdve5WiLy1EQH+t1WKPdsgs67j7t0PGUAI0TcaqNLGIAknIbXEgA/l0
         9Bz/ayroY8nia6CU0dR082rcLXSXWymKc1DmAqWf/oMRi5g/k9s4zoLsGtyByl0JVo
         IElYmZ3/syH2H7831Gp5LAsNEfRVas9RiNSwOvSaB0/kt7usS0fn7qZ5b/llXANV/R
         lhiFSvYT79gutVvPmv4V7mewxhWAHWIihGIc/kkebWwle9Rjjtilplqk9B+6+8ZW9S
         RrPQu+5YijwRrxAJXwq0/GjEROmw/Q1BBhHFzVr650iUnivWco8UPL0mkPR5z/rz5z
         0Nb2vutzSL7pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/43] scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()
Date:   Tue, 24 Aug 2021 13:05:57 -0400
Message-Id: <20210824170614.710813-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
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
index 4cf9ed96414f..d61df49e4e1b 100644
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

