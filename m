Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832CC3F66BD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240668AbhHXR1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241614AbhHXRZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:25:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB79161B3B;
        Tue, 24 Aug 2021 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824643;
        bh=JlAChC0NDvnHCGqHRCn5zrNe29Lr+0u/OSXqd75o3sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBWeXQiOQicaI7GnNtH0EGbMnXbcDwGd78Oz7omW8HelO3BalrDi4G9JvlbXcwCfv
         iy3I8vp3Q/ZF4qeiUuNhII9ru2B0ypm24Ykr1WNL1F19ladsOiZBl494czrtDSWzjw
         p2nEzsAZN5uS2Fr2V6gXDf0G0pqMUtq5A1de4aTfsbjtEdF58iOaLbGfN9sYhhbain
         Jv5kCsHpScDHWVrBp6shw3cnE1ipaxr6NbO4pbNRx2i+3vlAg2Ly7IYhz76lhpj6vE
         L8CzUz9yzt/HkQFBr/8cMnLsq88gQqxbpFXgk27xl9QQx72+jLFWxlC+3hznPKUtkN
         wbmukcU5LCZcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 74/84] slimbus: messaging: check for valid transaction id
Date:   Tue, 24 Aug 2021 13:02:40 -0400
Message-Id: <20210824170250.710392-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit a263c1ff6abe0e66712f40d595bbddc7a35907f8 ]

In some usecases transaction ids are dynamically allocated inside
the controller driver after sending the messages which have generic
acknowledge responses. So check for this before refcounting pm_runtime.

Without this we would end up imbalancing runtime pm count by
doing pm_runtime_put() in both slim_do_transfer() and slim_msg_response()
for a single  pm_runtime_get() in slim_do_transfer()

Fixes: d3062a210930 ("slimbus: messaging: add slim_alloc/free_txn_tid()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210809082428.11236-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/messaging.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index 3b77713f1e3f..ddf0371ad52b 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -131,7 +131,8 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 			goto slim_xfer_err;
 		}
 	}
-
+	/* Initialize tid to invalid value */
+	txn->tid = 0;
 	need_tid = slim_tid_txn(txn->mt, txn->mc);
 
 	if (need_tid) {
@@ -163,7 +164,7 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 			txn->mt, txn->mc, txn->la, ret);
 
 slim_xfer_err:
-	if (!clk_pause_msg && (!need_tid  || ret == -ETIMEDOUT)) {
+	if (!clk_pause_msg && (txn->tid == 0  || ret == -ETIMEDOUT)) {
 		/*
 		 * remove runtime-pm vote if this was TX only, or
 		 * if there was error during this transaction
-- 
2.30.2

