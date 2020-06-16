Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D703C1FB9F3
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732215AbgFPPqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732209AbgFPPqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:46:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2AA32071A;
        Tue, 16 Jun 2020 15:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322389;
        bh=DstgrDs8R08mFlxBplzEZyCjzwwUFtv/2y1NO8+vwjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7OVD1UPJt+Hk86dBM3VQqJgQFt2RcP7MWzv18Yqy8unwZqY+8i9j3adghGnh8Vbw
         3x0T1gnrpG47DjK2hb7ihIS9bOxtYWblcTvY7alqUK8UaswQ2Bo0fDkcSWCG5zXOBw
         tA9MNwcXsX+rBD2EpXepAzSQnkyCwajBwqTeufpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 112/163] net: ethernet: ti: am65-cpsw-nuss: fix ale parameters init
Date:   Tue, 16 Jun 2020 17:34:46 +0200
Message-Id: <20200616153112.170524664@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 2074f9eaa58795a99e9da61c10f93180f810cfd6 ]

The ALE parameters structure is created on stack, so it has to be reset
before passing to cpsw_ale_create() to avoid garbage values.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1804,7 +1804,7 @@ MODULE_DEVICE_TABLE(of, am65_cpsw_nuss_o
 
 static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 {
-	struct cpsw_ale_params ale_params;
+	struct cpsw_ale_params ale_params = { 0 };
 	const struct of_device_id *of_id;
 	struct device *dev = &pdev->dev;
 	struct am65_cpsw_common *common;


