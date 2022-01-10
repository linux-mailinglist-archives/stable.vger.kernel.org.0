Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB64248915D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240576AbiAJHb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37136 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239358AbiAJH3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13C73611BF;
        Mon, 10 Jan 2022 07:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED01DC36AED;
        Mon, 10 Jan 2022 07:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799760;
        bh=GzX5Qx6BbH+zpfgKGRJuQDIGxJwTCJ11gUzBsPtfKNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7+CPpbniCuMiBsa5L/+TDzzOrvyvJxTmkL1dQVOiQ064UCCB2WFKUa8SzgB9+dXX
         FM7Za+7MHAGq4z7EJne/R/YDyRJUxozcdED3KrILLvqlTXFETrMWmhlfmrMai9C6Ha
         Z5BU2xMvHWoRGUEjTLvky6hTQMos1FB/JzhNNY2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Melki <christian.melki@t2data.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Wadim Egorov <w.egorov@phytec.de>
Subject: [PATCH 5.4 21/34] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081
Date:   Mon, 10 Jan 2022 08:23:16 +0100
Message-Id: <20220110071816.360206462@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Melki <christian.melki@t2data.com>

commit 764d31cacfe48440745c4bbb55a62ac9471c9f19 upstream.

Following a similar reinstate for the KSZ9031.

Older kernels would use the genphy_soft_reset if the PHY did not implement
a .soft_reset.

Bluntly removing that default may expose a lot of situations where various
PHYs/board implementations won't recover on various changes.
Like with this implementation during a 4.9.x to 5.4.x LTS transition.
I think it's a good thing to remove unwanted soft resets but wonder if it
did open a can of worms?

Atleast this fixes one iMX6 FEC/RMII/8081 combo.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Christian Melki <christian.melki@t2data.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210224205536.9349-1-christian.melki@t2data.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wadim Egorov <w.egorov@phytec.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1096,6 +1096,7 @@ static struct phy_driver ksphy_driver[]
 	.probe		= kszphy_probe,
 	.config_init	= ksz8081_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
+	.soft_reset	= genphy_soft_reset,
 	.config_intr	= kszphy_config_intr,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,


