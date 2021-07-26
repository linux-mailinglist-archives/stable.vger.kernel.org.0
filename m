Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2693D6085
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbhGZPWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237396AbhGZPWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6B4660EB2;
        Mon, 26 Jul 2021 16:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315394;
        bh=6If3F0eghDjTz18J2gn5939lQ3Tw+UTGUv95AWcWagk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mi5U3ZSI5DrLl6kmS+8Jl7YsdYB7+6cTTBd/nsJekTPxW9z4pws0N1Iy735N+sAu9
         bZ+N3FfpL+Hf/69olnX9VTXjU9mHckZl9tE6KuL+Q1K4AfF63wXqIIj7cXP2PA/bnA
         /A1d4kyadJCoTMdPHLA8xnHVcUgNjC1ETbC+3vH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/167] bnxt_en: Refresh RoCE capabilities in bnxt_ulp_probe()
Date:   Mon, 26 Jul 2021 17:38:33 +0200
Message-Id: <20210726153842.096527097@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 2c9f046bc377efd1f5e26e74817d5f96e9506c86 ]

The capabilities can change after firmware upgrade/downgrade, so we
should get the up-to-date RoCE capabilities everytime bnxt_ulp_probe()
is called.

Fixes: 2151fe0830fd ("bnxt_en: Handle RESET_NOTIFY async event from firmware.")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 64dbbb04b043..abf169001bf3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -479,15 +479,16 @@ struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
 		if (!edev)
 			return ERR_PTR(-ENOMEM);
 		edev->en_ops = &bnxt_en_ops_tbl;
-		if (bp->flags & BNXT_FLAG_ROCEV1_CAP)
-			edev->flags |= BNXT_EN_FLAG_ROCEV1_CAP;
-		if (bp->flags & BNXT_FLAG_ROCEV2_CAP)
-			edev->flags |= BNXT_EN_FLAG_ROCEV2_CAP;
 		edev->net = dev;
 		edev->pdev = bp->pdev;
 		edev->l2_db_size = bp->db_size;
 		edev->l2_db_size_nc = bp->db_size;
 		bp->edev = edev;
 	}
+	edev->flags &= ~BNXT_EN_FLAG_ROCE_CAP;
+	if (bp->flags & BNXT_FLAG_ROCEV1_CAP)
+		edev->flags |= BNXT_EN_FLAG_ROCEV1_CAP;
+	if (bp->flags & BNXT_FLAG_ROCEV2_CAP)
+		edev->flags |= BNXT_EN_FLAG_ROCEV2_CAP;
 	return bp->edev;
 }
-- 
2.30.2



