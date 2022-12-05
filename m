Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9131A643235
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiLETZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiLETYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:24:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414E62C124
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:19:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD4EB81181
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630E8C433C1;
        Mon,  5 Dec 2022 19:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267988;
        bh=3Z5VSz+IaXP3WVAY6Thqe7EqruPoNaXQOHKek17Oe7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTZiReDoNJ7DCKuPvdjjtlcKKD7yp5KrPmW7POjweU9w8ZaHfR5F/g2Ko1wzGEXk6
         pFe62im6E59MeXZGuXg/q0a2WydnRVkUNmdm7o/VLsmOQFW8u/J9EEKUOP1L0kVUg0
         e+zMMRZtZuO8t/+6+mAFfVyzYzKew5hi3NdbxKmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ruanjinjie <ruanjinjie@huawei.com>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/105] xen/platform-pci: add missing free_irq() in error path
Date:   Mon,  5 Dec 2022 20:09:18 +0100
Message-Id: <20221205190804.701634940@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



