Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EB55FD1ED
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiJMA46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbiJMA41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:56:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A39AE27;
        Wed, 12 Oct 2022 17:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE412616A9;
        Thu, 13 Oct 2022 00:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0AFC43143;
        Thu, 13 Oct 2022 00:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620350;
        bh=Es5nmzJdT+oW3VwkRSQOa1PJ6ac1UPOFRjBXyXVSk/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTtC0YvV0OubXKCO2NdKQ14sXl57kJglIOTO9ttFwf7RqRElymzaM9wbwKlpp1zHO
         G6p+eVmJK3dqxsINtMh6WV0EJrTwaym5sGOY7ZEK8BI0YQ0FmAvReDmmPWN+a1lCIB
         Y1GzcziX7qdvuxvpqiUjobrw2QRRqwg6Yfkf/Zm4ixrq2OZEfraVa27X3OzoG/6Yy+
         B2lcbuTCMKi0eOWggKLdT1kCSGe/2zbljGZNEOflWNyb7/ob5vYkrSZfHA5RGuJzVN
         0027ksnLKFw19vDeQz7N4yR3meV6pCs9zQEwBOVxIb+eNTl7JPuiCB3j8tAjTh8OqY
         sV1moYOfdIs4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Letu Ren <fantasquex@gmail.com>, Zheyu Ma <zheyuma97@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 11/63] scsi: 3w-9xxx: Avoid disabling device if failing to enable it
Date:   Wed, 12 Oct 2022 20:17:45 -0400
Message-Id: <20221013001842.1893243-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
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

