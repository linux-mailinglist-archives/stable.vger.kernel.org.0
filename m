Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235A159D479
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242851AbiHWIYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242890AbiHWIV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:21:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7443E6B66F;
        Tue, 23 Aug 2022 01:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF22612DA;
        Tue, 23 Aug 2022 08:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D98C43142;
        Tue, 23 Aug 2022 08:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242358;
        bh=70zht3iXI+nD4lhGJ7awU9z0EeMuRPW/A6oszaYsjeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTc+raHFE4y2rc97//cnIvmAw1TMnw7Ek3RRWMF1FfIDmdZT5P2HuFxYn1dfZcA9R
         93JZE1+TMLRx1O2KF9ch0841FaexxTgOqIC0qJS1bilwZsRHStveoH239NW4E9TB4A
         UAVH5UUnWQ8Go/TaNpl/ADW79OKl33qG6h8MocKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.19 103/365] Input: mt6779-keypad - match hardware matrix organization
Date:   Tue, 23 Aug 2022 10:00:04 +0200
Message-Id: <20220823080122.513731633@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Mattijs Korpershoek <mkorpershoek@baylibre.com>

commit d6ed52583034f9d2e39dead7c18e03380fd4edf2 upstream.

The MediaTek keypad has a set of bits representing keys,
from KEY0 to KEY77, arranged in 5 chunks of 15 bits split into 5 32-bit
registers.

In our implementation, we simply decided to use register number as row
and offset in the register as column when encoding our "matrix".

Because of this, we can have a 5x32 matrix which does not match the
hardware at all, which is confusing.

Change the row/column calculation to match the hardware.

Fixes: f28af984e771 ("Input: mt6779-keypad - add MediaTek keypad driver")
Co-developed-by: Fabien Parent <fparent@baylibre.com>
Signed-off-by: Fabien Parent <fparent@baylibre.com>
Signed-off-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/20220707075236.126631-2-mkorpershoek@baylibre.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/mt6779-keypad.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/mt6779-keypad.c b/drivers/input/keyboard/mt6779-keypad.c
index 2e7c9187c10f..bd86cb95bde3 100644
--- a/drivers/input/keyboard/mt6779-keypad.c
+++ b/drivers/input/keyboard/mt6779-keypad.c
@@ -42,7 +42,7 @@ static irqreturn_t mt6779_keypad_irq_handler(int irq, void *dev_id)
 	const unsigned short *keycode = keypad->input_dev->keycode;
 	DECLARE_BITMAP(new_state, MTK_KPD_NUM_BITS);
 	DECLARE_BITMAP(change, MTK_KPD_NUM_BITS);
-	unsigned int bit_nr;
+	unsigned int bit_nr, key;
 	unsigned int row, col;
 	unsigned int scancode;
 	unsigned int row_shift = get_count_order(keypad->n_cols);
@@ -61,8 +61,10 @@ static irqreturn_t mt6779_keypad_irq_handler(int irq, void *dev_id)
 		if (bit_nr % 32 >= 16)
 			continue;
 
-		row = bit_nr / 32;
-		col = bit_nr % 32;
+		key = bit_nr / 32 * 16 + bit_nr % 32;
+		row = key / 9;
+		col = key % 9;
+
 		scancode = MATRIX_SCAN_CODE(row, col, row_shift);
 		/* 1: not pressed, 0: pressed */
 		pressed = !test_bit(bit_nr, new_state);
-- 
2.37.2



