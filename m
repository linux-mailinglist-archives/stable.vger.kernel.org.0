Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4D65415E7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359679AbiFGUnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377140AbiFGUcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:32:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C151E2266;
        Tue,  7 Jun 2022 11:34:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6566D60B3D;
        Tue,  7 Jun 2022 18:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1EBC341C0;
        Tue,  7 Jun 2022 18:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626865;
        bh=db/ofgzZ/cuknA0GEviSYIS58W5Vqc32utfR3CdfX4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fno9ox4xhkl+YnbhEfKJYYzuWe3wvQI9qLyVdXuzqvAj9qNVSWKW3zx6rC/Qr6Y4N
         JxylZRiCdI5qT4P7klpW6ymzeM9EU91EKlnkMUSaELG/KyVg3I1O88PjvLMXXT/4WD
         Q2jY3EkjXy3v4iUURzxNsD6aG6A6fPp/D6F5sk5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 515/772] pinctrl: renesas: core: Fix possible null-ptr-deref in sh_pfc_map_resources()
Date:   Tue,  7 Jun 2022 19:01:47 +0200
Message-Id: <20220607165004.157092743@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5376e3d904532e657fd7ca1a9b1ff3d351527b90 ]

It will cause null-ptr-deref when using 'res', if platform_get_resource()
returns NULL, so move using 'res' after devm_ioremap_resource() that
will check it to avoid null-ptr-deref.
And use devm_platform_get_and_ioremap_resource() to simplify code.

Fixes: c7977ec4a336 ("pinctrl: sh-pfc: Convert to platform_get_*()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220429082637.1308182-1-yangyingliang@huawei.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/renesas/core.c b/drivers/pinctrl/renesas/core.c
index 12d41ac017b5..8ed95be90490 100644
--- a/drivers/pinctrl/renesas/core.c
+++ b/drivers/pinctrl/renesas/core.c
@@ -71,12 +71,11 @@ static int sh_pfc_map_resources(struct sh_pfc *pfc,
 
 	/* Fill them. */
 	for (i = 0; i < num_windows; i++) {
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		windows->phys = res->start;
-		windows->size = resource_size(res);
-		windows->virt = devm_ioremap_resource(pfc->dev, res);
+		windows->virt = devm_platform_get_and_ioremap_resource(pdev, i, &res);
 		if (IS_ERR(windows->virt))
 			return -ENOMEM;
+		windows->phys = res->start;
+		windows->size = resource_size(res);
 		windows++;
 	}
 	for (i = 0; i < num_irqs; i++)
-- 
2.35.1



