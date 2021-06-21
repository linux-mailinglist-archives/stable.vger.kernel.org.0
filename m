Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108453AF0E2
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhFUQxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232743AbhFUQvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:51:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD3D8613BD;
        Mon, 21 Jun 2021 16:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293331;
        bh=pOK3xHA662ryxHR+7+aKJHhwoXev2TjUyDD95qmXTL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgJg7yktQ81DCBpfRe8KkdAUL0SAaMCN+WLaZk9NN/SCWUWddCnpgVuThiv1tdGze
         TqDDQbPotmEDbVzNVFcgiRO2ywJWGEZa+Ie8Y4JNxXMShGJfcoFvSbUpeGP3OwHE2X
         8SmqOzPiMXXk5yJvSaPR6fs4jl0I+vS60BtKk6xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 174/178] net: fec_ptp: add clock rate zero check
Date:   Mon, 21 Jun 2021 18:16:28 +0200
Message-Id: <20210621154928.669059905@linuxfoundation.org>
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

From: Fugang Duan <fugang.duan@nxp.com>

commit cb3cefe3f3f8af27c6076ef7d1f00350f502055d upstream.

Add clock rate zero check to fix coverity issue of "divide by 0".

Fixes: commit 85bd1798b24a ("net: fec: fix spin_lock dead lock")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -602,6 +602,10 @@ void fec_ptp_init(struct platform_device
 	fep->ptp_caps.enable = fec_ptp_enable;
 
 	fep->cycle_speed = clk_get_rate(fep->clk_ptp);
+	if (!fep->cycle_speed) {
+		fep->cycle_speed = NSEC_PER_SEC;
+		dev_err(&fep->pdev->dev, "clk_ptp clock rate is zero\n");
+	}
 	fep->ptp_inc = NSEC_PER_SEC / fep->cycle_speed;
 
 	spin_lock_init(&fep->tmreg_lock);


