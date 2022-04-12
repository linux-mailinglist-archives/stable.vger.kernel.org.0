Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5584FCB39
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343920AbiDLBDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345210AbiDLA63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7B631904;
        Mon, 11 Apr 2022 17:51:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79ED160B2B;
        Tue, 12 Apr 2022 00:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EF4C385A9;
        Tue, 12 Apr 2022 00:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724674;
        bh=CbIPikTS98zell/omv2T4yTylZp9j5m2kHpnBAFAYvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKkyDoYNS9tVd++wrCow/Sn3CeDR6mnVWzhNLiK/rX4qyRHukaoGBXv9Oh8UNA+hL
         xcfAYbToNKnlqD5W17rl4jZNOFkjWDcsbg8ReB8+9NQzPspShJce5x3UmfPCBxhcF8
         kYxjpkEMdeMAocimuS8egxK9sK5XPW8LcOXjUvZ23Dqz88sxvbkWr5knl/DeRUWnzp
         +GlElYS8ZqB1LVPcHRKDmYqfGAbG0bKClhMe70uWupBR1Dh4vKnWzehmu1LRmdVFlk
         4EYDtNUvzd8ShtQxPQgyAnaRczJ67A6blCe/i53qwM21A6X1B9ZO4Bps8514G1vJ4a
         mdQ6QX62XcDQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/21] ata: libata-core: Disable READ LOG DMA EXT for Samsung 840 EVOs
Date:   Mon, 11 Apr 2022 20:50:29 -0400
Message-Id: <20220412005042.351105-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005042.351105-1-sashal@kernel.org>
References: <20220412005042.351105-1-sashal@kernel.org>
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
index dca1590f295d..af8a1bac9345 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4580,6 +4580,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
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

