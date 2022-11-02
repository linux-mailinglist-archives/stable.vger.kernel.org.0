Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE86615A91
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiKBDdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiKBDdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7287E303
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E78B617D4
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A768CC433C1;
        Wed,  2 Nov 2022 03:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360007;
        bh=Wxq6aeshaetIcr6LGel2hPsaDlNjyHbcr/Ujxulyb3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTvhr4c31P1fJv3cBj0A37C6LcGEJgXTCriP6kqLJ/DQ6pgIqAORsSZK2lQZI5utU
         ykLMr3x3qMCQ5NlewpGy6ElRu1876mdcyGOJK3ok7CSeaBBBZ2tcR5swbNnGL+JKJm
         jPPgjqr0p/KSCCcGT9fCOi5qoclwtLZ+fdJvkLsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 71/78] net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()
Date:   Wed,  2 Nov 2022 03:34:56 +0100
Message-Id: <20221102022055.021638449@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5da6d65590a0698199df44d095e54b0ed1708178 ]

pci_disable_device() need be called while module exiting, switch to use
pcim_enable(), pci_disable_device() will be called in pcim_release()
while unbinding device.

Fixes: 8ca86fd83eae ("net: Micrel KSZ8841/2 PCI Ethernet driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221024131338.2848959-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ksz884x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 623a05d78343..beec87ec15f5 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6936,7 +6936,7 @@ static int pcidev_init(struct pci_dev *pdev, const struct pci_device_id *id)
 	char banner[sizeof(version)];
 	struct ksz_switch *sw = NULL;
 
-	result = pci_enable_device(pdev);
+	result = pcim_enable_device(pdev);
 	if (result)
 		return result;
 
-- 
2.35.1



