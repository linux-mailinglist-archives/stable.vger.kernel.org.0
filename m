Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71D073C73
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405279AbfGXUAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405276AbfGXUAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:00:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 167F1205C9;
        Wed, 24 Jul 2019 20:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998446;
        bh=K8tCOehphzHY0IO/sbGLCbhffAbFe0XqUIVhEKI7KQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLV+/0hCtsFqKYvKJV4PVGkL1pGoJzIpe7WUbvgwJGkPTaghY6mknGKQBrPlZ/2iR
         n3qdFHQT+qs9phh9SD7N6f4ccsE/Mnmug48jSxwy3x/2vLdxQzkufciTAf3FxJUslr
         Ip9JJsQurTEE/zmb/9EYv4FDYi386ydnEXSUf1LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Josua Mayer <josua@solid-run.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 368/371] net: mvmdio: allow up to four clocks to be specified for orion-mdio
Date:   Wed, 24 Jul 2019 21:22:00 +0200
Message-Id: <20190724191752.010682758@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

commit 4aabed699c400810981d3dda170f05fa4d782905 upstream.

Allow up to four clocks to be specified and enabled for the orion-mdio
interface, which are required by the Armada 8k and defined in
armada-cp110.dtsi.

Fixes a hang in probing the mvmdio driver that was encountered on the
Clearfog GT 8K with all drivers built as modules, but also affects other
boards such as the MacchiatoBIN.

Cc: stable@vger.kernel.org
Fixes: 96cb43423822 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/mvmdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -64,7 +64,7 @@
 
 struct orion_mdio_dev {
 	void __iomem *regs;
-	struct clk *clk[3];
+	struct clk *clk[4];
 	/*
 	 * If we have access to the error interrupt pin (which is
 	 * somewhat misnamed as it not only reflects internal errors


