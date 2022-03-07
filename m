Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CF74CF76B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiCGJqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiCGJiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:38:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6B469CC4;
        Mon,  7 Mar 2022 01:32:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCF9FB810C5;
        Mon,  7 Mar 2022 09:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4D9C340F3;
        Mon,  7 Mar 2022 09:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645495;
        bh=UX0cSTiXuUImb5J5fbrqY4X0GrbQz0H/DOnt2nvYZ/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JD/kFo1XZCaibiucn2YtRUxRCru2oWGMaRDbxuGIPYZIv//2nG68PctDQH67FxNCV
         f5+J3WdG4AJNzeaibfXpI/WPuUhtQqaVQoD5L7l1F1mnyjnkFeuT+4AKTPyO7eiUjh
         gg+UZyd90LCHvmL9x1wGG0/gqSQNgBnjnKJq+Vbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/105] ata: pata_hpt37x: fix PCI clock detection
Date:   Mon,  7 Mar 2022 10:18:25 +0100
Message-Id: <20220307091644.807599651@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 5f6b0f2d037c8864f20ff15311c695f65eb09db5 ]

The f_CNT register (at the PCI config. address 0x78) is 16-bit, not
8-bit! The bug was there from the very start... :-(

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Fixes: 669a5db411d8 ("[libata] Add a bunch of PATA drivers.")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_hpt37x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 499a947d56ddb..fef46de2f6b23 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -962,14 +962,14 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 
 	if ((freq >> 12) != 0xABCDE) {
 		int i;
-		u8 sr;
+		u16 sr;
 		u32 total = 0;
 
 		pr_warn("BIOS has not set timing clocks\n");
 
 		/* This is the process the HPT371 BIOS is reported to use */
 		for (i = 0; i < 128; i++) {
-			pci_read_config_byte(dev, 0x78, &sr);
+			pci_read_config_word(dev, 0x78, &sr);
 			total += sr & 0x1FF;
 			udelay(15);
 		}
-- 
2.34.1



