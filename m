Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863FF635E96
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbiKWMxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237719AbiKWMve (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:51:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCA884807;
        Wed, 23 Nov 2022 04:44:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E915B81F6F;
        Wed, 23 Nov 2022 12:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47039C43144;
        Wed, 23 Nov 2022 12:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207449;
        bh=mb+pGKqyYHoKta2t0TvbE4ss9Y74jYvBeT3Shr+CzvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UikIHeENFjbRVUzZotK7gQxna3KCvWNSZ/5lcZy2lkqR9awgK1eAcmrX8dhMR76ME
         QuT7QJI5DfARu4JkRId7ucqlkA2+pjxHbclDjBg8NXccPLmBHQ0ckzFHhbcZPXedQv
         gNyGFgvX+XKK4lQOt2ROLsofSTUDoZ28V93a+wvVB6WCcn1l+unkr+p3oOGlLYMhLH
         4hIMO2D6650Cu9vGzEIaony+t7ZNOsp4IFxlPuiHCm6bU/3jpDfjMVM95U8Y23RH3m
         +o7dutyaAsI3LJS5KDVq61iVoRi0bsZfqsa9Ag05TdgbW6y4exo24s8htEB7ebZFSg
         Gnei+cFAq9Pgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ruanjinjie <ruanjinjie@huawei.com>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, sstabellini@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.10 10/22] xen/platform-pci: add missing free_irq() in error path
Date:   Wed, 23 Nov 2022 07:43:25 -0500
Message-Id: <20221123124339.265912-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124339.265912-1-sashal@kernel.org>
References: <20221123124339.265912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit c53717e1e3f0d0f9129b2e0dbc6dcc5e0a8132e9 ]

free_irq() is missing in case of error in platform_pci_probe(), fix that.

Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Link: https://lore.kernel.org/r/20221114112124.1965611-1-ruanjinjie@huawei.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/platform-pci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 9db557b76511..804d8f4d0e73 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -137,7 +137,7 @@ static int platform_pci_probe(struct pci_dev *pdev,
 		if (ret) {
 			dev_warn(&pdev->dev, "Unable to set the evtchn callback "
 					 "err=%d\n", ret);
-			goto out;
+			goto irq_out;
 		}
 	}
 
@@ -145,13 +145,16 @@ static int platform_pci_probe(struct pci_dev *pdev,
 	grant_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
 	ret = gnttab_setup_auto_xlat_frames(grant_frames);
 	if (ret)
-		goto out;
+		goto irq_out;
 	ret = gnttab_init();
 	if (ret)
 		goto grant_out;
 	return 0;
 grant_out:
 	gnttab_free_auto_xlat_frames();
+irq_out:
+	if (!xen_have_vector_callback)
+		free_irq(pdev->irq, pdev);
 out:
 	pci_release_region(pdev, 0);
 mem_out:
-- 
2.35.1

