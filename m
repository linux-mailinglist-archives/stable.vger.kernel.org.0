Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A212064A0
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390230AbgFWVYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389509AbgFWUTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A8C82073E;
        Tue, 23 Jun 2020 20:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943562;
        bh=wscTOT490+jB0TIEzdIE6A8u5wLGa1vOApJtSWpdMdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kty6+o1009vFM1Gm8h57i/MP8RwDQ2V0BoGlGTPGpWwoHs/tw7s92YXqf9z+heaIJ
         UR5Sv6tbzBHkMKm2HnC3YjbBhw+N4IbJzTlU+LmuyjKyPTgzSpnJRw3OEUnVnE9CrJ
         bzs9rPjVQcXr7dLkww6jBaNMaui2L/Py1jZM/wNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 400/477] bnxt_en: Re-enable SRIOV during resume.
Date:   Tue, 23 Jun 2020 21:56:37 +0200
Message-Id: <20200623195426.437655764@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 59ae210173ff86256fa0cdba4ea4d608c61e123d ]

If VFs are enabled, we need to re-configure them during resume because
firmware has been reset while resuming.  Otherwise, the VFs won't
work after resume.

Fixes: c16d4ee0e397 ("bnxt_en: Refactor logic to re-enable SRIOV after firmware reset detected.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fbfb3e092e0dc..f8b26265cb86d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12115,6 +12115,8 @@ static int bnxt_resume(struct device *device)
 
 resume_exit:
 	bnxt_ulp_start(bp, rc);
+	if (!rc)
+		bnxt_reenable_sriov(bp);
 	rtnl_unlock();
 	return rc;
 }
-- 
2.25.1



