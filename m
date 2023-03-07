Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768A96AE96C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjCGRX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjCGRXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:23:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3849CFD4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:19:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A31D614AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CC4C433EF;
        Tue,  7 Mar 2023 17:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209545;
        bh=I543dr2jUFW6YibHtJ+Lgsrd2Bzm3TMfk2w4TydB5Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8tWEqvC3LlqV7QoktNnwlEpcH8FVlxRueUYT4k4Hz/OdJ60XKKXTy+hDxCFgNU5N
         AsK8cd77xNWW2E0VB2dP97J1sz788HwHvKlx62ozDZeXddhcvrHOw+Hwubr/BNp/b7
         qWGb2utDi3V8TgsiEujnzcMm7SPYWUBQvNkK2Gds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aaron Ma <aaron.ma@canonical.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0252/1001] wifi: mt76: mt7921: fix error code of return in mt7921_acpi_read
Date:   Tue,  7 Mar 2023 17:50:24 +0100
Message-Id: <20230307170032.719740396@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit 888d89034f9eaeab9b5b75f13dbe35376c7dd471 ]

Kernel NULL pointer dereference when ACPI SAR table isn't implemented well.
Fix the error code of return to mark the ACPI SAR table as invalid.

[    5.077128] mt7921e 0000:06:00.0: sar cnt = 0
[    5.077381] BUG: kernel NULL pointer dereference, address:
0000000000000004
[    5.077630] #PF: supervisor read access in kernel mode
[    5.077883] #PF: error_code(0x0000) - not-present page
[    5.078138] PGD 0 P4D 0
[    5.078398] Oops: 0000 [#1] PREEMPT SMP NOPTI
[    5.079202] RIP: 0010:mt7921_init_acpi_sar+0x106/0x220
[mt7921_common]
...
[    5.080786] Call Trace:
[    5.080786]  <TASK>
[    5.080786]  mt7921_register_device+0x37d/0x490 [mt7921_common]
[    5.080786]  mt7921_pci_probe.part.0+0x2ee/0x310 [mt7921e]
[    5.080786]  mt7921_pci_probe+0x52/0x70 [mt7921e]
[    5.080786]  local_pci_probe+0x47/0x90
[    5.080786]  pci_call_probe+0x55/0x190
[    5.080786]  pci_device_probe+0x84/0x120

Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
index 47e034a9b0037..ed9241d4aa641 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
@@ -33,14 +33,17 @@ mt7921_acpi_read(struct mt7921_dev *dev, u8 *method, u8 **tbl, u32 *len)
 	    sar_root->package.elements[0].type != ACPI_TYPE_INTEGER) {
 		dev_err(mdev->dev, "sar cnt = %d\n",
 			sar_root->package.count);
+		ret = -EINVAL;
 		goto free;
 	}
 
 	if (!*tbl) {
 		*tbl = devm_kzalloc(mdev->dev, sar_root->package.count,
 				    GFP_KERNEL);
-		if (!*tbl)
+		if (!*tbl) {
+			ret = -ENOMEM;
 			goto free;
+		}
 	}
 	if (len)
 		*len = sar_root->package.count;
@@ -52,9 +55,9 @@ mt7921_acpi_read(struct mt7921_dev *dev, u8 *method, u8 **tbl, u32 *len)
 			break;
 		*(*tbl + i) = (u8)sar_unit->integer.value;
 	}
-free:
 	ret = (i == sar_root->package.count) ? 0 : -EINVAL;
 
+free:
 	kfree(sar_root);
 
 	return ret;
-- 
2.39.2



