Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD473E5D9B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbhHJOWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243495AbhHJOTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADF7361179;
        Tue, 10 Aug 2021 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628605033;
        bh=JPSvbA6z+4XkcwN21qZQQSJK10TkHR2cb1jPaxsUSkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJ0OUekxrGCjuMytF64pordibpqPHbHTGs2n79VMoCK2xSoDY04bB9z27mKD6gtgl
         o3Ya1RpE4a4WKwGDcV5i0iqvoJ77cB+ALOYh7AWke97YREbuTnbItyzNknzGXvmQC5
         y8qhSFzQu8rmdOYJHjgIuRb+7Bvt3enyrbYPk2pFwIO2eroX6SiUz6CM+A9hKiUf2o
         4KEMlXdb0yWTy42Vdxgr2faEIPbkrhzydDmE031ZrU3tyA7xuywFigSe5/vFL0V6lL
         8w7DficcCa2rl4VB212q83AwWERZIRLuN+tIrr3GBmlCPnqGEByO3C8E9m/qQnlUrq
         6bi+neP96EqPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/6] scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()
Date:   Tue, 10 Aug 2021 10:17:05 -0400
Message-Id: <20210810141707.3118714-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141707.3118714-1-sashal@kernel.org>
References: <20210810141707.3118714-1-sashal@kernel.org>
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

