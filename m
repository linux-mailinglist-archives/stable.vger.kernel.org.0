Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21123AEFF9
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhFUQny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232280AbhFUQlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:41:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D44E61352;
        Mon, 21 Jun 2021 16:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293059;
        bh=UOV2rV+eZq7OoKwtQBu7udLjaoOc8W91F5IlMxF7FlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jf5WORZ+XzPPZHIWeVp7S0hb/ROQnJ4Gs0H+iJ4qta4+NYQKNninhEJDUocFWW4in
         KdoJLMO2JkotZWbPvZwY/4gB+XRw2qkLJwgF48+EUrCgH0bhfccBuv4/Sl1WD2gyfY
         mdOzlNUmSSzcf+nhJRFFewopdH+o/25xk1b93Snw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 083/178] bnxt_en: Rediscover PHY capabilities after firmware reset
Date:   Mon, 21 Jun 2021 18:14:57 +0200
Message-Id: <20210621154925.463862644@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 0afd6a4e8028cc487c240b6cfe04094e45a306e4 ]

There is a missing bnxt_probe_phy() call in bnxt_fw_init_one() to
rediscover the PHY capabilities after a firmware reset.  This can cause
some PHY related functionalities to fail after a firmware reset.  For
example, in multi-host, the ability for any host to configure the PHY
settings may be lost after a firmware reset.

Fixes: ec5d31e3c15d ("bnxt_en: Handle firmware reset status during IF_UP.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 027997c711ab..e9ac20c1c389 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11573,6 +11573,8 @@ static void bnxt_fw_init_one_p3(struct bnxt *bp)
 	bnxt_hwrm_coal_params_qcaps(bp);
 }
 
+static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt);
+
 static int bnxt_fw_init_one(struct bnxt *bp)
 {
 	int rc;
@@ -11587,6 +11589,9 @@ static int bnxt_fw_init_one(struct bnxt *bp)
 		netdev_err(bp->dev, "Firmware init phase 2 failed\n");
 		return rc;
 	}
+	rc = bnxt_probe_phy(bp, false);
+	if (rc)
+		return rc;
 	rc = bnxt_approve_mac(bp, bp->dev->dev_addr, false);
 	if (rc)
 		return rc;
-- 
2.30.2



