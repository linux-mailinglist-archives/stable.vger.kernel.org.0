Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DBD5F98F0
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiJJHEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiJJHEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:04:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CC04DB59;
        Mon, 10 Oct 2022 00:04:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D59DA60E75;
        Mon, 10 Oct 2022 07:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AFEC433B5;
        Mon, 10 Oct 2022 07:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385445;
        bh=z6OsWk08vLGcLmceY4PxP1JeS2qoz8/BVeiey1XblsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAlFSnzQ08mSYvTfxGWX+30IimNvvCW2jUKXnRx8snXe9snyIkzk+nec5uJqnYYjl
         1YyMaabF0nEWRAun7lkYgi6+NzOv71jwLO5jRYAnaCDraK/IrdgRn3hyp2M6AkWqIw
         iViL6n0C7vfJe/djRzdyd3BKaOZT0Sxn7ziSP5JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.0 10/17] USB: serial: ftdi_sio: fix 300 bps rate for SIO
Date:   Mon, 10 Oct 2022 09:04:33 +0200
Message-Id: <20221010070330.514134436@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
References: <20221010070330.159911806@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 7bd7ad3c310cd6766f170927381eea0aa6f46c69 upstream.

The 300 bps rate of SIO devices has been mapped to 9600 bps since
2003... Let's fix the regression.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1319,8 +1319,7 @@ static u32 get_ftdi_divisor(struct tty_s
 		case 38400: div_value = ftdi_sio_b38400; break;
 		case 57600: div_value = ftdi_sio_b57600;  break;
 		case 115200: div_value = ftdi_sio_b115200; break;
-		} /* baud */
-		if (div_value == 0) {
+		default:
 			dev_dbg(dev, "%s - Baudrate (%d) requested is not supported\n",
 				__func__,  baud);
 			div_value = ftdi_sio_b9600;


