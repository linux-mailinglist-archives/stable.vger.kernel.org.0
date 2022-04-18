Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A625056DD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244904AbiDRNt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244967AbiDRNsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A306C33A1F;
        Mon, 18 Apr 2022 06:01:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1706360B35;
        Mon, 18 Apr 2022 13:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120D6C385A1;
        Mon, 18 Apr 2022 13:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286879;
        bh=nLTb8cVk54NYUvxJo3sCKn6CKhUaBxzuzBw9kiWXymM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuuDBBCt5JtoJibTwKAIRXt7cIri8x4NwrP0/DPY25xjry4PONeD+55Y7n3GuVlvB
         Go7+Me8zc9gr2iIsYjGS77RPlCA4WNr62c2UEdbPAYPT0iLMu6TG6KHgNWDfZOlZ3x
         42yrkLjk1gS388MQGrJhIO6V1P5nbq885D7wqN0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 274/284] ata: libata-core: Disable READ LOG DMA EXT for Samsung 840 EVOs
Date:   Mon, 18 Apr 2022 14:14:15 +0200
Message-Id: <20220418121220.769084051@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



