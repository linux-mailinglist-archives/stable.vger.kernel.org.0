Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DC35FDF5A
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiJMRxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiJMRxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:53:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFFA14FD3C;
        Thu, 13 Oct 2022 10:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEE7FB82023;
        Thu, 13 Oct 2022 17:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447A7C4347C;
        Thu, 13 Oct 2022 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683573;
        bh=iAr2bdd55JyX61KwNHcOrbz7/shgwLEETzjHoF0LZbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkD/kPu/zaVJYbbqnuKfNB1u+HTy0EOiOhF1J7C4spIryl/CUhndR5r/7HtQSBVWr
         mseEuMl3cto5SAa0pR3lsLM/tCMv89uELAJEwmUARtaTSl6ysce727lqvB4KxIHmA2
         rSLnjVo4tIcne+GqC11E98PmxqdXUBt8/BqNHRgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 14/38] USB: serial: ftdi_sio: fix 300 bps rate for SIO
Date:   Thu, 13 Oct 2022 19:52:15 +0200
Message-Id: <20221013175144.747770047@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
References: <20221013175144.245431424@linuxfoundation.org>
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
@@ -1320,8 +1320,7 @@ static u32 get_ftdi_divisor(struct tty_s
 		case 38400: div_value = ftdi_sio_b38400; break;
 		case 57600: div_value = ftdi_sio_b57600;  break;
 		case 115200: div_value = ftdi_sio_b115200; break;
-		} /* baud */
-		if (div_value == 0) {
+		default:
 			dev_dbg(dev, "%s - Baudrate (%d) requested is not supported\n",
 				__func__,  baud);
 			div_value = ftdi_sio_b9600;


