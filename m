Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D054A47FA
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 14:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378700AbiAaNXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 08:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378630AbiAaNXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 08:23:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D2AC061401
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 05:23:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE7A61225
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 13:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC05CC340EF;
        Mon, 31 Jan 2022 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643635395;
        bh=Z35/+uIPJsXctCXIe+QPKVOziGxtSuCrOK/t1SKwdEM=;
        h=Subject:To:From:Date:From;
        b=tBdZN1vsbKNWjgtxcJaYy8thlPKQ8wPLiGPMZ3z7vjLZIXVzMk6weofnsWEgRO1nn
         lHLreRlwL5jYTcNTn/9etCLJ5xe46XVL6EzaXUF29rYLOftn0BBRWzSNsQaFWVIGJ3
         L30N/WJoY75sSvtBVPbq9Xgm61Atzg6s1+BQ/57U=
Subject: patch "usb: gadget: f_uac2: Define specific wTerminalType" added to usb-linus
To:     pavel.hofman@ivitera.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 14:23:00 +0100
Message-ID: <164363538017289@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_uac2: Define specific wTerminalType

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5432184107cd0013761bdfa6cb6079527ef87b95 Mon Sep 17 00:00:00 2001
From: Pavel Hofman <pavel.hofman@ivitera.com>
Date: Mon, 31 Jan 2022 08:18:13 +0100
Subject: usb: gadget: f_uac2: Define specific wTerminalType

Several users have reported that their Win10 does not enumerate UAC2
gadget with the existing wTerminalType set to
UAC_INPUT_TERMINAL_UNDEFINED/UAC_INPUT_TERMINAL_UNDEFINED, e.g.
https://github.com/raspberrypi/linux/issues/4587#issuecomment-926567213.
While the constant is officially defined by the USB terminal types
document, e.g. XMOS firmware for UAC2 (commonly used for Win10) defines
no undefined output terminal type in its usbaudio20.h header.

Therefore wTerminalType of EP-IN is set to
UAC_INPUT_TERMINAL_MICROPHONE and wTerminalType of EP-OUT to
UAC_OUTPUT_TERMINAL_SPEAKER for the UAC2 gadget.

Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220131071813.7433-1-pavel.hofman@ivitera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 36fa6ef0581b..097a709549d6 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -203,7 +203,7 @@ static struct uac2_input_terminal_descriptor io_in_it_desc = {
 
 	.bDescriptorSubtype = UAC_INPUT_TERMINAL,
 	/* .bTerminalID = DYNAMIC */
-	.wTerminalType = cpu_to_le16(UAC_INPUT_TERMINAL_UNDEFINED),
+	.wTerminalType = cpu_to_le16(UAC_INPUT_TERMINAL_MICROPHONE),
 	.bAssocTerminal = 0,
 	/* .bCSourceID = DYNAMIC */
 	.iChannelNames = 0,
@@ -231,7 +231,7 @@ static struct uac2_output_terminal_descriptor io_out_ot_desc = {
 
 	.bDescriptorSubtype = UAC_OUTPUT_TERMINAL,
 	/* .bTerminalID = DYNAMIC */
-	.wTerminalType = cpu_to_le16(UAC_OUTPUT_TERMINAL_UNDEFINED),
+	.wTerminalType = cpu_to_le16(UAC_OUTPUT_TERMINAL_SPEAKER),
 	.bAssocTerminal = 0,
 	/* .bSourceID = DYNAMIC */
 	/* .bCSourceID = DYNAMIC */
-- 
2.35.1


