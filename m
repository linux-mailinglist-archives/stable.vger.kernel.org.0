Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9903D4FCB48
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345063AbiDLBEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348444AbiDLA7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:59:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206D2377E7;
        Mon, 11 Apr 2022 17:52:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DC5360B28;
        Tue, 12 Apr 2022 00:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2778C385A4;
        Tue, 12 Apr 2022 00:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724755;
        bh=nLTb8cVk54NYUvxJo3sCKn6CKhUaBxzuzBw9kiWXymM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRS5c5/DtrnxsnwUEoOLiRVJMdquHD/RyG35rbXHsk1ayRw2KcWmdB9ZIzyniutdx
         SXIaLaI/4qyymqP12asmll+tY/8/QASj824+EpSQhw/fgdKc5Qaw8S4UMfV5cGZ2PR
         kxG4WZiNbWg/Td4Z5o983unY7z86xWkkDSjldC6pH/iRteuvPwWaOWJR+MFjWKctwV
         0mmGwVmu3xIzEVsnw05yDBLhX5H1wplSw54j/0Bav/3Np7cwYpQ5ZbdcDFqMs2mRmo
         bQbfq0KefZpPPtfTutcjcQVG8HOBtn1av7wyrMjMovzaZwvNapjhF6lEmeTN590oki
         9Zn/z4wgwdUtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/11] ata: libata-core: Disable READ LOG DMA EXT for Samsung 840 EVOs
Date:   Mon, 11 Apr 2022 20:52:16 -0400
Message-Id: <20220412005222.351554-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005222.351554-1-sashal@kernel.org>
References: <20220412005222.351554-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit 5399752299396a3c9df6617f4b3c907d7aa4ded8 ]

Samsung' 840 EVO with the latest firmware (EXT0DB6Q) locks up with
the a message: "READ LOG DMA EXT failed, trying PIO" during boot.

Initially this was discovered because it caused a crash
with the sata_dwc_460ex controller on a WD MyBook Live DUO.

The reporter "Tice Rex" which has the unique opportunity that he
has two Samsung 840 EVO SSD! One with the older firmware "EXT0BB0Q"
which booted fine and didn't expose "READ LOG DMA EXT". But the
newer/latest firmware "EXT0DB6Q" caused the headaches.

BugLink: https://github.com/openwrt/openwrt/issues/9505
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 791374199e22..d3a7b3bb5043 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4588,6 +4588,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Crucial_CT*MX100*",		"MU01",	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+	{ "Samsung SSD 840 EVO*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_NO_DMA_LOG |
+						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 840*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
-- 
2.35.1

