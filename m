Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E35C431EA8
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhJROFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234080AbhJROBz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:01:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B27B61A7B;
        Mon, 18 Oct 2021 13:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564573;
        bh=i06lt851+5FQNSM7U8SMu6Id/S2CxvzZdt3EVNDiM24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yS+q8MGKpTv1jhvanrpUfXRldRHd/7trf1ocU4cSxr6FQH5x5P9fnGerp0gvybMfP
         vUF7LFpiNUlS14mpUnzJB7QJsNZ13gQ+t7ItvHMcFmrtZDeIx7UUDc1t5VA8PPyZ+O
         2x35eFJV1dvAa3EM6Y89PoQWDPRSivorcgT+qaKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 108/151] net: phy: Do not shutdown PHYs in READY state
Date:   Mon, 18 Oct 2021 15:24:47 +0200
Message-Id: <20211018132344.185479077@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit f49823939e41121fdffada4d583e3e38d28336f9 upstream.

In case a PHY device was probed thus in the PHY_READY state, but not
configured and with no network device attached yet, we should not be
trying to shut it down because it has been brought back into reset by
phy_device_reset() towards the end of phy_probe() and anyway we have not
configured the PHY yet.

Fixes: e2f016cf7751 ("net: phy: add a shutdown procedure")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3112,6 +3112,9 @@ static void phy_shutdown(struct device *
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
+	if (phydev->state == PHY_READY || !phydev->attached_dev)
+		return;
+
 	phy_disable_interrupts(phydev);
 }
 


