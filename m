Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793BF1FE645
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgFRCcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729442AbgFRBPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880F8221EB;
        Thu, 18 Jun 2020 01:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442909;
        bh=8dWe8dNHmHjFruy6tr76/ZHDAnAMRcZD/e9OgpgnMeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoFdzrhR+ZS7JKtwQW+pROHz69+WHZnOQhWT+HMqMs+vCXXegeI3NiuiCYOOzgLfV
         YXaz0QaKa+ncxckr3qKX8wZr2PW5DblR0EiQngSh4HjpseQEMiDCfu1wjS3yAArR1y
         mWRnKV1x/qxZWT3yvvwdMOH+85Sxh3N6MBtXsgqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 328/388] RDMA/cm: Spurious WARNING triggered in cm_destroy_id()
Date:   Wed, 17 Jun 2020 21:07:05 -0400
Message-Id: <20200618010805.600873-328-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

[ Upstream commit fba97dc7fc76b2c9a909fa0b3786d30a9899f5cf ]

If the cm_id state is IB_CM_REP_SENT when cm_destroy_id() is called, it
calls cm_send_rej_locked().

In cm_send_rej_locked(), it calls cm_enter_timewait() and the state is
changed to IB_CM_TIMEWAIT.

Now back to cm_destroy_id(), it breaks from the switch statement, and the
next call is WARN_ON(cm_id->state != IB_CM_IDLE).

This triggers a spurious warning. Instead, the code should goto retest
after returning from cm_send_rej_locked() to move the state to IDLE.

Fixes: 67b3c8dceac6 ("RDMA/cm: Make sure the cm_id is in the IB_CM_IDLE state in destroy")
Link: https://lore.kernel.org/r/1591191218-9446-1-git-send-email-ka-cheong.poon@oracle.com
Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 17f14e0eafe4..1c2bf18cda9f 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1076,7 +1076,9 @@ static void cm_destroy_id(struct ib_cm_id *cm_id, int err)
 	case IB_CM_REP_SENT:
 	case IB_CM_MRA_REP_RCVD:
 		ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
-		/* Fall through */
+		cm_send_rej_locked(cm_id_priv, IB_CM_REJ_CONSUMER_DEFINED, NULL,
+				   0, NULL, 0);
+		goto retest;
 	case IB_CM_MRA_REQ_SENT:
 	case IB_CM_REP_RCVD:
 	case IB_CM_MRA_REP_SENT:
-- 
2.25.1

