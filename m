Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6902249A2DB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383930AbiAXXyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845906AbiAXXNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:13:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A9AC067A70;
        Mon, 24 Jan 2022 13:19:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEDFAB81142;
        Mon, 24 Jan 2022 21:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B916C340E4;
        Mon, 24 Jan 2022 21:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059193;
        bh=TTIVadTQ/H/nHFNTW22sbDeI8axrVJXpDhzc9tFLTPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWXcqcYHNnV3vp/IdyFTWTIB3fNzFqbPkNtxbv1LHqdqdmt6jSazksCByOIWyLR47
         gkvMfC4tZzmFiZQrnJLxGW2gtnrKXGlHF76z9vFbeklheTbF0tx7tpFwTTfuGl9Pey
         8kGx56C+E/OFG2KqmQBqhVj40cZ5aXcFekgR+mQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Peng Fan <peng.fan@nxp.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0534/1039] mailbox: imx: Fix an IS_ERR() vs NULL bug
Date:   Mon, 24 Jan 2022 19:38:43 +0100
Message-Id: <20220124184143.232436141@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 05d06f37196b2e3abeff2b98b785c8803865e646 ]

The devm_kzalloc() function does not return error pointers, it returns
NULL on failure.

Fixes: 97961f78e8bc ("mailbox: imx: support i.MX8ULP S4 MU")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index ffe36a6bef9e0..544de2db64531 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -563,8 +563,8 @@ static int imx_mu_probe(struct platform_device *pdev)
 		size = sizeof(struct imx_sc_rpc_msg_max);
 
 	priv->msg = devm_kzalloc(dev, size, GFP_KERNEL);
-	if (IS_ERR(priv->msg))
-		return PTR_ERR(priv->msg);
+	if (!priv->msg)
+		return -ENOMEM;
 
 	priv->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(priv->clk)) {
-- 
2.34.1



