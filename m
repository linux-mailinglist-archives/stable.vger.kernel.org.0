Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35AB111C4F
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbfLCWmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:42:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbfLCWmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 812C020803;
        Tue,  3 Dec 2019 22:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412955;
        bh=Sh1A6WczwZM9OYsqHw8JzdjYAOOxO4WI8CWupzY34jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6IX0gFMfaPYosoSSd+VSLT96dpCM6RX/crfvAlaGzSgZEs9ZZ4OkhWyCxPsnr3rj
         iZsbWXvMRDX4yUzoxeGRyjBZFftOTkJP5hYXXX+f21S6E/ByzcYLYruSAhAdzF01Gf
         QdFSY1Yodc1cIKA4NooGowqplLDGUVkccov5rOAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 043/135] clk: ti: dra7-atl-clock: Remove ti_clk_add_alias call
Date:   Tue,  3 Dec 2019 23:34:43 +0100
Message-Id: <20191203213015.983469970@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 9982b0f69b49931b652d35f86f519be2ccfc7027 ]

ti_clk_register() calls it already so the driver should not create
duplicated alias.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lkml.kernel.org/r/20191002083436.10194-1-peter.ujfalusi@ti.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-dra7-atl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index a01ca9395179a..f65e16c4f3c4b 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -174,7 +174,6 @@ static void __init of_dra7_atl_clock_setup(struct device_node *node)
 	struct clk_init_data init = { NULL };
 	const char **parent_names = NULL;
 	struct clk *clk;
-	int ret;
 
 	clk_hw = kzalloc(sizeof(*clk_hw), GFP_KERNEL);
 	if (!clk_hw) {
@@ -207,11 +206,6 @@ static void __init of_dra7_atl_clock_setup(struct device_node *node)
 	clk = ti_clk_register(NULL, &clk_hw->hw, node->name);
 
 	if (!IS_ERR(clk)) {
-		ret = ti_clk_add_alias(NULL, clk, node->name);
-		if (ret) {
-			clk_unregister(clk);
-			goto cleanup;
-		}
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 		kfree(parent_names);
 		return;
-- 
2.20.1



