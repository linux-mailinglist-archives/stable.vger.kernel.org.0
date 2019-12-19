Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78414125FFE
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 11:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLSKxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 05:53:40 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59685 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726652AbfLSKxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 05:53:40 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9013322390;
        Thu, 19 Dec 2019 05:53:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 19 Dec 2019 05:53:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PhrBpT
        IqTYfKeAiYYnh15rpR9pMQ9qXgM8hGtiIaRNk=; b=OklB0Z+PFZKKmLuOKGE3GI
        KH01i2KsQK5cVGA4Pmx1pizw500IKpdPUU5p9JBqZF1kWwrEKL020unJmiGBye7m
        xNnDz36hnZOTDbQgl/Ke6dh7ixUfcO32OW8EeDeFP5pxJIFIinIFeUzbalicLjf4
        6yfLlZpk9dRq2MCs1OlOcavUYdaBCKGNx3nEtNSzKSxv+vpipnZ9PQ+BV2eibWQL
        M2ncWEv2n/M8Wmd3gV9C/JkicGGmFNy+t/d8IUhgfVZHDFOyh/cCyWazW20yPogk
        zEQA8qRaN8REaK2L2Mw5suE+Abnv1VB3ZmqWmy2DuTycN1uEqlBxKHE8MqGGye/w
        ==
X-ME-Sender: <xms:s1b7XVwkEkGBu3zwCzELm2nago7ejeN1JzdDZsdBFKyQI09KrZNzOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdduuddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:s1b7XZDolDF0BEyHEFHl8ASC4AcrOCkuwFBAd78DdQ5FILIPZ9sQ9g>
    <xmx:s1b7XYNxYA8yiDLBJY683TliurT3myeF2ZQK4qM0aHAKHvJWuGxdvg>
    <xmx:s1b7Xfptx59b_U27TobBs88zM8K3T4ypsUlnZlAYqpxpMBPYi2-nNQ>
    <xmx:s1b7XfnLGBp98mKuAqz8FT34uUQ-gWgDc4GiZY6vehq1YWqymuBRfw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2571830609DC;
        Thu, 19 Dec 2019 05:53:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] cifs: smbd: Only queue work for error recovery on memory" failed to apply to 4.19-stable tree
To:     longli@microsoft.com, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Dec 2019 11:53:36 +0100
Message-ID: <15767528162211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c21ce58eab1eda4c66507897207e20c82e62a5ac Mon Sep 17 00:00:00 2001
From: Long Li <longli@microsoft.com>
Date: Wed, 16 Oct 2019 13:51:55 -0700
Subject: [PATCH] cifs: smbd: Only queue work for error recovery on memory
 registration

It's not necessary to queue invalidated memory registration to work queue, as
all we need to do is to unmap the SG and make it usable again. This can save
CPU cycles in normal data paths as memory registration errors are rare and
normally only happens during reconnection.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index d91f2f60e2df..5b1b97e9e0c9 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2271,12 +2271,7 @@ static void smbd_mr_recovery_work(struct work_struct *work)
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
@@ -2604,11 +2599,20 @@ int smbd_deregister_mr(struct smbd_mr *smbdirect_mr)
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
+		 * Schedule the work to do MR recovery for future I/Os MR
+		 * recovery is slow and don't want it to block current I/O
+		 */
+		queue_work(info->workqueue, &info->mr_recovery_work);
 
 done:
 	if (atomic_dec_and_test(&info->mr_used_count))

