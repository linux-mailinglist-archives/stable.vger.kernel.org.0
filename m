Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1263F6549
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239746AbhHXRLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240097AbhHXRKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E7F8619F7;
        Tue, 24 Aug 2021 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824429;
        bh=xB783NJEUlaFuKhiVOp50GRZsCnz3YuQeR+YZAr3PFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ril++eNogVhW5VGATVossNW4z1i5Bfp4GTQKUl3fgz0K490BG9KFFKK7qGcoRpyiB
         kGk3dIh4rE47v/22LffWNkxSzO1j/ssfsrCrSrcgE/a2QDVAWaG/LqZ/STWgUmp92m
         pwRTcsZx5l/RlTMsS+nVdRQBQMI/eXdGJ3piOjUYibuqVjpxl+vC4hHfadLnS2BXjS
         g0qK3+coZS3mSTuis4LNFbMI5x+80UbJHctXYlsxXcaiE7RcqBOtIYvhd2VHhjmMRZ
         fxg9+mp9KbGIqtgLMcnsdyI/UL7wS0X4AVQ7Z1eY0UiI6KAC049as46N/ET9aa+e15
         bT/kyxsrBPXZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 80/98] slimbus: messaging: start transaction ids from 1 instead of zero
Date:   Tue, 24 Aug 2021 12:58:50 -0400
Message-Id: <20210824165908.709932-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 9659281ce78de0f15a4aa124da8f7450b1399c09 ]

As tid is unsigned its hard to figure out if the tid is valid or
invalid. So Start the transaction ids from 1 instead of zero
so that we could differentiate between a valid tid and invalid tids

This is useful in cases where controller would add a tid for controller
specific transfers.

Fixes: d3062a210930 ("slimbus: messaging: add slim_alloc/free_txn_tid()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210809082428.11236-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/messaging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index d5879142dbef..3b77713f1e3f 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -66,7 +66,7 @@ int slim_alloc_txn_tid(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 	int ret = 0;
 
 	spin_lock_irqsave(&ctrl->txn_lock, flags);
-	ret = idr_alloc_cyclic(&ctrl->tid_idr, txn, 0,
+	ret = idr_alloc_cyclic(&ctrl->tid_idr, txn, 1,
 				SLIM_MAX_TIDS, GFP_ATOMIC);
 	if (ret < 0) {
 		spin_unlock_irqrestore(&ctrl->txn_lock, flags);
-- 
2.30.2

