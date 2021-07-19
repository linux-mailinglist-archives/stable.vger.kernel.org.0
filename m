Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546B53CE148
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346423AbhGSPZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345966AbhGSPQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:16:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11A4B6127C;
        Mon, 19 Jul 2021 15:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710228;
        bh=5s5W2nW/VJwzeHHfStZ6DKDgBTQn+P3DbBHGlW+c7Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkXMqHIwRrlslxuWTlImg6OZ7kDhDyzGR2ICE4ZeWlSW5hypJvKXdysPvbwVO86Tx
         zchAEG2AqDGThXjyP0Abqy9R3OPG+eg3EZxN8QjgwJi1SOWDFRWFwnScwlKLY2yqCv
         RMz4lcMQiKZFLQl4DP9Py1opm5SlSRcv5V+fp2OY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siddharth Gupta <sidgup@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/243] remoteproc: core: Fix cdev remove and rproc del
Date:   Mon, 19 Jul 2021 16:52:38 +0200
Message-Id: <20210719144945.082764029@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddharth Gupta <sidgup@codeaurora.org>

[ Upstream commit 930eec0be20c93a53160c74005a1485a230e6911 ]

The rproc_char_device_remove() call currently unmaps the cdev
region instead of simply deleting the cdev that was added as a
part of the rproc_char_device_add() call. This change fixes that
behaviour, and also fixes the order in which device_del() and
cdev_del() need to be called.

Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
Link: https://lore.kernel.org/r/1623723671-5517-4-git-send-email-sidgup@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_cdev.c | 2 +-
 drivers/remoteproc/remoteproc_core.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_cdev.c b/drivers/remoteproc/remoteproc_cdev.c
index b19ea3057bde..ff92ed25d8b0 100644
--- a/drivers/remoteproc/remoteproc_cdev.c
+++ b/drivers/remoteproc/remoteproc_cdev.c
@@ -111,7 +111,7 @@ int rproc_char_device_add(struct rproc *rproc)
 
 void rproc_char_device_remove(struct rproc *rproc)
 {
-	__unregister_chrdev(MAJOR(rproc->dev.devt), rproc->index, 1, "remoteproc");
+	cdev_del(&rproc->cdev);
 }
 
 void __init rproc_init_cdev(void)
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index dab2c0f5caf0..47924d5ed4f5 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2290,7 +2290,6 @@ int rproc_del(struct rproc *rproc)
 	mutex_unlock(&rproc->lock);
 
 	rproc_delete_debug_dir(rproc);
-	rproc_char_device_remove(rproc);
 
 	/* the rproc is downref'ed as soon as it's removed from the klist */
 	mutex_lock(&rproc_list_mutex);
@@ -2301,6 +2300,7 @@ int rproc_del(struct rproc *rproc)
 	synchronize_rcu();
 
 	device_del(&rproc->dev);
+	rproc_char_device_remove(rproc);
 
 	return 0;
 }
-- 
2.30.2



