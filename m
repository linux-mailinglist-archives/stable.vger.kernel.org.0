Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214C85BAA10
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiIPKIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiIPKIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:08:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BC2AB4E9;
        Fri, 16 Sep 2022 03:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0356AB8250D;
        Fri, 16 Sep 2022 10:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586F4C433D6;
        Fri, 16 Sep 2022 10:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322885;
        bh=OMsMBewpAbaaALD2RFu4M9metllM16vUrMHuCP1sk/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XA+BJnl7M2FQe3imSAVjK3udcNvchyzdz7rpwtSp3LN9ogaPg6TvcZQTE/sBH5Qik
         Tr5yXgYvKzZmEg+B5qAv4cfM+ysX2Tqcs8/cPG0bNWSPOHV5C/MZ9syvzIc/LSpkWC
         ANsUPtZALBcG3VJT6HL9TiG7j130ohwpMmqPFE5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 4/7] tg3: Disable tg3 device on system reboot to avoid triggering AER
Date:   Fri, 16 Sep 2022 12:07:56 +0200
Message-Id: <20220916100441.760953540@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100441.528608977@linuxfoundation.org>
References: <20220916100441.528608977@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 2ca1c94ce0b65a2ce7512b718f3d8a0fe6224bca ]

Commit d60cd06331a3 ("PM: ACPI: reboot: Use S5 for reboot") caused a
reboot hang on one Dell servers so the commit was reverted.

Someone managed to collect the AER log and it's caused by MSI:
[ 148.762067] ACPI: Preparing to enter system sleep state S5
[ 148.794638] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 5
[ 148.803731] {1}[Hardware Error]: event severity: recoverable
[ 148.810191] {1}[Hardware Error]: Error 0, type: fatal
[ 148.816088] {1}[Hardware Error]: section_type: PCIe error
[ 148.822391] {1}[Hardware Error]: port_type: 0, PCIe end point
[ 148.829026] {1}[Hardware Error]: version: 3.0
[ 148.834266] {1}[Hardware Error]: command: 0x0006, status: 0x0010
[ 148.841140] {1}[Hardware Error]: device_id: 0000:04:00.0
[ 148.847309] {1}[Hardware Error]: slot: 0
[ 148.852077] {1}[Hardware Error]: secondary_bus: 0x00
[ 148.857876] {1}[Hardware Error]: vendor_id: 0x14e4, device_id: 0x165f
[ 148.865145] {1}[Hardware Error]: class_code: 020000
[ 148.870845] {1}[Hardware Error]: aer_uncor_status: 0x00100000, aer_uncor_mask: 0x00010000
[ 148.879842] {1}[Hardware Error]: aer_uncor_severity: 0x000ef030
[ 148.886575] {1}[Hardware Error]: TLP Header: 40000001 0000030f 90028090 00000000
[ 148.894823] tg3 0000:04:00.0: AER: aer_status: 0x00100000, aer_mask: 0x00010000
[ 148.902795] tg3 0000:04:00.0: AER: [20] UnsupReq (First)
[ 148.910234] tg3 0000:04:00.0: AER: aer_layer=Transaction Layer, aer_agent=Requester ID
[ 148.918806] tg3 0000:04:00.0: AER: aer_uncor_severity: 0x000ef030
[ 148.925558] tg3 0000:04:00.0: AER: TLP Header: 40000001 0000030f 90028090 00000000

The MSI is probably raised by incoming packets, so power down the device
and disable bus mastering to stop the traffic, as user confirmed this
approach works.

In addition to that, be extra safe and cancel reset task if it's running.

Cc: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/all/b8db79e6857c41dab4ef08bdf826ea7c47e3bafc.1615947283.git.josef@toxicpanda.com/
BugLink: https://bugs.launchpad.net/bugs/1917471
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20220826002530.1153296-1-kai.heng.feng@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 480179ddc45b6..3279a6e48f3b4 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18157,16 +18157,20 @@ static void tg3_shutdown(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct tg3 *tp = netdev_priv(dev);
 
+	tg3_reset_task_cancel(tp);
+
 	rtnl_lock();
+
 	netif_device_detach(dev);
 
 	if (netif_running(dev))
 		dev_close(dev);
 
-	if (system_state == SYSTEM_POWER_OFF)
-		tg3_power_down(tp);
+	tg3_power_down(tp);
 
 	rtnl_unlock();
+
+	pci_disable_device(pdev);
 }
 
 /**
-- 
2.35.1



