Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 913581F135
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731148AbfEOLWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730877AbfEOLWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:22:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 581EC20818;
        Wed, 15 May 2019 11:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919327;
        bh=q6v72+Ja18F0YRjkSCV3jO77DtMZBJHsNepQUcLXMWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y63PBAf6oMg+ktvkZJuRmqM12l+4VWN2G1lFYxWKnUOqNIursG9VQLQAmYgSUrxkj
         /Rr6/T9qIiATFgx18iD7KCrCH69gw9QbTx+U/JdiO+GlZAkP5TeL//OXXY7ub84UvN
         9imavnSPVDGQbXN5AbIq3fk8nl0bZonMPa/R0eUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/113] qede: fix write to freed pointer error and double free of ptp
Date:   Wed, 15 May 2019 12:55:23 +0200
Message-Id: <20190515090656.019391191@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1dc2b3d65523780ed1972d446c76e62e13f3e8f5 ]

The err2 error return path calls qede_ptp_disable that cleans up
on an error and frees ptp. After this, the free'd ptp is dereferenced
when ptp->clock is set to NULL and the code falls-through to error
path err1 that frees ptp again.

Fix this by calling qede_ptp_disable and exiting via an error
return path that does not set ptp->clock or kfree ptp.

Addresses-Coverity: ("Write to pointer after free")
Fixes: 035744975aec ("qede: Add support for PTP resource locking.")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_ptp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index 013ff567283c7..5e574c3b625e5 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -490,18 +490,17 @@ int qede_ptp_enable(struct qede_dev *edev, bool init_tc)
 
 	ptp->clock = ptp_clock_register(&ptp->clock_info, &edev->pdev->dev);
 	if (IS_ERR(ptp->clock)) {
-		rc = -EINVAL;
 		DP_ERR(edev, "PTP clock registration failed\n");
+		qede_ptp_disable(edev);
+		rc = -EINVAL;
 		goto err2;
 	}
 
 	return 0;
 
-err2:
-	qede_ptp_disable(edev);
-	ptp->clock = NULL;
 err1:
 	kfree(ptp);
+err2:
 	edev->ptp = NULL;
 
 	return rc;
-- 
2.20.1



