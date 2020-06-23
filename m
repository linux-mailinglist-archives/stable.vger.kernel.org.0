Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445EA2064B2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389686AbgFWV0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389670AbgFWUS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF6B20EDD;
        Tue, 23 Jun 2020 20:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943508;
        bh=PE7Z++9CtFSGHnUPbe+vMfnKMjQfrC6E6jUfYSx6lXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mThyvJO5DQe27M5Hv+Oawg7tv+6j2Cj90BmhOOkmQSIRSQJ977nkSE8P3xzo+n8Jk
         /31JccYhJp4BrWrFg65KAi/XCv1CMthzrhMkQXrM+K1N7PMTMVw0SYwNjw+yVE4ZLE
         YM19GxXe68dujf1tKOST4R0WFUkgKioPuxrhcVKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 402/477] bnxt_en: Return from timer if interface is not in open state.
Date:   Tue, 23 Jun 2020 21:56:39 +0200
Message-Id: <20200623195426.532767501@linuxfoundation.org>
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
index a29bf3ca0b48e..19c4a0a5727a4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10014,7 +10014,7 @@ static void bnxt_timer(struct timer_list *t)
 	struct bnxt *bp = from_timer(bp, t, timer);
 	struct net_device *dev = bp->dev;
 
-	if (!netif_running(dev))
+	if (!netif_running(dev) || !test_bit(BNXT_STATE_OPEN, &bp->state))
 		return;
 
 	if (atomic_read(&bp->intr_sem) != 0)
-- 
2.25.1



