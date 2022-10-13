Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A585FD157
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiJMAgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiJMAdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:33:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FCBDBE69;
        Wed, 12 Oct 2022 17:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3F6AB81CE8;
        Thu, 13 Oct 2022 00:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C71C43150;
        Thu, 13 Oct 2022 00:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620840;
        bh=mzSEyvgQIhPHYGO2yz/6LzccyeE1JxvsydJsOQeo0QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMbxjOOSV1C1MINqAE+vYLCjrureUvba3rNF1oLBhxHdGtVzwkaIdlQNWS2FR2ROZ
         hOIbtAcicg+LK+ItzL+RDO4MZtnsQTFCH+M4wvFMv7MMkpVkbdMJq+JXITozUtpLs0
         ojtLmVr82Dqi4z+4nGQJq0xkL/gThPzz58EWNTekkukVsHUvWEPTAaLJh72kJnMVH6
         jchYBv40tSVjdP4yYKSTsKL5GxjgMjYaPAbJuckTfAbfXHWrnf7STXhqAqL1nJtEBl
         ox59dkLiSId214+/c8QWJ8uhBQo98z+K1L8J5f9taTqdC6DbaJYP3R2jSA/6C5WA69
         JulRdErgut48w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Letu Ren <fantasquex@gmail.com>, Zheyu Ma <zheyuma97@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/13] scsi: 3w-9xxx: Avoid disabling device if failing to enable it
Date:   Wed, 12 Oct 2022 20:27:01 -0400
Message-Id: <20221013002716.1895839-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002716.1895839-1-sashal@kernel.org>
References: <20221013002716.1895839-1-sashal@kernel.org>
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
index dd342207095a..0baeed1793aa 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2013,7 +2013,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	retval = pci_enable_device(pdev);
 	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x34, "Failed to enable pci device");
-		goto out_disable_device;
+		return -ENODEV;
 	}
 
 	pci_set_master(pdev);
-- 
2.35.1

