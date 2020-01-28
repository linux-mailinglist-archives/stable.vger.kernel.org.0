Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1A014BB89
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgA1OrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:47:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgA1OIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:08:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76EAB22522;
        Tue, 28 Jan 2020 14:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220491;
        bh=iUtRt/4A0EKtUxFN7POXi60okHJXln+goaL3CNV6aQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZavAVhOX8aoBNNB3P6BlAgcK9NcLCP/xn+uU0h5K0dsOIh8q19Ry+7yMzaEOWsgx
         hp7c7G1rNAfsgY/e/eTSuzP8IfAWwjHeALOcfx8j3gGYCWn/JZ6LIKEOGLbdtK6VhT
         qU86Afgo/hcrxN5wdVj5VeYaRhNe5p+jKguY6Aec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 028/183] clk: vf610: fix refcount leak in vf610_clocks_init()
Date:   Tue, 28 Jan 2020 15:04:07 +0100
Message-Id: <20200128135832.847402064@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 567177024e0313e4f0dcba7ba10c0732e50e655d ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: 1f2c5fd5f048 ("ARM: imx: add VF610 clock support")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-vf610.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-vf610.c b/drivers/clk/imx/clk-vf610.c
index 0a94d9661d912..2c92a2706fdd0 100644
--- a/drivers/clk/imx/clk-vf610.c
+++ b/drivers/clk/imx/clk-vf610.c
@@ -155,6 +155,7 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	np = of_find_compatible_node(NULL, NULL, "fsl,vf610-anatop");
 	anatop_base = of_iomap(np, 0);
 	BUG_ON(!anatop_base);
+	of_node_put(np);
 
 	np = ccm_node;
 	ccm_base = of_iomap(np, 0);
-- 
2.20.1



