Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE98612EC62
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgABWR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727670AbgABWR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB53122314;
        Thu,  2 Jan 2020 22:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003476;
        bh=A3XE+puTXjA9ypSDzn1jexAtI7UUySgWIBLw+o3TCgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkyAdRHPRJ5yN6gcOyrMHpq37KKdRNJI3Uwf9gu4+vC1wV3+egJuFnCu4vgG+zIie
         VuOPa15sTrNESPogiFwSaiGnmrA+hhQhyA96Gj1Gas5nNywQoGYa4d2xk4U0XOWWJp
         vnwaMYXWj/CbfAwwhqSRAmQzAd9Ba0pp8KLL3pMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 150/191] net: phy: aquantia: add suspend / resume ops for AQR105
Date:   Thu,  2 Jan 2020 23:07:12 +0100
Message-Id: <20200102215845.564560391@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>

[ Upstream commit 1c93fb45761e79b3c00080e71523886cefaf351c ]

The suspend/resume code for AQR107 works on AQR105 too.
This patch fixes issues with the partner not seeing the link down
when the interface using AQR105 is brought down.

Fixes: bee8259dd31f ("net: phy: add driver for aquantia phy")
Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/aquantia_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -627,6 +627,8 @@ static struct phy_driver aqr_driver[] =
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
 	.read_status	= aqr_read_status,
+	.suspend	= aqr107_suspend,
+	.resume		= aqr107_resume,
 },
 {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR106),


