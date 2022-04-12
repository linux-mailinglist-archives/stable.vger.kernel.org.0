Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E73D4FCA6E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244583AbiDLAxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245570AbiDLAxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:53:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9122B3336F;
        Mon, 11 Apr 2022 17:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B6B7B819B4;
        Tue, 12 Apr 2022 00:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69415C385A4;
        Tue, 12 Apr 2022 00:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724478;
        bh=/owy/O8ag0S9GdoObEsSYcAC04+NvJUCRS8wDSrBxVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBH9Re19hfPfWNppICorhJ9YOSMTPxH2aSuRLJYrFuKdZMMgR7mBcOotJaAjgrdBB
         +12ePYFm+Zi51LhfsVvIGGIMTHyI3yxCyuvhuBjm0+TjrTehfVpaO0aOXKOhosN9dd
         sopc9bmjoWTGs+sFfuXuGIn3CfKOFEiRF+G6ydtRg0Y7U9CP1yJcUGsYND3PrcTXJi
         hMye6L1/D+MagNwvipYuZHpY7AY1QNev8M7e49ze/I97attYDOkjPulX+T8LTYntKP
         hrXnYn1UiEvQRMhzFqPr5JJ+IcFXJF0SxlDBMbsOXyXCs87Dr9Vm0ABX1nt72LW2a2
         F1M5xxbz0L1tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 19/41] ata: libata-core: Disable READ LOG DMA EXT for Samsung 840 EVOs
Date:   Mon, 11 Apr 2022 20:46:31 -0400
Message-Id: <20220412004656.350101-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
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
index 24b67d78cb83..a0343b7c9add 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3999,6 +3999,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
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

