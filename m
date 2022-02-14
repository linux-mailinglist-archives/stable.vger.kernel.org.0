Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D124B49C1
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345710AbiBNKOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:14:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345776AbiBNKNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:13:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6E360A9E;
        Mon, 14 Feb 2022 01:51:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04E2AB80D6D;
        Mon, 14 Feb 2022 09:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37ACC340F0;
        Mon, 14 Feb 2022 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832311;
        bh=/ako78qHvG1RvoXTVwp995X+ARBRgcjJey/+7W75fHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLhG+wsEYt/c62oqQ5v0nhwOQ7NZlpY+MWGYGKDdizOMQZ/djc50UfsaD3GZEo7El
         Jm1+hMQ9Qjtr0/Wc4xgTCVhESogoeczswRsv+QuUpLlvslA5NQ/jvrBSlwi0yc4qu2
         4I0gk38s8Qwhe09KynPaaE6QyNwfC8L5ZciOJK9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Hofman <pavel.hofman@ivitera.com>
Subject: [PATCH 5.15 147/172] usb: gadget: f_uac2: Define specific wTerminalType
Date:   Mon, 14 Feb 2022 10:26:45 +0100
Message-Id: <20220214092511.462244663@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Hofman <pavel.hofman@ivitera.com>

commit 5432184107cd0013761bdfa6cb6079527ef87b95 upstream.

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
 drivers/usb/gadget/function/f_uac2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -202,7 +202,7 @@ static struct uac2_input_terminal_descri
 
 	.bDescriptorSubtype = UAC_INPUT_TERMINAL,
 	/* .bTerminalID = DYNAMIC */
-	.wTerminalType = cpu_to_le16(UAC_INPUT_TERMINAL_UNDEFINED),
+	.wTerminalType = cpu_to_le16(UAC_INPUT_TERMINAL_MICROPHONE),
 	.bAssocTerminal = 0,
 	/* .bCSourceID = DYNAMIC */
 	.iChannelNames = 0,
@@ -230,7 +230,7 @@ static struct uac2_output_terminal_descr
 
 	.bDescriptorSubtype = UAC_OUTPUT_TERMINAL,
 	/* .bTerminalID = DYNAMIC */
-	.wTerminalType = cpu_to_le16(UAC_OUTPUT_TERMINAL_UNDEFINED),
+	.wTerminalType = cpu_to_le16(UAC_OUTPUT_TERMINAL_SPEAKER),
 	.bAssocTerminal = 0,
 	/* .bSourceID = DYNAMIC */
 	/* .bCSourceID = DYNAMIC */


