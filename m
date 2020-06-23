Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB34205DE6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389590AbgFWURq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389582AbgFWURk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:17:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 905772073E;
        Tue, 23 Jun 2020 20:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943460;
        bh=GsRTFshCHugL5/nlerjFhpHXaegZzLl2NBuFjjLUqwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJDJVIhQtS3xEWxGHdwGBQIbJt1Rf49dGecs5Rzjce9efQEamignA2kmw6IXe/EnF
         YxQW9lMXX9TXNHrVjeIrXHPV9gux2scrFF0RC94LGgDgN5FK/cKsqusZV8EGt4RvSr
         Z47B1vO0iWW340CpyfH76fAGLD2fl5XgSPvheRCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 399/477] bnxt_en: Simplify bnxt_resume().
Date:   Tue, 23 Jun 2020 21:56:36 +0200
Message-Id: <20200623195426.390369657@linuxfoundation.org>
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

[ Upstream commit 2084ccf6259cc95e0575f0fafc93595d0219a9f6 ]

The separate steps we do in bnxt_resume() can be done more simply by
calling bnxt_hwrm_func_qcaps().  This change will add an extra
__bnxt_hwrm_func_qcaps() call which is needed anyway on older
firmware.

Fixes: f9b69d7f6279 ("bnxt_en: Fix suspend/resume path on 57500 chips")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 58e0d9a781e9a..fbfb3e092e0dc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12097,19 +12097,9 @@ static int bnxt_resume(struct device *device)
 		goto resume_exit;
 	}
 
-	if (bnxt_hwrm_queue_qportcfg(bp)) {
-		rc = -ENODEV;
+	rc = bnxt_hwrm_func_qcaps(bp);
+	if (rc)
 		goto resume_exit;
-	}
-
-	if (bp->hwrm_spec_code >= 0x10803) {
-		if (bnxt_alloc_ctx_mem(bp)) {
-			rc = -ENODEV;
-			goto resume_exit;
-		}
-	}
-	if (BNXT_NEW_RM(bp))
-		bnxt_hwrm_func_resc_qcaps(bp, false);
 
 	if (bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, false)) {
 		rc = -ENODEV;
-- 
2.25.1



