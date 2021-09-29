Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E43141C576
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 15:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344130AbhI2NX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 09:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344061AbhI2NX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 09:23:59 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9379C06161C;
        Wed, 29 Sep 2021 06:22:17 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id i4so10776270lfv.4;
        Wed, 29 Sep 2021 06:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W5CDoiyQWe3fkMo95Qs0HrnoAnDkKKLh5LYjCOQ+FI0=;
        b=YBdn70PJp+h6ggqq7zYZftlvdTqQ5wPr4nDDKavtdJz7WBlnJKF+beU6whg8AJ7/K9
         ibeKWqouQxHFbRxs8aMfcmg/WKia7GqP2Bj4PQD87cdaQSLCyhc9/y6TLcgK0KwPNL2l
         uxZIS5nmLVgBrZrzzWEEfplGAqATQ6wDWEtq2PD1ts2annoYJp3QH9EKvG57etVegWqB
         j2jNViKe3Q55tPQNJBil+UKBgViC9cH+sheZNuwD9Y6+JeJb0U09N+Ri2ec+E3c+CtWA
         2cHnb9i+5PnqV6NFTmf4DnuZZl295ZVgvVuD7ZWCAf4YhOpBc3MuKG98eI4IqeOIgsjW
         V/xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W5CDoiyQWe3fkMo95Qs0HrnoAnDkKKLh5LYjCOQ+FI0=;
        b=fS2I84YiKyYG9E+FUwy3m72RHKgNboeoQOh4mxUfK+niPqtJvASKHF3dEixIpfulsS
         4M1sD/7LFu/cM/svDocPLqHYq7s6bx3on8lGWBulWlTQSfaXmhtEyRPc47VIdhp34ULf
         S7vMT4Ybpa0O8llBwcpzMBoz3MH2/FhQlJQm5AF56A03GqmQYqpAFuviUn9cbm3h4xD1
         eCdYPWycWVwtYFkfO6wU57vzxLtIBr0R9mhMXladD+P+h3ayxOIbCQ3ae3bREz69rJaa
         5va06lwhCNdS/2fUBsNkPBmmk1YSr8J0b+v/HD1twDEg0CDiJHYfg5VFZdnAVw4r+x/i
         Me1Q==
X-Gm-Message-State: AOAM533/3BvsGh45qfrsWrO9KpzCgYhMYxo+DLvkoQ+RjjHqwpOBkd33
        fd+U1p3nektHR8FrYE5tXa0=
X-Google-Smtp-Source: ABdhPJyivlM9SHwZKs0H3Uiy641Ghmodj1wwX81PFkfnRWng5DvuRVFYruRGPR4jmSnqClqsMn1DOg==
X-Received: by 2002:a2e:7c0a:: with SMTP id x10mr6065532ljc.455.1632921736376;
        Wed, 29 Sep 2021 06:22:16 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-228-193.NA.cust.bahnhof.se. [98.128.228.193])
        by smtp.gmail.com with ESMTPSA id z10sm283695ljc.117.2021.09.29.06.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 06:22:15 -0700 (PDT)
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
Subject: [PATCH 1/2] usb: cdc-wdm: Fix check for WWAN
Date:   Wed, 29 Sep 2021 15:21:42 +0200
Message-Id: <20210929132143.36822-2-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929132143.36822-1-rikard.falkeborn@gmail.com>
References: <20210929132143.36822-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 5c912e679506 ("usb: cdc-wdm: fix build error when CONFIG_WWAN_CORE
is not set") fixed a build error when CONFIG_WWAN was set but
CONFIG_WWAN_CORE was not. Since then CONFIG_WWAN_CORE was removed and
joined with CONFIG_WWAN in commit 89212e160b81 ("net: wwan: Fix WWAN
config symbols").

Also, since CONFIG_WWAN has class tri-state instead of bool, we cannot
check if it is defined directly, but have to use IS_DEFINED() instead.

Fixes: 5c912e679506 ("usb: cdc-wdm: fix build error when CONFIG_WWAN_CORE is not set")
Cc: <stable@vger.kernel.org>
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/usb/class/cdc-wdm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 35d5908b5478..03b25aaaa1dd 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -824,7 +824,7 @@ static struct usb_class_driver wdm_class = {
 };
 
 /* --- WWAN framework integration --- */
-#ifdef CONFIG_WWAN_CORE
+#if IS_ENABLED(CONFIG_WWAN)
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

