Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1395066741B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjALOCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjALOCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:02:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1903224C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:02:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EB7DFCE1E6C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D505BC433EF;
        Thu, 12 Jan 2023 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532150;
        bh=QxUXvCtFKVHLov9PqhwUpCzD9soQcTPiHUGWOkFciIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW6ZpJxFPohA97gOkMXXWMh8fGtpfVYwngmxbSj05mjmXbM2SxmwftBLSM1fJt/V5
         GjwSlfiOQQM1jqyB413w/ThB/sM9MDitZI2X2V3sS7qRPAFt0F+jM8B29n8NobstdJ
         3B3Jh/cbnpetpaUEub6IlPLseMbJ/u8szcPlCxRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/783] EDAC/i10nm: fix refcount leak in pci_get_dev_wrapper()
Date:   Thu, 12 Jan 2023 14:46:23 +0100
Message-Id: <20230112135527.251978780@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 3a7362f968c9..43dbea6b6e30 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -53,11 +53,10 @@ static struct pci_dev *pci_get_dev_wrapper(int dom, unsigned int bus,
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



