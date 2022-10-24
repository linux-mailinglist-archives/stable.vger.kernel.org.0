Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B8960A40E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbiJXMFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiJXMDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:03:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0BB356EA;
        Mon, 24 Oct 2022 04:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59ADCB811AB;
        Mon, 24 Oct 2022 11:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8440C433C1;
        Mon, 24 Oct 2022 11:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612107;
        bh=a7PnIGvopb4QKsMeyez/yTomLe0JNasOnQjCXOfD6PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcTcoqwHZ9SQuT4bnkwkMWwAPypis/GCdc5EFbpOxNXwQwhiW+POHAcREJqeW94XK
         EHDMrC6KlFO/mYPtem4DZQL7/tv9HI93Fdf9NUtpzAQT1c5LiJtztQiiCJz01qQllP
         glRVrn69GbL77aMXPvBLZmADw6klviDpFmXTlqUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 031/210] USB: serial: ftdi_sio: fix 300 bps rate for SIO
Date:   Mon, 24 Oct 2022 13:29:08 +0200
Message-Id: <20221024112957.971464744@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1309,8 +1309,7 @@ static __u32 get_ftdi_divisor(struct tty
 		case 38400: div_value = ftdi_sio_b38400; break;
 		case 57600: div_value = ftdi_sio_b57600;  break;
 		case 115200: div_value = ftdi_sio_b115200; break;
-		} /* baud */
-		if (div_value == 0) {
+		default:
 			dev_dbg(dev, "%s - Baudrate (%d) requested is not supported\n",
 				__func__,  baud);
 			div_value = ftdi_sio_b9600;


