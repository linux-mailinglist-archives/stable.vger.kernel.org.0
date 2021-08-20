Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7B53F2719
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 08:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbhHTG6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 02:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238418AbhHTG6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 02:58:37 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2BDC061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 23:57:59 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id by4so12599144edb.0
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 23:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vktROwdfT/2W3HLGzWkFifgLXqdoBqZ18sow34pIXJc=;
        b=sN6fC/++0BAFLYXaTS0QbiVZEEevvpfvw9hqYlfpbsDBZIdSdQDF/ZZakZj3RX8Ysm
         iCH/USyAdh6h1p1xUn6806Rs9YoBrCvk7HMiuhil0Br5SmX1k6SBLRxygKY3/9X5u9lf
         3czYGOOkRjjKDbZ7PPYyVhsviXZ+acAcfQib8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vktROwdfT/2W3HLGzWkFifgLXqdoBqZ18sow34pIXJc=;
        b=VaVjf4vBSldhqRFTk0VXtA6IFHQ+sDvmZw01If9SJkLslO8f6D/zzTL5NH+1Ne5M0Z
         9x+efRe1FhrSQ2jUjW23skZYnCLlHWOdM3aCSPHjxZfMrfhvaNSluaH/aDZD2dWIZ8ja
         AbeqdX5vSNOdrigZqshK8gf/a65EeDEZXSfi2RihnYXA/SDUv67xMN9Mj6c7iWbFy328
         XaPZqVIVEOEhToss24aRGZ7lLEuVnrkQuD+JGRHvl1FANHSrU40/w67H0gwi0NHPAawe
         6gf9zvx5B2EcXwFlj4Htc/lJMbpicug2UXQpeMRhdTmzoaefoQKK7FTNBqbjlAkqj+g8
         ELzA==
X-Gm-Message-State: AOAM531sIHTwjkGS30+zbcbOaWqjHAwmy+XoasO9B1LbHX0ojyKeqZ5h
        P1K97GXq9GEu8u+Mzvvn/Q+M4w==
X-Google-Smtp-Source: ABdhPJwsRnKJaYTjDWrtS6drI4s2jw3vNhBvYSf0AABuBHXvET7UJEQjIMwXbfgajRxhPiSwakGE0g==
X-Received: by 2002:aa7:c0c6:: with SMTP id j6mr9439846edp.146.1629442678056;
        Thu, 19 Aug 2021 23:57:58 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id z6sm2984637edc.52.2021.08.19.23.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 23:57:57 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org, Petko Manolov <petko.manolov@konsulko.com>
Subject: [PATCH v2] net: usb: pegasus: fixes of set_register(s) return value evaluation;
Date:   Fri, 20 Aug 2021 09:57:53 +0300
Message-Id: <20210820065753.1803-1-petko.manolov@konsulko.com>
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

Fixes: 8a160e2e9aeb ("net: usb: pegasus: Check the return value of get_geristers() and friends;")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
---
 drivers/net/usb/pegasus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 652e9fcf0b77..9f9dd0de33cb 100644
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
-- 
2.30.2
