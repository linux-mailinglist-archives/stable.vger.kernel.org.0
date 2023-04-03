Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57256D4739
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjDCOSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbjDCOSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:18:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833422952D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:18:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CC5061CF1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29480C433D2;
        Mon,  3 Apr 2023 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531499;
        bh=0Smb4QBuAw+p2vpfDH6R5AGMEtDODAPQEEWPWaCioig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yApRJ9hF5K36mUnp8ie9rGve+XzuUzAwPMRy7qmfw+Ev+UYqChPcjUW2YPJsc3J34
         50XCoP0EqMpVnfCqRNWrxSBNmui7mBo4wdavkLa8guo9AULRu5u38KPyjH/v8FbEza
         rP76BoFMmDRt8ueIhd8GGMTdjPGyBu7yEwVjMfvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, msizanoen <msizanoen@qtmlabs.xyz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 67/84] Input: alps - fix compatibility with -funsigned-char
Date:   Mon,  3 Apr 2023 16:09:08 +0200
Message-Id: <20230403140355.751200267@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: msizanoen <msizanoen@qtmlabs.xyz>

commit 754ff5060daf5a1cf4474eff9b4edeb6c17ef7ab upstream.

The AlpsPS/2 code previously relied on the assumption that `char` is a
signed type, which was true on x86 platforms (the only place where this
driver is used) before kernel 6.2. However, on 6.2 and later, this
assumption is broken due to the introduction of -funsigned-char as a new
global compiler flag.

Fix this by explicitly specifying the signedness of `char` when sign
extending the values received from the device.

Fixes: f3f33c677699 ("Input: alps - Rushmore and v7 resolution support")
Signed-off-by: msizanoen <msizanoen@qtmlabs.xyz>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230320045228.182259-1-msizanoen@qtmlabs.xyz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/alps.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -855,8 +855,8 @@ static void alps_process_packet_v6(struc
 			x = y = z = 0;
 
 		/* Divide 4 since trackpoint's speed is too fast */
-		input_report_rel(dev2, REL_X, (char)x / 4);
-		input_report_rel(dev2, REL_Y, -((char)y / 4));
+		input_report_rel(dev2, REL_X, (s8)x / 4);
+		input_report_rel(dev2, REL_Y, -((s8)y / 4));
 
 		psmouse_report_standard_buttons(dev2, packet[3]);
 
@@ -1107,8 +1107,8 @@ static void alps_process_trackstick_pack
 	    ((packet[3] & 0x20) << 1);
 	z = (packet[5] & 0x3f) | ((packet[3] & 0x80) >> 1);
 
-	input_report_rel(dev2, REL_X, (char)x);
-	input_report_rel(dev2, REL_Y, -((char)y));
+	input_report_rel(dev2, REL_X, (s8)x);
+	input_report_rel(dev2, REL_Y, -((s8)y));
 	input_report_abs(dev2, ABS_PRESSURE, z);
 
 	psmouse_report_standard_buttons(dev2, packet[1]);
@@ -2297,20 +2297,20 @@ static int alps_get_v3_v7_resolution(str
 	if (reg < 0)
 		return reg;
 
-	x_pitch = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_pitch = (s8)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_pitch = 50 + 2 * x_pitch; /* In 0.1 mm units */
 
-	y_pitch = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_pitch = (s8)reg >> 4; /* sign extend upper 4 bits */
 	y_pitch = 36 + 2 * y_pitch; /* In 0.1 mm units */
 
 	reg = alps_command_mode_read_reg(psmouse, reg_pitch + 1);
 	if (reg < 0)
 		return reg;
 
-	x_electrode = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_electrode = (s8)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_electrode = 17 + x_electrode;
 
-	y_electrode = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_electrode = (s8)reg >> 4; /* sign extend upper 4 bits */
 	y_electrode = 13 + y_electrode;
 
 	x_phys = x_pitch * (x_electrode - 1); /* In 0.1 mm units */


