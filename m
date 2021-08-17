Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4183EEE0F
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 16:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhHQOGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 10:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhHQOGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 10:06:51 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEC3C061764
        for <stable@vger.kernel.org>; Tue, 17 Aug 2021 07:06:18 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id q3so27648028edt.5
        for <stable@vger.kernel.org>; Tue, 17 Aug 2021 07:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CdDL5AuT3Bs0uFae8Pg/Ul5HRY3EkJ1Dqs4rzwcsJNI=;
        b=U8jX7z3CrDDp6+F52kbHN8E+HQApjRmNj03u4ddDW7emK+K1DpHAM20Q0uh4VI2yLt
         Bk0nQHabyZVWT9bOC9Zm/jXq3CZAY2BKtPPZoiewzlfQpAuzpTd8NN2e0ayGHocPBMoZ
         1C8rXhbpS1qpy8IVLqApcOreIJkIHqI03lKmI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CdDL5AuT3Bs0uFae8Pg/Ul5HRY3EkJ1Dqs4rzwcsJNI=;
        b=C1DOQwj7sHICnhhCQ2Sx6s+hRsnDkiQQFHoAMIVLJg6gXeaaarCyXsxC0AfOq9iPo0
         5+pGWx3REQaOh047RRRIMR+0wF7ul/2uLY+C/K/LBBYKXdNqtxlXsz+O0WWG/Oj+IRIM
         XjPvZBl0O1KRbxwMVixd6C4ybIffW1ET1FAAdWwvuStW5M6gEeOe4pSvE8BiI8rSCmTI
         M+4Yg/vmVKm0668ILC84pvzRGUGHi6+Cp1kG5PbbUrlPSpNPMARJQDeHMRGoaNT8Tvmf
         Y0ubwVwYv9ZftX7OkIoksy22T+bjc11piG8VWiHONPWBE7k0ozVC4IGCQ/ErHuP4UkU7
         HKrQ==
X-Gm-Message-State: AOAM532kYWN7W0ac7xEXbTbcOKAZTzIZaxB/kwQNxfFNlo+MrFhMU7E/
        FKtmCJwguLWitKKnzi7MylBI7g==
X-Google-Smtp-Source: ABdhPJzSjBuN+jxgZf6yvGFsuGAaS9DCypuWJ1WYJ+UN9KZRPzkm7P/DK0cfCxZSeAyJFq/BNyg4JA==
X-Received: by 2002:a05:6402:4406:: with SMTP id y6mr4252518eda.242.1629209177007;
        Tue, 17 Aug 2021 07:06:17 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id cn16sm1130702edb.9.2021.08.17.07.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 07:06:16 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, paskripkin@gmail.com, stable@vger.kernel.org,
        davem@davemloft.net, Petko Manolov <petko.manolov@konsulko.com>
Subject: [PATCH] net: usb: pegasus: fixes of set_register(s) return value evaluation;
Date:   Tue, 17 Aug 2021 17:06:13 +0300
Message-Id: <20210817140613.27737-1-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  - restore the behavior in enable_net_traffic() to avoid regressions - Jakub
    Kicinski;
  - hurried up and removed redundant assignment in pegasus_open() before yet
    another checker complains;
  - explicitly check for negative value in pegasus_set_wol(), even if
    usb_control_msg_send() never return positive number we'd still be in sync
    with the rest of the driver style;

Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
---
 drivers/net/usb/pegasus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 652e9fcf0b77..1ef93082c772 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -446,7 +446,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 		write_mii_word(pegasus, 0, 0x1b, &auxmode);
 	}
 
-	return 0;
+	return ret;
 fail:
 	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 	return ret;
@@ -835,7 +835,7 @@ static int pegasus_open(struct net_device *net)
 	if (!pegasus->rx_skb)
 		goto exit;
 
-	res = set_registers(pegasus, EthID, 6, net->dev_addr);
+	set_registers(pegasus, EthID, 6, net->dev_addr);
 
 	usb_fill_bulk_urb(pegasus->rx_urb, pegasus->usb,
 			  usb_rcvbulkpipe(pegasus->usb, 1),
@@ -932,7 +932,7 @@ pegasus_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	pegasus->wolopts = wol->wolopts;
 
 	ret = set_register(pegasus, WakeupControl, reg78);
-	if (!ret)
+	if (ret < 0)
 		ret = device_set_wakeup_enable(&pegasus->usb->dev,
 						wol->wolopts);
 	return ret;
-- 
2.30.2

