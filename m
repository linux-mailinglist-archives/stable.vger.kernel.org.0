Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8B156FC24
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiGKJju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbiGKJjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:39:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966C750722;
        Mon, 11 Jul 2022 02:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2DB6612A0;
        Mon, 11 Jul 2022 09:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8DFC341C8;
        Mon, 11 Jul 2022 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531214;
        bh=cAOsUqWfWLaLFBrgDJaoiwrjMPN8OuWXzHQEt0P8A1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNfgI095fPOpOYMKJtqmP6VdhB2AhdLpVlyu2solQpPianVqoJb87s/J3adwVgk/0
         yaOBcTbdCqVamn6KDfxk966OhbSMXbwwNrJClufj63SQrVDFKyOplpA+Xl/ifvcyav
         DFL2kUkg7d/D+w5qcbqgP05TsenvSHPsxcR4i/64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Bin <tangbin@cmss.chinamobile.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/230] Input: cpcap-pwrbutton - handle errors from platform_get_irq()
Date:   Mon, 11 Jul 2022 11:04:40 +0200
Message-Id: <20220711090604.761923622@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit 58ae4004b9c4bb040958cf73986b687a5ea4d85d ]

The function cpcap_power_button_probe() does not perform
sufficient error checking after executing platform_get_irq(),
thus fix it.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20210802121740.8700-1-tangbin@cmss.chinamobile.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/cpcap-pwrbutton.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/input/misc/cpcap-pwrbutton.c b/drivers/input/misc/cpcap-pwrbutton.c
index 0abef63217e2..372cb44d0635 100644
--- a/drivers/input/misc/cpcap-pwrbutton.c
+++ b/drivers/input/misc/cpcap-pwrbutton.c
@@ -54,9 +54,13 @@ static irqreturn_t powerbutton_irq(int irq, void *_button)
 static int cpcap_power_button_probe(struct platform_device *pdev)
 {
 	struct cpcap_power_button *button;
-	int irq = platform_get_irq(pdev, 0);
+	int irq;
 	int err;
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
 	button = devm_kmalloc(&pdev->dev, sizeof(*button), GFP_KERNEL);
 	if (!button)
 		return -ENOMEM;
-- 
2.35.1



