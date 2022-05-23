Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688F1531CD1
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242079AbiEWRx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244896AbiEWRwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:52:42 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996545D5C9;
        Mon, 23 May 2022 10:41:58 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u3so22435638wrg.3;
        Mon, 23 May 2022 10:41:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ua1KG5+18UaDCNZFTJYl8j8EfhH8Jue+YMkQxpze3FM=;
        b=Sdz2gbs7o9fmuAj7XPQKKfEVW+WF2BtEoCvdTcZXSOCVyvuqfPCQYBWcMDJ3jRT6JV
         6Uu0Pc5R/37kWFz5guNRCA8Xtzx5VF6dpcTPguyHafKHMDrR6ybS5um+YTFAt38mVU96
         RRwhnnts4z3QOAAn4/V6MjlGqn2As7r208T4DHvlJq5bd0eWxS9d3kXAeIDqhr/sH7uM
         ECjJs6+SK5CnE9mG9xIb/1NkHBg4awuxG8lzvCBNG/FNEl8Drq8gyCsX7yoqiGZteSD5
         Ykl8DzPXfKrnENYc1E64cIggTTU+QFJaWUJ1g5pXHMyoe850xO8MePojCXv9VQvSkKTd
         8ygQ==
X-Gm-Message-State: AOAM531a8bLtVhBz9pjnIeXdm4jWHo6TzFYmhnwn7O+bDkNFwIHMBL2c
        B0GUy0dX/qaDHJI6b0rEKtU=
X-Google-Smtp-Source: ABdhPJxCnDyHcwKiqN87su/K7JV25u7QznK3u4WJ7C556Si7ECVW2PYU+dvPeWktzLbqMV+ExD3CUg==
X-Received: by 2002:a05:6000:18ab:b0:20c:8d82:52c3 with SMTP id b11-20020a05600018ab00b0020c8d8252c3mr19720747wri.701.1653327611353;
        Mon, 23 May 2022 10:40:11 -0700 (PDT)
Received: from localhost.localdomain ([94.205.35.240])
        by smtp.googlemail.com with ESMTPSA id o8-20020a1c7508000000b003942a244f2fsm9444242wmc.8.2022.05.23.10.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 10:40:10 -0700 (PDT)
From:   "Denis Efremov (Oracle)" <efremov@linux.com>
To:     gregkh@linuxfoundation.org
Cc:     "Denis Efremov (Oracle)" <efremov@linux.com>,
        Larry.Finger@lwfinger.net, phil@philpotter.co.uk,
        dan.carpenter@oracle.com, straube.linux@gmail.com,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH v5.4-v4.14] staging: rtl8723bs: prevent ->Ssid overflow in rtw_wx_set_scan()
Date:   Mon, 23 May 2022 21:39:43 +0400
Message-Id: <20220523173943.12486-1-efremov@linux.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <YoZk3YLEDYKGG5xe@kroah.com>
References: <YoZk3YLEDYKGG5xe@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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
index d8d44fd9a92f..ea2fd3a73c3a 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -1351,9 +1351,11 @@ static int rtw_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 
 					sec_len = *(pos++); len-= 1;
 
-					if (sec_len>0 && sec_len<=len) {
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
2.36.1

