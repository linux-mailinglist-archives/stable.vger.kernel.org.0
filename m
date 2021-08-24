Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D67F3F6814
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbhHXRkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241680AbhHXRih (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:38:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E7A4619E9;
        Tue, 24 Aug 2021 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824882;
        bh=JPSvbA6z+4XkcwN21qZQQSJK10TkHR2cb1jPaxsUSkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxMO8+IOND7sMGeJqH8/VECZEWzBs6CR8r8wyq7+Cx1P+b+851RZHAs7Mqz+3cGHP
         pFHdgsS6kmRMMZuoW9TIcBlC8nbX12ZKr8pDSyOk76DioFfqi4ZDs/DJJGfzHgufYH
         c1pPsyCUPMbfEjYOnJ6VjdZiQyQPyYXPON+5cBgoYkk6nmRRWqm1X3JyZygG6RuNgv
         5/lI4GkX0FJpXuyt2Zy+OhGI/dOWkkq6c8ARNha3YdTNC81QJzHNYN7X4+raWonXB1
         tOkkZqWw2kyQxDg/6odpnf6J6VzHOb9PdLQwvtszgpbnxLIqWeOopmdvelibR7+bBm
         CkRdOM+oWmshg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 19/31] scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()
Date:   Tue, 24 Aug 2021 13:07:31 -0400
Message-Id: <20210824170743.710957-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
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
index a70692779a16..34067dfd2841 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -246,7 +246,7 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 	mimd_t		mimd;
 	uint32_t	adapno;
 	int		iterator;
-
+	bool		is_found;
 
 	if (copy_from_user(&mimd, umimd, sizeof(mimd_t))) {
 		*rval = -EFAULT;
@@ -262,12 +262,16 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 
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
@@ -735,6 +739,7 @@ ioctl_done(uioc_t *kioc)
 	uint32_t	adapno;
 	int		iterator;
 	mraid_mmadp_t*	adapter;
+	bool		is_found;
 
 	/*
 	 * When the kioc returns from driver, make sure it still doesn't
@@ -757,19 +762,23 @@ ioctl_done(uioc_t *kioc)
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

