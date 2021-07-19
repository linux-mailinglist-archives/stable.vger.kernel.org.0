Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F2D3CE508
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238394AbhGSPrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349653AbhGSPpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1616F60FE9;
        Mon, 19 Jul 2021 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711954;
        bh=NSz0HggK+LEffCybsslj3iHeHYAzmgeuo1Ce2nB3UMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5VxRA+CfUyxY+PYiRKJD0QCnX/Mu14QuRA+Qjjdf6wQss4+v+oyYCPoTRWA2dWRR
         vhmToMeRqrs1m95d3z/7T0HtexZp0UolNnK8VNp4/AXy6FNGyWwuUo+92+HmnSwo0W
         Tsz3cbP26Q7KAzXQ86fNvm6JXBW0tCYqygBguMX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siddharth Gupta <sidgup@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 151/292] remoteproc: core: Fix cdev remove and rproc del
Date:   Mon, 19 Jul 2021 16:53:33 +0200
Message-Id: <20210719144947.456762018@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index ab150765d124..d9d2a240dd58 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2357,7 +2357,6 @@ int rproc_del(struct rproc *rproc)
 	mutex_unlock(&rproc->lock);
 
 	rproc_delete_debug_dir(rproc);
-	rproc_char_device_remove(rproc);
 
 	/* the rproc is downref'ed as soon as it's removed from the klist */
 	mutex_lock(&rproc_list_mutex);
@@ -2368,6 +2367,7 @@ int rproc_del(struct rproc *rproc)
 	synchronize_rcu();
 
 	device_del(&rproc->dev);
+	rproc_char_device_remove(rproc);
 
 	return 0;
 }
-- 
2.30.2



