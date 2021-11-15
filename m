Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF844451E25
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345124AbhKPAfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344627AbhKOTZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5797163353;
        Mon, 15 Nov 2021 19:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002877;
        bh=F9d/ltFgpz546J7V7BZDQo31lZcv65VDwmyeHzdymF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6r/8GMt4+mg8Ypr+yUmD8XyEtFO0CH2Fc3z4Zfd7rC0a9PgOpDqoYBt7dKDL5Vlb
         zx+iiaGWQPmHcZP4FFTzgnwub2jmK5xzi0Rh4tJppTP2+NL9MyJV/NLLSq2p+x1Nh9
         CJxynG07tll1tOQU923vgHU/wQMamGAMaSIUmxP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 702/917] dmaengine: idxd: move out percpu_ref_exit() to ensure its outside submission
Date:   Mon, 15 Nov 2021 18:03:17 +0100
Message-Id: <20211115165452.683790140@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 85f604af9c83a4656b1d07bec73298c3ba7d7c1e ]

percpu_ref_tryget_live() is safe to call as long as ref is between init and
exit according to the function comment. Move percpu_ref_exit() so it is
called after the dma channel is no longer valid to ensure this holds true.

Fixes: 93a40a6d7428 ("dmaengine: idxd: add percpu_ref to descriptor submission path")
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/163294293832.914350.10326422026738506152.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 1 -
 drivers/dma/idxd/dma.c    | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 83a5ff2ecf2a0..cbbfa17d8d11b 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -427,7 +427,6 @@ void idxd_wq_quiesce(struct idxd_wq *wq)
 {
 	percpu_ref_kill(&wq->wq_active);
 	wait_for_completion(&wq->wq_dead);
-	percpu_ref_exit(&wq->wq_active);
 }
 
 /* Device control bits */
diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index e0f056c1d1f56..b90b085d18cff 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -311,6 +311,7 @@ static int idxd_dmaengine_drv_probe(struct idxd_dev *idxd_dev)
 
 err_dma:
 	idxd_wq_quiesce(wq);
+	percpu_ref_exit(&wq->wq_active);
 err_ref:
 	idxd_wq_free_resources(wq);
 err_res_alloc:
@@ -329,6 +330,7 @@ static void idxd_dmaengine_drv_remove(struct idxd_dev *idxd_dev)
 	idxd_wq_quiesce(wq);
 	idxd_unregister_dma_channel(wq);
 	__drv_disable_wq(wq);
+	percpu_ref_exit(&wq->wq_active);
 	idxd_wq_free_resources(wq);
 	wq->type = IDXD_WQT_NONE;
 	mutex_unlock(&wq->wq_lock);
-- 
2.33.0



