Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F68540E1D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353112AbiFGSwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354621AbiFGSrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25C237A92;
        Tue,  7 Jun 2022 11:02:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70294B82343;
        Tue,  7 Jun 2022 18:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8244CC34115;
        Tue,  7 Jun 2022 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624955;
        bh=c+ctPUQM9DoagDrIqdEoBv221V9tAwf8N+RV88BNbt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d95VIjwXL6pEs2r3Oz0kttrf9uQpRPzPLCaw1UihxaXSEnNRWl7zaLwzKLvN4U9ZL
         hFSj6TYRnoCQkNx2uBdltIc8HIaLh4Ps0pqbofEc2eIiasIoO2QKa1SHLpJAELFCGk
         pqGydTT75uRo/AXsSboC6ldN/UfYGmzS9zC1wD6+6H/lrqqpROfl/UNFWGeHD+rFgK
         ZFn7Rwr3roUafU41r3vyWgic7Kib8bP2ZrTZAmiUnBbsZcZiimpHxwmTH5R/MBxxJz
         b1b9K280RZHlswbXy0iB0Le7G4Y/IIZTUkOZj3Fr5rzmDD1vOPBxp0ihCCXrqRLIye
         FG4cftyi7ZfeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huang Guobin <huangguobin4@huawei.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/25] tty: Fix a possible resource leak in icom_probe
Date:   Tue,  7 Jun 2022 14:02:05 -0400
Message-Id: <20220607180229.482040-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180229.482040-1-sashal@kernel.org>
References: <20220607180229.482040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Guobin <huangguobin4@huawei.com>

[ Upstream commit ee157a79e7c82b01ae4c25de0ac75899801f322c ]

When pci_read_config_dword failed, call pci_release_regions() and
pci_disable_device() to recycle the resource previously allocated.

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
Link: https://lore.kernel.org/r/20220331091005.3290753-1-huangguobin4@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/icom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index fe92d74f4ea5..4711b3ec2c56 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -1515,7 +1515,7 @@ static int icom_probe(struct pci_dev *dev,
 	retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg);
 	if (retval) {
 		dev_err(&dev->dev, "PCI Config read FAILED\n");
-		return retval;
+		goto probe_exit0;
 	}
 
 	pci_write_config_dword(dev, PCI_COMMAND,
-- 
2.35.1

