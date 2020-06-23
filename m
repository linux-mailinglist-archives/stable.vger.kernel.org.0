Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62582063C4
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389913AbgFWVLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390942AbgFWUci (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:32:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC0692064B;
        Tue, 23 Jun 2020 20:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944358;
        bh=tR2mCtOJIk3gJlYWdrIJKcfS816pyQ4QKSEg4t94mKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gChuzPRa7/+mttExnDnlyLbOJUCNY+u0TiKc0EuvFlhNF9paODJgnGs8KsJlwlHrr
         IaykzVs0tlFg/76bt8Fgz8EEw7Uz4M3TQMy53b8QXW5UFouz5nhgZOUcerrYIrR7jy
         v3z0+X9XS3dD8VeR/enQa/Sy2wDEC30C7gHd5rsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 274/314] bnxt_en: Return from timer if interface is not in open state.
Date:   Tue, 23 Jun 2020 21:57:49 +0200
Message-Id: <20200623195352.055262490@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit e000940473d1423a42ef9c823fb23ccffe3f07ea ]

This will avoid many uneccessary error logs when driver or firmware is
in reset.

Fixes: 230d1f0de754 ("bnxt_en: Handle firmware reset.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 63ee0c49be7cf..b5147bd6cba6d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9992,7 +9992,7 @@ static void bnxt_timer(struct timer_list *t)
 	struct bnxt *bp = from_timer(bp, t, timer);
 	struct net_device *dev = bp->dev;
 
-	if (!netif_running(dev))
+	if (!netif_running(dev) || !test_bit(BNXT_STATE_OPEN, &bp->state))
 		return;
 
 	if (atomic_read(&bp->intr_sem) != 0)
-- 
2.25.1



