Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E74C14BB7B
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgA1OIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:08:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbgA1OIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:08:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFB2424685;
        Tue, 28 Jan 2020 14:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220484;
        bh=1UFqR+rIqcMxH1JYOSDc6Lj1SyySYQkQAdQ/JB75h8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJpN+SwCbfZuFTY+oYq014WfjGff6qpgq2jDleMna/CEOIZqIfO5Uqlxuwh/xDReS
         K6e9cZNCvpnFEZ/j8/u0D8y3VFABCtxUaftAT72mRQdeIkCR0pnU6ErRjgCm4maAqd
         rq/YzNPyDk7AwhVEBSA0IHRxWoe6JOo4epQ1yGrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 025/183] clk: imx6q: fix refcount leak in imx6q_clocks_init()
Date:   Tue, 28 Jan 2020 15:04:04 +0100
Message-Id: <20200128135832.521623824@linuxfoundation.org>
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

[ Upstream commit c9ec1d8fef31b5fc9e90e99f9bd685db5caa7c5e ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: 2acd1b6f889c ("ARM: i.MX6: implement clocks using common clock framework")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6q.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
index 46c05c9a93541..39ea50102d52f 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -155,6 +155,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-anatop");
 	base = of_iomap(np, 0);
 	WARN_ON(!base);
+	of_node_put(np);
 
 	/* Audio/video PLL post dividers do not work on i.MX6q revision 1.0 */
 	if (clk_on_imx6q() && imx_get_soc_revision() == IMX_CHIP_REVISION_1_0) {
-- 
2.20.1



