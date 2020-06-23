Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7312064F9
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391018AbgFWV37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389183AbgFWUOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:14:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDBA02073E;
        Tue, 23 Jun 2020 20:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943255;
        bh=X1Fz7wCTOgVSWRvarBEikRrwLRPmf9rhqqpX0+S5nug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lv2XQHnvbfuTftpL3jaZRiPr/nf0L4wEr1oI9GBMjFrHZAAbrc/XkVvM7s5y4lcO6
         nJwhCrGxfwOrkDhyZKHeukE5X1otO1xWyhmSTOC3zhkmN2XDvlBjjzQ9P3PufIYdS8
         Ds/7NXvPxuz18PdUYCfeoePnYygLVqVdH/daZH5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 320/477] RDMA/cm: Spurious WARNING triggered in cm_destroy_id()
Date:   Tue, 23 Jun 2020 21:55:17 +0200
Message-Id: <20200623195422.657923835@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 17f14e0eafe4d..1c2bf18cda9f6 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1076,7 +1076,9 @@ retest:
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



