Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046AA35D0AD
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 20:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhDLS7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 14:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbhDLS7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 14:59:36 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82016C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 11:59:18 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id a21so1402455oib.10
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 11:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N+siDAfwezNqWHpBFPCXT/A7lUGumpyM16jyxwDsV+k=;
        b=gNS5k+EIjH4yGRCHD6qix5UrsnzSHjR+E+3Tv4rOx9RQrScdvBGqRVbKCYy39lG1U6
         3II4wT5pRgJzNqB/W3Ql/iql+IhQYE3xn72BlyOOTYxDT7UlmfgiKIWWyhrCM5yCJS4K
         ShLOwRMHPXRrBf+sTIiDBJy9sGr2CZR+ilevsayOCS4zDZzUPmZofvSanfDMEHglqF18
         rTGwGBMvuU7dZ4Pzc/wciMjeCvrJukbf3vpi7SsKDy8eTEA/qRdu2Fnb3uS/wknNOQfe
         hjhRK9Js5vGzlNYApCU/HfqKefuq7wNBqQ/NshIUhp8YKlK66K9CJsyG7XZw+9twUxeW
         VjDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N+siDAfwezNqWHpBFPCXT/A7lUGumpyM16jyxwDsV+k=;
        b=Pd/U8XRROQOpfdtXp+ywpuT/jOvxzQd412DLDz3ZdJJf5XMvUeDzOtMGlQw7GNakJ3
         HjSd8+YNznFMPecJA8w1Kfha6pF60UfA/R39LLnIsK0ZShX2286RGskQXXXMHPel6QOy
         fBa6X0ieB6q76squGRmTlv8/Vx9rzX9Txgk3DKyag2zoui3ILizEQDdObAMCJJbaODRC
         ev0eIaisajjBeux19SOPS1CFK/+DiYdFdOg9v/owCpW1Z8pNU2e1GYBVqsLEFiGgSX/C
         kv0hokNCQly1demz2FzFLiGjACDXNoMDns9/TjDDFxf8BcECsXGYwKgCrwvqdUy8E0En
         Sl+Q==
X-Gm-Message-State: AOAM532q0aywi4VXFbZmj2c3vjEoPaXVHIO+uOWngn8GxsI0tJ0vzqBt
        +2lXGSgHSdiqC5K6gKlZAqjVjx3LRuAkMYJV
X-Google-Smtp-Source: ABdhPJy276nwM8yt2xKiF5GMzhYC1nOnAwf8JEe7zn3MsiykTSvZUM9t5uCjzkHDIzN5w22sMBNnZg==
X-Received: by 2002:aca:b1d7:: with SMTP id a206mr479853oif.60.1618253957539;
        Mon, 12 Apr 2021 11:59:17 -0700 (PDT)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id 103sm2493345otj.41.2021.04.12.11.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 11:59:16 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     stable@vger.kernel.org
Cc:     tseewald@gmail.com,
        --reply-to=20210410004930.17411-1-tseewald@gmail.com,
        Shuah Khan <skhan@linuxfoundation.org>,
        Colin Ian King <colin.king@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
Date:   Mon, 12 Apr 2021 13:59:02 -0500
Message-Id: <20210412185902.27755-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.

Currently udc->ud.tcp_rx is being assigned twice, the second assignment
is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.

Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable <stable@vger.kernel.org>
Addresses-Coverity: ("Unused value")
Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/usb/usbip/vudc_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index f44d98eeb36a..51cc5258b63e 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
 
 		udc->ud.tcp_socket = socket;
 		udc->ud.tcp_rx = tcp_rx;
-		udc->ud.tcp_rx = tcp_tx;
+		udc->ud.tcp_tx = tcp_tx;
 		udc->ud.status = SDEV_ST_USED;
 
 		spin_unlock_irq(&udc->ud.lock);
-- 
2.20.1

