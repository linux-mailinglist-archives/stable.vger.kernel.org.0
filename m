Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26456247409
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbgHQTEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbgHQPpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:45:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E5652067C;
        Mon, 17 Aug 2020 15:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679134;
        bh=Y7FLL9CrPKnGZCPGfu9yZYBPkWT6HM7M3CvL0nstTao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=So9uEqT0W47lTwH8jcfcYHgMkz746C/s0Orwm8K3TzKesZSg5mYppZdyCbmYid0QM
         jFQHvv0+/POpuzBWkMZirCiFSQ07FMrXNba7BgvlYPZEd68AfIO2qGuW0yK2h/ugWQ
         /p/rxzgTdtGXAPPNt05ZuMlRapN6p9f8P2yvRtck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 107/393] ionic: update eid test for overflow
Date:   Mon, 17 Aug 2020 17:12:37 +0200
Message-Id: <20200817143824.804809171@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 3fbc9bb6ca32d12d4d32a7ae32abef67ac95f889 ]

Fix up our comparison to better handle a potential (but largely
unlikely) wrap around.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 337d971ffd92c..29f77faa808bb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -709,7 +709,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 	eid = le64_to_cpu(comp->event.eid);
 
 	/* Have we run out of new completions to process? */
-	if (eid <= lif->last_eid)
+	if ((s64)(eid - lif->last_eid) <= 0)
 		return false;
 
 	lif->last_eid = eid;
-- 
2.25.1



