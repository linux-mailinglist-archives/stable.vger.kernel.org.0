Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD79C52E36B
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 05:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiETD6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 23:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiETD6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 23:58:00 -0400
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE62B41FB;
        Thu, 19 May 2022 20:57:59 -0700 (PDT)
Received: by mail-wm1-f44.google.com with SMTP id bg25so3885533wmb.4;
        Thu, 19 May 2022 20:57:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pNHvSj7Qlaisn5x9H/7CDWdcNlvF8ouTuEdsvQFM/ZA=;
        b=8ImggjWuyOVusKMfYPBklOm88M8uLHN9SLGFLfPTA93qT1VQjQPWma7pxmWZ5jfnPi
         p2jHeGoKIJj7oRD3F+KwIbJBfI4K7TEbxzlF7NNIXkYV99sZLXZlB1dG6XvUhYtYsR6q
         QAdLKFOlAPLwnrYXNcH7t1JSMERxQIyCocVwsXBns4JCIe5rd654O4XOcejq7AwtvGwI
         CMjj3v2ECaUTHK3SMK4Qce/E4j0Gv+ibRmEDdaluHJnoGau/daH/GsXAgCwxxpf80TeO
         okZS/d6sdCVP+F3oQx7GP5Sb8dAgOaCY4k/6PMyFGxyEbDZMneRGmsdiRwpQ1if3gzTg
         x2mw==
X-Gm-Message-State: AOAM5304Be7pA1lfP1VJudrsBLL9SwMJm3GjNowQZQZKgECNzzSbll6z
        uujJicNRLw8HAzEv/2+lBDS1ZvOfW3w=
X-Google-Smtp-Source: ABdhPJwEnqc3qcnxLHbZP1A2PzFVsK+V1WqW5Vkp1tqMoVO29pwCKaxpouzu2iQPE6xw046SLF/fTw==
X-Received: by 2002:a05:600c:3b0a:b0:394:6373:6c45 with SMTP id m10-20020a05600c3b0a00b0039463736c45mr6731690wms.69.1653019078230;
        Thu, 19 May 2022 20:57:58 -0700 (PDT)
Received: from localhost.localdomain ([94.205.35.240])
        by smtp.googlemail.com with ESMTPSA id z17-20020a05600c03d100b0039732f1b4a3sm1146878wmd.14.2022.05.19.20.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 20:57:57 -0700 (PDT)
From:   "Denis Efremov (Oracle)" <efremov@linux.com>
To:     gregkh@linuxfoundation.org
Cc:     "Denis Efremov (Oracle)" <efremov@linux.com>,
        Larry.Finger@lwfinger.net, phil@philpotter.co.uk,
        dan.carpenter@oracle.com, straube.linux@gmail.com,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH v5.10] staging: rtl8723bs: prevent ->Ssid overflow in rtw_wx_set_scan()
Date:   Fri, 20 May 2022 07:57:30 +0400
Message-Id: <20220520035730.5533-1-efremov@linux.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <YoZk3YLEDYKGG5xe@kroah.com>
References: <YoZk3YLEDYKGG5xe@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This code has a check to prevent read overflow but it needs another
check to prevent writing beyond the end of the ->Ssid[] array.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index 902ac8169948..083ff72976cf 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -1351,9 +1351,11 @@ static int rtw_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 
 					sec_len = *(pos++); len -= 1;
 
-					if (sec_len > 0 && sec_len <= len) {
+					if (sec_len > 0 &&
+					    sec_len <= len &&
+					    sec_len <= 32) {
 						ssid[ssid_index].SsidLength = sec_len;
-						memcpy(ssid[ssid_index].Ssid, pos, ssid[ssid_index].SsidLength);
+						memcpy(ssid[ssid_index].Ssid, pos, sec_len);
 						/* DBG_871X("%s COMBO_SCAN with specific ssid:%s, %d\n", __func__ */
 						/* 	, ssid[ssid_index].Ssid, ssid[ssid_index].SsidLength); */
 						ssid_index++;
-- 
2.35.3

