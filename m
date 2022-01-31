Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937E14A47F1
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 14:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbiAaNVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 08:21:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51138 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiAaNVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 08:21:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB1B46114F
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 13:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD24C340EE;
        Mon, 31 Jan 2022 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643635292;
        bh=R+ZAAOk95F9f/Bj3ZzkbqqU54uetsdncloIq0W3FzEw=;
        h=Subject:To:From:Date:From;
        b=JlOFupMdViPZie8vIPJ63Xnt88HzymzdUtfvUMBPrheDisEgg15NjjuGF+5WUIvGU
         watPkxQ2EEJM7A+oExf17m4BCtQz82hbFvh4zY7u29L5M+y6nU8UZobbsRtYl0SOXJ
         KJ1tFVQU6y3i2kw5+YGwa1Jd1XbbJztId/QZPDRc=
Subject: patch "usb: gadget: f_uac2: Define specific wTerminalType" added to usb-testing
To:     pavel.hofman@ivitera.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 14:21:29 +0100
Message-ID: <1643635289101140@kroah.com>
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
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 521e6baff47d34db0f028ff05e5f9a339c45d87c Mon Sep 17 00:00:00 2001
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
index d874e0d34188..141e4814347e 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -202,7 +202,7 @@ static struct uac2_input_terminal_descriptor io_in_it_desc = {
 
 	.bDescriptorSubtype = UAC_INPUT_TERMINAL,
 	/* .bTerminalID = DYNAMIC */
-	.wTerminalType = cpu_to_le16(UAC_INPUT_TERMINAL_UNDEFINED),
+	.wTerminalType = cpu_to_le16(UAC_INPUT_TERMINAL_MICROPHONE),
 	.bAssocTerminal = 0,
 	/* .bCSourceID = DYNAMIC */
 	.iChannelNames = 0,
@@ -230,7 +230,7 @@ static struct uac2_output_terminal_descriptor io_out_ot_desc = {
 
 	.bDescriptorSubtype = UAC_OUTPUT_TERMINAL,
 	/* .bTerminalID = DYNAMIC */
-	.wTerminalType = cpu_to_le16(UAC_OUTPUT_TERMINAL_UNDEFINED),
+	.wTerminalType = cpu_to_le16(UAC_OUTPUT_TERMINAL_SPEAKER),
 	.bAssocTerminal = 0,
 	/* .bSourceID = DYNAMIC */
 	/* .bCSourceID = DYNAMIC */
-- 
2.35.1


