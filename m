Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAD860A4FF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbiJXMUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiJXMTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:19:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18527A536;
        Mon, 24 Oct 2022 04:57:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77B97B81190;
        Mon, 24 Oct 2022 11:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F06C433C1;
        Mon, 24 Oct 2022 11:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612431;
        bh=mzSEyvgQIhPHYGO2yz/6LzccyeE1JxvsydJsOQeo0QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iereAO71IypWMzpGyLie6BmkY59pbKlYDVY4mJ7zyO2SL/UnrnaFy0JMa2+kLMAw
         CR8ahxYb794BG25ufSmisz3SMT/rkAQphH0x/JQ/XLNlvwZUuauDrwD6+xEvk2Ynfp
         Oa2o7RSQFlQRD/f7uUqxI8Ue6LDpELhNQvNmy2R8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Letu Ren <fantasquex@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 195/210] scsi: 3w-9xxx: Avoid disabling device if failing to enable it
Date:   Mon, 24 Oct 2022 13:31:52 +0200
Message-Id: <20221024113003.291076821@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



