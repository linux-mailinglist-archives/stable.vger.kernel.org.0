Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B118D3EA082
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 10:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhHLIZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 04:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhHLIZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 04:25:03 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5D0C061765
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 01:24:38 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u3so9977125ejz.1
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 01:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0E/vbwx7PnVTaW/i9W1bqAmgVUxQr9vmSffqRRom5h4=;
        b=YvQptj8iwTiInbVdLjaaVHuPtyEgdWVuDMTPSl7EL4ULf7svk8NAsRSoyDNEuDo0yQ
         kJUw9O6jzigriZzrrsKqrocXLiPJVTYoxPVfI6/ahPWcg54jojukzBqHvdI7d//rJGEI
         UQS/xQS6yU2H0Izss+vjW8uu8uANCtJ1RnH2s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0E/vbwx7PnVTaW/i9W1bqAmgVUxQr9vmSffqRRom5h4=;
        b=o/PW6xvKEMWho0OSfh/NHWQDV0vUrHE9nQK8iuUMv1jxK6HmEWRm/DNFe5Q64x/kSg
         oFnsHXCiNPHbZaU3UAb8jmpODpIbnBYUUvNgif2NDclcF2S33tgH3OZPw3nJIRgFHiGG
         RdJ4K2QmFmi2SZMPDvISaiByTAaOPsnpVbwtyTGNJTwREoV9KMaoeG5cMpMyBteuyoiB
         p0ygAvQ0VlOoY1+FdRarP2KpZt2Rxx8YTnLm+e9gamSZ63rL2/AX1cfkXgIUOEV18sKQ
         osHKK0KNNfQMXxT2hyvlauMiY/RvLa45exQrqrAJjeiNIvYcBT25AypL8Odak7bRDZUZ
         gpkw==
X-Gm-Message-State: AOAM532o+Be8/NXFT/MGIibfFc3/SOXkcFMxa1khIg7bIn5uwuJyRsIq
        ZJg1XkVDR/7uK8oEXGRzb/RqBA==
X-Google-Smtp-Source: ABdhPJwYqBxHMVhEkSUleMSRb0fugm6fyfTgh++akaCC7gnKWpZdesPZjDN8zrZpliyfPmpuPRhvsw==
X-Received: by 2002:a17:906:5909:: with SMTP id h9mr2469624ejq.329.1628756676958;
        Thu, 12 Aug 2021 01:24:36 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id v24sm783165edt.41.2021.08.12.01.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:24:36 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     paskripkin@gmail.com, stable@vger.kernel.org, davem@davemloft.net,
        Petko Manolov <petko.manolov@konsulko.com>
Subject: [PATCH] net: usb: pegasus: ignore the return value from set_registers();
Date:   Thu, 12 Aug 2021 11:23:51 +0300
Message-Id: <20210812082351.37966-1-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The return value need to be either ignored or acted upon, otherwise 'deadstore'
clang check would yell at us.  I think it's better to just ignore what this
particular call of set_registers() returns.  The adapter defaults are sane and
it would be operational even if the register write fail.

Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
---
 drivers/net/usb/pegasus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 652e9fcf0b77..49cfc720d78f 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -433,7 +433,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 	data[2] = loopback ? 0x09 : 0x01;
 
 	memcpy(pegasus->eth_regs, data, sizeof(data));
-	ret = set_registers(pegasus, EthCtrl0, 3, data);
+	set_registers(pegasus, EthCtrl0, 3, data);
 
 	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
 	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
-- 
2.30.2

