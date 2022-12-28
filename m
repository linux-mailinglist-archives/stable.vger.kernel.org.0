Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C00657B0D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbiL1PRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiL1PRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:17:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601B313E39
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:17:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15BB8B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DC2C433D2;
        Wed, 28 Dec 2022 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240654;
        bh=1kVWNZqRXBjAGACUjOXCo0b9TnN7MjFDu0k54z+rqfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHZl0kA+KDLzIVmnInY/drtyWdjNy0W3r6oCYt4lNV1qNCUFaPfRBo2g/TpRhj8gt
         20zi4qB+k4iLx2I9oswPCd+zrsdYGj8h65WqL2+3ZPOul4h0YX1sUXCnwCEwTeDiCK
         +0cktUMvaR4iyOHGuApX614SPb0P2ZRHE845481E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0150/1146] EDAC/i10nm: fix refcount leak in pci_get_dev_wrapper()
Date:   Wed, 28 Dec 2022 15:28:09 +0100
Message-Id: <20221228144334.227022469@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9c8921555907f4d723f01ed2d859b66f2d14f08e ]

As the comment of pci_get_domain_bus_and_slot() says, it returns
a PCI device with refcount incremented, so it doesn't need to
call an extra pci_dev_get() in pci_get_dev_wrapper(), and the PCI
device needs to be put in the error path.

Fixes: d4dc89d069aa ("EDAC, i10nm: Add a driver for Intel 10nm server processors")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20221128065512.3572550-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index a22ea053f8e1..8af4d2523194 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -304,11 +304,10 @@ static struct pci_dev *pci_get_dev_wrapper(int dom, unsigned int bus,
 	if (unlikely(pci_enable_device(pdev) < 0)) {
 		edac_dbg(2, "Failed to enable device %02x:%02x.%x\n",
 			 bus, dev, fun);
+		pci_dev_put(pdev);
 		return NULL;
 	}
 
-	pci_dev_get(pdev);
-
 	return pdev;
 }
 
-- 
2.35.1



