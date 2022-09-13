Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279A35B764C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 18:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiIMQSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 12:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbiIMQSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 12:18:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9EEA4B07;
        Tue, 13 Sep 2022 08:13:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29C77614BD;
        Tue, 13 Sep 2022 14:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88443C43140;
        Tue, 13 Sep 2022 14:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663080803;
        bh=/8WqCLI/wMTjSbA7iL9pUmar0F3oKI5oUzIn+3qnt+c=;
        h=From:To:Cc:Subject:Date:From;
        b=Li7BgVSfXOWDvCNi0CtS04TwNdrK+uzVPegNGktqG3WwwGe00CfDGUvLfGKqFkteV
         pKg+LHSJ1UrHbQiuP0QPKIRYm5imQXjn65Ma2qlK1ZpDQLRy+JYyXNIilxebPwGlHq
         T1cN+XJ9ZyrjHPHIM9Zj7OcO8GoQIEXx7UoxFLBzqG3G4zQbFNOMuGajsEsSWVrosm
         fBR9kADARFhn2ZK20yvCPObWSF1cYrhVla8dbaDVGSVrh65gfmtYRKniLGZxCEjYbh
         KSmHVnejSGXipu14cv/4Ue55Yx25PD9DfHpMN/QiwNnCsHiX9thcIV155ziN2O0Qwt
         rjADueaqIgaRQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oY7Hv-0005PR-0J; Tue, 13 Sep 2022 16:53:23 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] USB: serial: ftdi_sio: fix 300 bps rate for SIO
Date:   Tue, 13 Sep 2022 16:53:12 +0200
Message-Id: <20220913145312.20782-1-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

The 300 bps rate of SIO devices has been mapped to 9600 bps since
2003... Let's fix the regression.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ftdi_sio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 52d59be92034..787e63fd7f99 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1319,8 +1319,7 @@ static u32 get_ftdi_divisor(struct tty_struct *tty,
 		case 38400: div_value = ftdi_sio_b38400; break;
 		case 57600: div_value = ftdi_sio_b57600;  break;
 		case 115200: div_value = ftdi_sio_b115200; break;
-		} /* baud */
-		if (div_value == 0) {
+		default:
 			dev_dbg(dev, "%s - Baudrate (%d) requested is not supported\n",
 				__func__,  baud);
 			div_value = ftdi_sio_b9600;
-- 
2.35.1

