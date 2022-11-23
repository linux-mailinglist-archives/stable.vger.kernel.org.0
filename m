Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B97C635E0E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbiKWM4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbiKWMzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:55:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C51C8FFB4;
        Wed, 23 Nov 2022 04:45:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC61D61C5E;
        Wed, 23 Nov 2022 12:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84134C4347C;
        Wed, 23 Nov 2022 12:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207507;
        bh=3Z5VSz+IaXP3WVAY6Thqe7EqruPoNaXQOHKek17Oe7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJnEFhUaa2fDFamkRLo7D9SoZMoSsCt8bhr6XENmv2mUjoTRzXvVCd9x+ysvXLW1O
         St0zu5yeQl7DYUzadV/QT+j7hXfSIjJMHOjOPIsLXEa8nqXmoXW3WLEFzS1jsXMoQ3
         7/QQB1Kdb6m6+QMaT2OZJ4fbM4y0tyq0Z2Mycfj9Gd0UmEABwbQns6bIpkWsLJ+aHm
         4QTPsIlOsrx2fRMZQyWN9DYulz3rYAskOeJ7r9EVB1uhyjiz9XFneKPDeWIvEyqasA
         ceoqze8NPQKkJ1UbeBO74O/DTOL6lfAB2BptHrt0mbs4UjfD6vbPvS+Q4Fh6eVvXxE
         ZlggVldtPs+Tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ruanjinjie <ruanjinjie@huawei.com>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, sstabellini@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 4.19 03/11] xen/platform-pci: add missing free_irq() in error path
Date:   Wed, 23 Nov 2022 07:44:48 -0500
Message-Id: <20221123124458.266492-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124458.266492-1-sashal@kernel.org>
References: <20221123124458.266492-1-sashal@kernel.org>
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
index 4cec8146609a..c7e190e5db30 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -150,7 +150,7 @@ static int platform_pci_probe(struct pci_dev *pdev,
 		if (ret) {
 			dev_warn(&pdev->dev, "Unable to set the evtchn callback "
 					 "err=%d\n", ret);
-			goto out;
+			goto irq_out;
 		}
 	}
 
@@ -158,13 +158,16 @@ static int platform_pci_probe(struct pci_dev *pdev,
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

