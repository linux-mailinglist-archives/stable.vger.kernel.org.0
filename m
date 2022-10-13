Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9ADB5FCF49
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJMAQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiJMAQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:16:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02BE150486;
        Wed, 12 Oct 2022 17:16:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B604616BF;
        Thu, 13 Oct 2022 00:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0683C4347C;
        Thu, 13 Oct 2022 00:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620179;
        bh=Es5nmzJdT+oW3VwkRSQOa1PJ6ac1UPOFRjBXyXVSk/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0rNXPfHQ3TU0ozOm7EpfsP0eQOEs7ApZmY1pqkRrcYBLmPVTOMNfQ76Hma9oCqy1
         /lm/M7tS1XVLsuPNu53wQInDFyOOWQ17dmA7pqh5URKyHgEpgctnAYfnciEdIDjZ5y
         EtKJsb/0c7B0xnvuHawXHixysV5EBp/7nWRCsUgjAgY9quPJ4VkgdsAiaUgEsoShAX
         UA9McVHOdqTfSIGB7gYbtsym5aOn8jzkXHdOk+6XdBSJ1wVhB4czjcgT6/G7/vMM6V
         hTdifyre+9qyb0wrbhQButygGlCGhEvdipEJz7M8O6Lusf8rxr5R16qnVn9CyRQ7I4
         RMTsHaJp/We+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Letu Ren <fantasquex@gmail.com>, Zheyu Ma <zheyuma97@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 11/67] scsi: 3w-9xxx: Avoid disabling device if failing to enable it
Date:   Wed, 12 Oct 2022 20:14:52 -0400
Message-Id: <20221013001554.1892206-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
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

From: Letu Ren <fantasquex@gmail.com>

[ Upstream commit 7eff437b5ee1309b34667844361c6bbb5c97df05 ]

The original code will "goto out_disable_device" and call
pci_disable_device() if pci_enable_device() fails. The kernel will generate
a warning message like "3w-9xxx 0000:00:05.0: disabling already-disabled
device".

We shouldn't disable a device that failed to be enabled. A simple return is
fine.

Link: https://lore.kernel.org/r/20220829110115.38789-1-fantasquex@gmail.com
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/3w-9xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index cd823ff5deab..6cb9cca9565b 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2006,7 +2006,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	retval = pci_enable_device(pdev);
 	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x34, "Failed to enable pci device");
-		goto out_disable_device;
+		return -ENODEV;
 	}
 
 	pci_set_master(pdev);
-- 
2.35.1

