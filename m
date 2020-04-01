Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3297A19B41C
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733196AbgDAQXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387610AbgDAQXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:23:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD5F8214D8;
        Wed,  1 Apr 2020 16:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758222;
        bh=TdhP/Dzp2gLcqB1NRSt/PoKp0sOkeBGm0AhS9pXBhW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxKW5iyh9/ZuY8fjOiCJmO7/BIVcJJwsMby2KwtulqlqJDMKS8mMheSveiA1pEmA7
         9UM6+l5EbI1jN5BXcBPTiXeC0nPQO2hwwbCMX7qk07fWvUmeoEAcjESBJ/QOwcJXQO
         RkxDiZc5cienXiXn2i7zIvVtwVR3YDbG2YCEoCuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 022/116] bnxt_en: Reset rings if ring reservation fails during open()
Date:   Wed,  1 Apr 2020 18:16:38 +0200
Message-Id: <20200401161545.212736529@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 5d765a5e4bd7c368e564e11402bba74cf7f03ac1 ]

If ring counts are not reset when ring reservation fails,
bnxt_init_dflt_ring_mode() will not be called again to reinitialise
IRQs when open() is called and results in system crash as napi will
also be not initialised. This patch fixes it by resetting the ring
counts.

Fixes: 47558acd56a7 ("bnxt_en: Reserve rings at driver open if none was reserved at probe time.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8822,6 +8822,10 @@ static int bnxt_set_dflt_rings(struct bn
 		bp->rx_nr_rings++;
 		bp->cp_nr_rings++;
 	}
+	if (rc) {
+		bp->tx_nr_rings = 0;
+		bp->rx_nr_rings = 0;
+	}
 	return rc;
 }
 


