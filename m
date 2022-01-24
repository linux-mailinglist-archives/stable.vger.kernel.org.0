Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B0D499AA3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573635AbiAXVp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456551AbiAXVjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94069C0417CA;
        Mon, 24 Jan 2022 12:25:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F2B0B810BD;
        Mon, 24 Jan 2022 20:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7908BC340E5;
        Mon, 24 Jan 2022 20:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055901;
        bh=38QJKayBH1t+mBmsiqgcjzBj6O8WHMCZs2mmLV6jwwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/2h1AcQtXpIyc8T1IC/WPoYeqNkIk7/tb6bR+8Vjp8fxJa9/PYzB/LKR/K9X80gL
         HAA4tcQbweXs4vxPqhrXkegCURwCT/+PUIv0crMzNZXrYDLyO3BFBo1vi8/OWdLSDj
         s9B6/zaKHrEQs+0kdL8zyMP2TaYOHpTIFSPP1TWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 304/846] power: reset: mt6397: Check for null res pointer
Date:   Mon, 24 Jan 2022 19:37:01 +0100
Message-Id: <20220124184111.391081587@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 1c1348bf056dee665760a3bd1cd30b0be7554fc2 ]

The return value of platform_get_resource() needs to be checked.
To avoid use of error pointer in case that there is no suitable
resource.

Fixes: d28c74c10751 ("power: reset: add driver for mt6323 poweroff")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/mt6323-poweroff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/reset/mt6323-poweroff.c b/drivers/power/reset/mt6323-poweroff.c
index 0532803e6cbc4..d90e76fcb9383 100644
--- a/drivers/power/reset/mt6323-poweroff.c
+++ b/drivers/power/reset/mt6323-poweroff.c
@@ -57,6 +57,9 @@ static int mt6323_pwrc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
+
 	pwrc->base = res->start;
 	pwrc->regmap = mt6397_chip->regmap;
 	pwrc->dev = &pdev->dev;
-- 
2.34.1



