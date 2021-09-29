Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFC341CCCC
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 21:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344584AbhI2Tri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 15:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344548AbhI2Trh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 15:47:37 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE16C06161C;
        Wed, 29 Sep 2021 12:45:55 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id e15so15360813lfr.10;
        Wed, 29 Sep 2021 12:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UnUfHc5j9QIw/2Dtg2ID4k2lM7bfzKchSEUnnCdyvX8=;
        b=bSZCEAYmzhEE0RUUylCd7e3a3wvOzZwMmhunr8VpWVmGKIhA/zWB89IpMhngvCyfJ9
         J7s2YnMYqKtIMxESPwcoBA+XTGK5MmC2rPqG7BqlFUHu7AOZDvJErtS9hBg8rUqQCWxh
         0vbjoIlG6qrDDjRU1LTWmQkRDgu3hf+V5qwSElML/Fk8juc0HeH8xhHA9hQidZiTcqFV
         XzHSeO1PNNUcivlIVnCbrgdYdu8XKej5PRc6PCNHyMyOwG7DXsocnOy6EjBQ1EfWqbe9
         qKXs7y82GShzIwoDGgHDYKGe2txSjhas/K+Ez1pVk5ipvW6a2FoLqGmBhHo/fSsxBh3E
         +99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UnUfHc5j9QIw/2Dtg2ID4k2lM7bfzKchSEUnnCdyvX8=;
        b=NeVCIgkLrkjARnRLiRYcXWKuth7HSthYyNEi+7FLjVKt6A/yviaQ6GwolllEGQ5fxn
         +U8TQzVoG/OlK0h69gnEZSWMQufz9P2U01/WBopapqCLN7uyaMSpTaOTQ/COoUiZZ35M
         BXGQGFhnmVxs6HmBzRB+CWaM6Msm1NO88kwssogYYEXMMQv+0mGKymaE6MfVxwwJmUdM
         +Gtg6tpzlMw2Sv8JUFwF+5YqErz1ZjoZWoigCxoAnq/ppcDykIGohvBxj5xBcC//CGNE
         Ao2IvTJgvPOSg6w1i46tXZIbsN2SdY0PuyLbmRVcN6bHGGaOSw2ouH8teqc9Qc9dbCyN
         AuZw==
X-Gm-Message-State: AOAM530/4776TviCu26D+g93J9Z/mqpR02ej1JL7vJokRCExGmSRuzjo
        jZCWs1z5FX7fG/N8c8JngR4=
X-Google-Smtp-Source: ABdhPJzbYJD0+CFHHnIcgHhiiSshWSe7W9yhR9Uor6rRL+9FN1V2qt7DfMKJ+j3H6fNh4gzzXxH6xA==
X-Received: by 2002:ac2:5617:: with SMTP id v23mr1530410lfd.114.1632944753757;
        Wed, 29 Sep 2021 12:45:53 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-228-193.NA.cust.bahnhof.se. [98.128.228.193])
        by smtp.gmail.com with ESMTPSA id v27sm104607lfp.0.2021.09.29.12.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 12:45:53 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Junlin Yang <yangjunlin@yulong.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH V2 1/2] usb: cdc-wdm: Fix check for WWAN
Date:   Wed, 29 Sep 2021 21:45:46 +0200
Message-Id: <20210929194547.46954-2-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929194547.46954-1-rikard.falkeborn@gmail.com>
References: <20210929194547.46954-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CONFIG_WWAN_CORE was with CONFIG_WWAN in commit 89212e160b81 ("net: wwan:
Fix WWAN config symbols"), but did not update all users of it. Change it
back to use CONFIG_WWAN instead.

Fixes: 89212e160b81 ("net: wwan: Fix WWAN config symbols")
Cc: <stable@vger.kernel.org>
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
Changes:
V1-V2: Use ifdef instead of IS_ENABLED


 drivers/usb/class/cdc-wdm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 35d5908b5478..fdf79bcf7eb0 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -824,7 +824,7 @@ static struct usb_class_driver wdm_class = {
 };
 
 /* --- WWAN framework integration --- */
-#ifdef CONFIG_WWAN_CORE
+#ifdef CONFIG_WWAN
 static int wdm_wwan_port_start(struct wwan_port *port)
 {
 	struct wdm_device *desc = wwan_port_get_drvdata(port);
@@ -963,11 +963,11 @@ static void wdm_wwan_rx(struct wdm_device *desc, int length)
 	/* inbuf has been copied, it is safe to check for outstanding data */
 	schedule_work(&desc->service_outs_intr);
 }
-#else /* CONFIG_WWAN_CORE */
+#else /* CONFIG_WWAN */
 static void wdm_wwan_init(struct wdm_device *desc) {}
 static void wdm_wwan_deinit(struct wdm_device *desc) {}
 static void wdm_wwan_rx(struct wdm_device *desc, int length) {}
-#endif /* CONFIG_WWAN_CORE */
+#endif /* CONFIG_WWAN */
 
 /* --- error handling --- */
 static void wdm_rxwork(struct work_struct *work)
-- 
2.33.0

