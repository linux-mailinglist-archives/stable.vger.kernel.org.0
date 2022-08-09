Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0852D58DEAE
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245375AbiHISWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346094AbiHISUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909B62FFCC;
        Tue,  9 Aug 2022 11:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7319DB8190F;
        Tue,  9 Aug 2022 18:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5E3C43470;
        Tue,  9 Aug 2022 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068418;
        bh=cGoSbcBMNOOEJ6uxE2E5jK3xAT+bVsyN8dNDllw4yW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0Do+lXjTmhxxcdPlk/7L2+IqzNBQUqM0gHQPS8OPMl/DV/P67z+eXUKCI78jFBcs
         cIUfHSONaLTjwtKIOZ40qp8+wYgXCoEtxhul+6PEYwPSVYDIP4nBheVYiYl7W+satM
         SWN2JMxgVzZsBrOds4RpBk75pqLIEr6oXbNWkMk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.18 24/35] Bluetooth: hci_bcm: Add BCM4349B1 variant
Date:   Tue,  9 Aug 2022 20:00:53 +0200
Message-Id: <20220809175515.952454036@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
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

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

commit 4f17c2b6694d0c4098f33b07ee3a696976940aa5 upstream.

The BCM4349B1, aka CYW/BCM89359, is a WiFi+BT chip and its Bluetooth
portion can be controlled over serial.

Two subversions are added for the chip, because ROM firmware reports
002.002.013 (at least for the chips I have here), while depending on
patchram firmware revision, either 002.002.013 or 002.002.014 is
reported.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btbcm.c   |    2 ++
 drivers/bluetooth/hci_bcm.c |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -453,6 +453,8 @@ static const struct bcm_subver_table bcm
 	{ 0x6606, "BCM4345C5"	},	/* 003.006.006 */
 	{ 0x230f, "BCM4356A2"	},	/* 001.003.015 */
 	{ 0x220e, "BCM20702A1"  },	/* 001.002.014 */
+	{ 0x420d, "BCM4349B1"	},	/* 002.002.013 */
+	{ 0x420e, "BCM4349B1"	},	/* 002.002.014 */
 	{ 0x4217, "BCM4329B1"   },	/* 002.002.023 */
 	{ 0x6106, "BCM4359C0"	},	/* 003.001.006 */
 	{ 0x4106, "BCM4335A0"	},	/* 002.001.006 */
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1544,6 +1544,7 @@ static const struct of_device_id bcm_blu
 	{ .compatible = "brcm,bcm43430a0-bt" },
 	{ .compatible = "brcm,bcm43430a1-bt" },
 	{ .compatible = "brcm,bcm43438-bt", .data = &bcm43438_device_data },
+	{ .compatible = "brcm,bcm4349-bt", .data = &bcm43438_device_data },
 	{ .compatible = "brcm,bcm43540-bt", .data = &bcm4354_device_data },
 	{ .compatible = "brcm,bcm4335a0" },
 	{ },


