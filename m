Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D59B12EC53
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgABWRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgABWRX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 226A821582;
        Thu,  2 Jan 2020 22:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003442;
        bh=Ac/b8JjHYpaB7AAxoLz8MCMO6ze4YNLhZJNc5ivWTcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=088qDKWLk5KuTJbufA4Qd+G6ePzhW0ivLM8tar4esGSqIOKKrt7+sakUEkIsngbp/
         MmECyDgcH/JEk/9XKU2ziGPqOOJwV++YePXunYuuTToqgEAHIxVuJO/xh9JQTlQnK9
         VWmYv1mWNd1WzzHDp00s/RKYo3PHJzZVbbPfFPE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 162/191] bnxt_en: Remove unnecessary NULL checks for fw_health
Date:   Thu,  2 Jan 2020 23:07:24 +0100
Message-Id: <20200102215846.738549087@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 0797c10d2d1fa0d6f14612404781b348fc757c3e ]

After fixing the allocation of bp->fw_health in the previous patch,
the driver will not go through the fw reset and recovery code paths
if bp->fw_health allocation fails.  So we can now remove the
unnecessary NULL checks.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |    6 ++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |    6 +-----
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9953,8 +9953,7 @@ static void bnxt_fw_health_check(struct
 	struct bnxt_fw_health *fw_health = bp->fw_health;
 	u32 val;
 
-	if (!fw_health || !fw_health->enabled ||
-	    test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+	if (!fw_health->enabled || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return;
 
 	if (fw_health->tmr_counter) {
@@ -10697,8 +10696,7 @@ static void bnxt_fw_reset_task(struct wo
 		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
 		return;
 	case BNXT_FW_RESET_STATE_ENABLE_DEV:
-		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state) &&
-		    bp->fw_health) {
+		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
 			u32 val;
 
 			val = bnxt_fw_health_readl(bp,
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -19,11 +19,10 @@ static int bnxt_fw_reporter_diagnose(str
 				     struct devlink_fmsg *fmsg)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
-	struct bnxt_fw_health *health = bp->fw_health;
 	u32 val, health_status;
 	int rc;
 
-	if (!health || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return 0;
 
 	val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
@@ -162,9 +161,6 @@ void bnxt_devlink_health_report(struct b
 	struct bnxt_fw_health *fw_health = bp->fw_health;
 	struct bnxt_fw_reporter_ctx fw_reporter_ctx;
 
-	if (!fw_health)
-		return;
-
 	fw_reporter_ctx.sp_event = event;
 	switch (event) {
 	case BNXT_FW_RESET_NOTIFY_SP_EVENT:


