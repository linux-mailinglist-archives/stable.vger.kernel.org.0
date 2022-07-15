Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57036575ECD
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 11:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiGOJuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 05:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiGOJt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 05:49:59 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40F445056;
        Fri, 15 Jul 2022 02:49:56 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id e15so5619710edj.2;
        Fri, 15 Jul 2022 02:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n8dig1NyCS89iLcaSuvcTKO6sSVkH9JK71gnqh5Lh8E=;
        b=npPvJAf/ASIAUbinUfObY5olndXL0Muo034OOWiwKss5bECxrcwyQ0+LM9TghRoV/S
         J/833Ge/svqfAQCkSR/dS1wPzYyJn8WNNhHHbVknBLhF1lEdZ6Xrh+AF7/c3gt7ru8N2
         wcDaBIjgNdE+jdE9EwTxcZtVjPxzewVRuKRD8I/KcitWQHC8KiXsyoLE59acd/FDECZS
         tyAsZJX2denp+1w1Cut2pGr6sFm5mSp5L9CJXCzfcffzIF8YEUqW8n1oTbK6bFO7mbX2
         RgxHfC0RSj2wFA85MDwAYp2fOn/rER7ohi36CUQxwfgj+qN8JKn8fYZQU5PfRyPzMhpR
         ui1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n8dig1NyCS89iLcaSuvcTKO6sSVkH9JK71gnqh5Lh8E=;
        b=rNlvKz//3Sqc+pjwISI5+8xfXQBBbDEefoZ0YqBru5AZqkWr4P0PPQPWaaW6dmWHVP
         iMgG+4zHvJIYk67y5YyhgCE7EipYNggFKpdsjnDyNGiEaU7PD+UebsI/O62gf2kwQuLw
         r/SkDXKTV46piGmoqOKjGGugwHP03g+147VhQTCYbY4Iv9CDm5St4Y1HlrHmck6Dd+w6
         AoLJUS0PwcvegLtseYRDVPKNKh3cMxOWL1infpKacW+RIcW7OZw0Tw6OxV/J/gz5bZMn
         nOW3ldFt60qSszqY9L7+gm2pg0Kqd+aTekBmXYk91AE0ahqYci694xji+eXL90i95Qyy
         /mFw==
X-Gm-Message-State: AJIora9smxqJe+3nQxiyhxTY5vw9WIbNWwzv+xk/nycvPgLNl+k4NEtr
        EP4B2O+YEEQjdyKsjWCFTKs=
X-Google-Smtp-Source: AGRyM1sm7VeOyASXxNayrISmW3m9C3QJ+gI9QUdkeh5N6u77Hyk7D/7YGa9/3x08ZYqK+PmjHP5BOg==
X-Received: by 2002:a05:6402:1606:b0:43a:2204:8b5e with SMTP id f6-20020a056402160600b0043a22048b5emr17438836edv.316.1657878595331;
        Fri, 15 Jul 2022 02:49:55 -0700 (PDT)
Received: from localhost.localdomain (2a02-a466-aae1-1-52eb-71ff-fe56-bb66.fixed6.kpn.net. [2a02:a466:aae1:1:52eb:71ff:fe56:bb66])
        by smtp.gmail.com with ESMTPSA id r1-20020a17090609c100b0072af102e65csm1811036eje.152.2022.07.15.02.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 02:49:54 -0700 (PDT)
From:   Frans Klaver <fransklaver@gmail.com>
X-Google-Original-From: Frans Klaver <frans.klaver@vislink.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frans Klaver <frans.klaver@vislink.com>, stable@vger.kernel.org
Subject: [PATCH] usb: serial: qcserial: add EM9191 support
Date:   Fri, 15 Jul 2022 11:49:15 +0200
Message-Id: <20220715094915.27348-1-frans.klaver@vislink.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Support for QDL mode is already present for EM9191 modules, but the
non-QDL mode appears to be missing. Add it now.

T:  Bus=03 Lev=03 Prnt=04 Port=01 Cnt=02 Dev#= 17 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1199 ProdID=90d3 Rev=00.06
S:  Manufacturer=Sierra Wireless, Incorporated
S:  Product=Sierra Wireless EM9191
S:  SerialNumber=8W0463003002A114
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=qcserial
I:  If#=0x4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=qcserial

Cc: stable@vger.kernel.org
Signed-off-by: Frans Klaver <frans.klaver@vislink.com>
---
 drivers/usb/serial/qcserial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 586ef5551e76e..73f6d3a37c0c4 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -166,6 +166,7 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x1199, 0x9090)},	/* Sierra Wireless EM7565 QDL */
 	{DEVICE_SWI(0x1199, 0x9091)},	/* Sierra Wireless EM7565 */
 	{DEVICE_SWI(0x1199, 0x90d2)},	/* Sierra Wireless EM9191 QDL */
+	{DEVICE_SWI(0x1199, 0x90d3)},	/* Sierra Wireless EM9191 */
 	{DEVICE_SWI(0x1199, 0xc080)},	/* Sierra Wireless EM7590 QDL */
 	{DEVICE_SWI(0x1199, 0xc081)},	/* Sierra Wireless EM7590 */
 	{DEVICE_SWI(0x413c, 0x81a2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
-- 
2.37.1

