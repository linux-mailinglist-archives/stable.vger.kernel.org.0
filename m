Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07528D9C07
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 22:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437301AbfJPUwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 16:52:42 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58814 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437248AbfJPUwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 16:52:38 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id C7ECA20B9C00; Wed, 16 Oct 2019 13:52:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C7ECA20B9C00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1571259157;
        bh=2YV6IZfNKusYy95VZq7usZ04z/v2U6/1CdgSHm4EGRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=cXyWJwAm4Uz6OgM2sXS10Ye6hGGR5w1eyiWIeT7rPwwJTHzVwJG+qd4mNC+7Ud814
         KzJ6gC07S6vp4Bm/+W4jkfkbX8m95r9vceBKzhTWb/I/onq8y3up8TsogJjoPX+EJ8
         wU57KV1RgWTeVHlGlAA1k1ohjhopp93xy3wAqTf0=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 6/7] cifs: smbd: Only queue work for error recovery on memory registration
Date:   Wed, 16 Oct 2019 13:51:55 -0700
Message-Id: <1571259116-102015-7-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
References: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

It's not necessary to queue invalidated memory registration to work queue, as
all we need to do is to unmap the SG and make it usable again. This can save
CPU cycles in normal data paths as memory registration errors are rare and
normally only happens during reconnection.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/smbdirect.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index cf001f10d555..c00629a41d81 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2269,12 +2269,7 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 	int rc;
 
 	list_for_each_entry(smbdirect_mr, &info->mr_list, list) {
-		if (smbdirect_mr->state == MR_INVALIDATED)
-			ib_dma_unmap_sg(
-				info->id->device, smbdirect_mr->sgl,
-				smbdirect_mr->sgl_count,
-				smbdirect_mr->dir);
-		else if (smbdirect_mr->state == MR_ERROR) {
+		if (smbdirect_mr->state == MR_ERROR) {
 
 			/* recover this MR entry */
 			rc = ib_dereg_mr(smbdirect_mr->mr);
@@ -2602,11 +2597,20 @@ int smbd_deregister_mr(struct smbd_mr *smbdirect_mr)
 		 */
 		smbdirect_mr->state = MR_INVALIDATED;
 
-	/*
-	 * Schedule the work to do MR recovery for future I/Os
-	 * MR recovery is slow and we don't want it to block the current I/O
-	 */
-	queue_work(info->workqueue, &info->mr_recovery_work);
+	if (smbdirect_mr->state == MR_INVALIDATED) {
+		ib_dma_unmap_sg(
+			info->id->device, smbdirect_mr->sgl,
+			smbdirect_mr->sgl_count,
+			smbdirect_mr->dir);
+		smbdirect_mr->state = MR_READY;
+		if (atomic_inc_return(&info->mr_ready_count) == 1)
+			wake_up_interruptible(&info->wait_mr);
+	} else
+		/*
+		 * Schedule the work to do MR recovery for future I/Os
+		 * MR recovery is slow and we don't want it to block the
+		 * current I/O */
+		queue_work(info->workqueue, &info->mr_recovery_work);
 
 done:
 	if (atomic_dec_and_test(&info->mr_used_count))
-- 
2.17.1

