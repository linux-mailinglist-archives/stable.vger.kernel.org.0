Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC56C2788A6
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgIYMtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728960AbgIYMtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8350221EC;
        Fri, 25 Sep 2020 12:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038190;
        bh=pFnusHJUZvPDO2yJHNElEhp6xOkrXRExIUFBS4AtXps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7avVTwKuo3y+0xl7IUugrj6PXCTVN763MMkbWkvsikm2QtAxiK8aDQzv7Zf6vaHa
         9R32QFhXtXkgOyobUCsMEr2vf6l5ytz7WAeJSlaJCYcsSQDqDsN0YduJjgVR9/NIUb
         LRNuyE6BdlU9Udw4mYAnflSAN5YGHr19JIjF4zG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ganji Aravind <ganji.aravind@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 07/56] cxgb4: Fix offset when clearing filter byte counters
Date:   Fri, 25 Sep 2020 14:47:57 +0200
Message-Id: <20200925124728.948689621@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
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
@@ -1906,13 +1906,16 @@ out:
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


