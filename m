Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BD7278836
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgIYMxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbgIYMxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:53:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FCF52075E;
        Fri, 25 Sep 2020 12:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038422;
        bh=VDt7r3woC7LTg2GRHiQhEspTdp95zxK8PVx7W4tdc6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9aTGEMMycwF4vZBD7GW1iA42Ssn2GzdTnNZjqFQZ/qrIRB0KpvYPVK93pAi/q+2z
         PGLfIaDKlVTKh6yu8EQQMZRhgj5HQrSHS5gQzyVsdtlzniAXLh7MeLBeD6d78GInsn
         otdzWA16eAGFR6Z7vSUtnvbzeUTw0xHj3bq9fHs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ganji Aravind <ganji.aravind@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 05/37] cxgb4: Fix offset when clearing filter byte counters
Date:   Fri, 25 Sep 2020 14:48:33 +0200
Message-Id: <20200925124721.762475323@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ganji Aravind <ganji.aravind@chelsio.com>

[ Upstream commit 94cc242a067a869c29800aa789d38b7676136e50 ]

Pass the correct offset to clear the stale filter hit
bytes counter. Otherwise, the counter starts incrementing
from the stale information, instead of 0.

Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
Signed-off-by: Ganji Aravind <ganji.aravind@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -1591,13 +1591,16 @@ out:
 static int configure_filter_tcb(struct adapter *adap, unsigned int tid,
 				struct filter_entry *f)
 {
-	if (f->fs.hitcnts)
+	if (f->fs.hitcnts) {
 		set_tcb_field(adap, f, tid, TCB_TIMESTAMP_W,
-			      TCB_TIMESTAMP_V(TCB_TIMESTAMP_M) |
+			      TCB_TIMESTAMP_V(TCB_TIMESTAMP_M),
+			      TCB_TIMESTAMP_V(0ULL),
+			      1);
+		set_tcb_field(adap, f, tid, TCB_RTT_TS_RECENT_AGE_W,
 			      TCB_RTT_TS_RECENT_AGE_V(TCB_RTT_TS_RECENT_AGE_M),
-			      TCB_TIMESTAMP_V(0ULL) |
 			      TCB_RTT_TS_RECENT_AGE_V(0ULL),
 			      1);
+	}
 
 	if (f->fs.newdmac)
 		set_tcb_tflag(adap, f, tid, TF_CCTRL_ECE_S, 1,


