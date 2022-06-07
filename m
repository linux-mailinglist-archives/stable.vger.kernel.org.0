Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AC1540702
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347427AbiFGRll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348216AbiFGRkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:40:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711E36D3AE;
        Tue,  7 Jun 2022 10:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6359EB822B4;
        Tue,  7 Jun 2022 17:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6592C34115;
        Tue,  7 Jun 2022 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623214;
        bh=fvqtBcjkHl2wfnU3dwlKLPAsMA4RiLi7gEH+8xIRx/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXLIIL7FW/XG3zMTifq0FIV+KeNzforC6W9XuqOsY/c8wukJcMQ8Hp6aNmCPWnqlC
         KNEUD6SEc+PJfzT8C/fsbOC/ku8lIUuJnXEtZQG0grOPsWnEW4cs+tKLlLKVsBurD4
         X2u3SIMFsf3fYWQFNGpqYz3Eip5b8VmM0ifXOwak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/452] pinctrl: renesas: core: Fix possible null-ptr-deref in sh_pfc_map_resources()
Date:   Tue,  7 Jun 2022 19:02:32 +0200
Message-Id: <20220607164917.345838911@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index 258972672eda..54f1a7334027 100644
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



