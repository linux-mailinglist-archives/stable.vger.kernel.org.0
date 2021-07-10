Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF08A3C382B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhGJXyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232394AbhGJXxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBC22613AF;
        Sat, 10 Jul 2021 23:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961044;
        bh=5s5W2nW/VJwzeHHfStZ6DKDgBTQn+P3DbBHGlW+c7Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFd7yNCEX+OOoxik1DWG3NM1i4ro245ynr6oEcVa/G8WknMiChkVrcW0Z1KYVSaCF
         JQ19jgCtGgqZ/cJ5pj57gnRJ0n9UnSN4808R75rJKWMwg+9MlzfxHEzjIJawr/7shj
         9QgHstL739XSb8w55p7Q2AM0mGI9H5i9uTb7UNAuidRHktkYbr8Tn+b9dqo/HxjTPr
         6dQNDvuatpr2Qgyizdu/ZQOrgs+b/LWtqIRcZMdWPInFhJ6v4yWEAga9CYuEgp76rz
         7c3ydSAUEUGfpSjICTzdY770PU0ezyHfs9PX8pAL3C4KS7A1ejULqJG+Ar62YT1Xlg
         tjYbFw9FKkT2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Siddharth Gupta <sidgup@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/37] remoteproc: core: Fix cdev remove and rproc del
Date:   Sat, 10 Jul 2021 19:49:58 -0400
Message-Id: <20210710235016.3221124-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

