Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704EED9BFA
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 22:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437250AbfJPUwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 16:52:20 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58622 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437248AbfJPUwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 16:52:20 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id CA92920B711B; Wed, 16 Oct 2019 13:52:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CA92920B711B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1571259139;
        bh=sUUcSC83PEh9XnoXq1c/QwoVpW+DLqUxNnS3yQphdiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=olaFMTd7pK7xQmBODB3EmL9Qy8tc7oqsQdmNfteF01rhgWyf9gYTi4A8wzO+L/FEm
         xlbRnr7e/fhRJJtgfFH6dwA4yzAlUKt5plWDvpkpJsL8UkB+wtPz67jziIYaWSX7Df
         MSKG35MU3dTlpzjXE0zbdvY7jYfDTx4z+cFJfT8Y=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 2/7] cifs: smbd: Invalidate and deregister memory registration on re-send
Date:   Wed, 16 Oct 2019 13:51:51 -0700
Message-Id: <1571259116-102015-3-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
References: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

On re-send, there might be a reconnect and all prevoius memory registrations
need to be invalidated and deregistered.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/file.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4b95700c507c..3c4e01e56798 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2747,9 +2747,17 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
 		if (!rc) {
 			if (wdata->cfile->invalidHandle)
 				rc = -EAGAIN;
-			else
+			else {
+#ifdef CONFIG_CIFS_SMB_DIRECT
+				if (wdata->mr) {
+					wdata->mr->need_invalidate = true;
+					smbd_deregister_mr(wdata->mr);
+					wdata->mr = NULL;
+				}
+#endif
 				rc = server->ops->async_writev(wdata,
 					cifs_uncached_writedata_release);
+			}
 		}
 
 		/* If the write was successfully sent, we are done */
@@ -3472,7 +3480,14 @@ static int cifs_resend_rdata(struct cifs_readdata *rdata,
 		if (!rc) {
 			if (rdata->cfile->invalidHandle)
 				rc = -EAGAIN;
-			else
+			else {
+#ifdef CONFIG_CIFS_SMB_DIRECT
+				if (rdata->mr) {
+					rdata->mr->need_invalidate = true;
+					smbd_deregister_mr(rdata->mr);
+					rdata->mr = NULL;
+				}
+#endif
 				rc = server->ops->async_readv(rdata);
 		}
 
-- 
2.17.1

