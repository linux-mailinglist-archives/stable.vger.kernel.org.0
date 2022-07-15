Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9359E575EDB
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 11:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiGOJ4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 05:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiGOJ4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 05:56:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6E711155;
        Fri, 15 Jul 2022 02:56:45 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bp15so8096180ejb.6;
        Fri, 15 Jul 2022 02:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W6/njTJhbblJdaS78KnMlJaVOm5XBe95k1aZo4s+bAo=;
        b=W+DS+qxnzxSxSJ8oOVhMDb6bGkzTFsS8K4TTg+9uHkBgVLfrg4oDfG1k25let+IBd0
         GW8mA/cn3iaxUW1tfln396K2Aj2pORHlzohmCr+6nyUNPbFPvQ2/4DZJ4t4ij9VLNn2j
         IaT8km2bEWRBSpfLo+hl57Bo6d03bHcV+1GWRxAeGlIJew/HJbWOHx3w+E2R+MNYtJr5
         DaZkff7lSU30RBMU/swhX6+Jq/c2nB4o2pMkRfrcuoVpWPwtxBuqpxszFzDQRWkbyQ5r
         7w0WP4F586IUxIHmJqNv1pKdiZGUZQNWP+nbq7iOa42b2XKa0+/S60Po0jhxFmz9H5Zx
         kVpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W6/njTJhbblJdaS78KnMlJaVOm5XBe95k1aZo4s+bAo=;
        b=4tyom1pPI4kGsPyL/vhssrhvy4wCn1xA36r8wCtx3TFdfXbnsDjo8EWIvh0/4EbOkL
         ZZs3UkPAVTKJyYu7V9rk9/qlUY/hVauftvB21gPYvrmmGOEIrGa+f81pgMXSFGDutIb3
         2yFDuPGe3My+eaHnrZ0u4RVP3F+iID272yS3gzMXoG/JAc6iGhPAAfBBlPIIgvrKgrEP
         R5MRysMvTsXhoJLMlNsduWVXsUU1m6OZ92Exy9rER2OHkab8vm+PlceDBLMlf785Qbd9
         3XJhDhXtgirZi9BpQNYOqP1412W14G+4/gc+MncZSi7nTGKKqXqR8Bg0Jyu3uDVgQLm9
         IVIg==
X-Gm-Message-State: AJIora+oTkwgdg/EjUhpYSWJTybDUSvdvsBIRyJ9vZoDXNaHTIOA0zNZ
        P8G6HQVso/YKFjtLHVc63rNT4RtcZMeUYw==
X-Google-Smtp-Source: AGRyM1sBSZZRCBk6S+oCCQ1x092DjVZIGdzQLuz6UsaK3FznGSUppL+v6g4P9EOiam927z0ne53Hjw==
X-Received: by 2002:a17:907:7781:b0:6fe:4398:47b3 with SMTP id ky1-20020a170907778100b006fe439847b3mr12840889ejc.513.1657879004200;
        Fri, 15 Jul 2022 02:56:44 -0700 (PDT)
Received: from localhost.localdomain (2a02-a466-aae1-1-52eb-71ff-fe56-bb66.fixed6.kpn.net. [2a02:a466:aae1:1:52eb:71ff:fe56:bb66])
        by smtp.gmail.com with ESMTPSA id w23-20020a1709060a1700b0072b2378027csm1823612ejf.26.2022.07.15.02.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 02:56:43 -0700 (PDT)
From:   Frans Klaver <fransklaver@gmail.com>
X-Google-Original-From: Frans Klaver <frans.klaver@vislink.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frans Klaver <frans.klaver@vislink.com>, stable@vger.kernel.org
Subject: [PATCH v2] usb: serial: qcserial: add EM9191 support
Date:   Fri, 15 Jul 2022 11:56:23 +0200
Message-Id: <20220715095623.28002-1-frans.klaver@vislink.com>
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

From: Frans Klaver <frans.klaver@vislink.com>

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
I noticed an e-mail address discrepancy that git-send-email didn't
magically fix for me. No change otherwise.

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

