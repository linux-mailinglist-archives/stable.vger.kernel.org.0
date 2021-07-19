Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580493CE2C9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbhGSPcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348237AbhGSPaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1846613DF;
        Mon, 19 Jul 2021 16:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710958;
        bh=rmi9s/x2tyhycHO8DxNQB8FZGrm8bIHajaa5Khfl9Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gghCeQmlG5gq7jzzMFoNPzRYpwUCh9JNK8FOcwviVdsxt23SgjT6iat8rforw1J3K
         yHZByzao/5PiTwUXh/Lpvfqm0vSLDCscKRPecI7zsfbuRqBIWjirnQVM8c8XhOTWUw
         wd6QrkjFqG02lIu+ig5dIaKUP76OU4XYRgHY36m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siddharth Gupta <sidgup@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 174/351] remoteproc: core: Fix cdev remove and rproc del
Date:   Mon, 19 Jul 2021 16:52:00 +0200
Message-Id: <20210719144950.732348342@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 0b8a84c04f76..4ad98b0b8caa 100644
--- a/drivers/remoteproc/remoteproc_cdev.c
+++ b/drivers/remoteproc/remoteproc_cdev.c
@@ -124,7 +124,7 @@ int rproc_char_device_add(struct rproc *rproc)
 
 void rproc_char_device_remove(struct rproc *rproc)
 {
-	__unregister_chrdev(MAJOR(rproc->dev.devt), rproc->index, 1, "remoteproc");
+	cdev_del(&rproc->cdev);
 }
 
 void __init rproc_init_cdev(void)
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 626a6b90fba2..203e2bd8ebb4 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2602,7 +2602,6 @@ int rproc_del(struct rproc *rproc)
 	mutex_unlock(&rproc->lock);
 
 	rproc_delete_debug_dir(rproc);
-	rproc_char_device_remove(rproc);
 
 	/* the rproc is downref'ed as soon as it's removed from the klist */
 	mutex_lock(&rproc_list_mutex);
@@ -2613,6 +2612,7 @@ int rproc_del(struct rproc *rproc)
 	synchronize_rcu();
 
 	device_del(&rproc->dev);
+	rproc_char_device_remove(rproc);
 
 	return 0;
 }
-- 
2.30.2



