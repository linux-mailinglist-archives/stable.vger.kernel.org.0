Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321126AC5C0
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 16:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjCFPnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 10:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjCFPn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 10:43:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B169B34F74
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 07:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678117315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vbLoWhVC0Gm7AQM0pGXliEzd5h+4F/nuusv9FlCwBVc=;
        b=e1XGS6BMZb336UKHs0LLE3bK8FLpqqlKjQrFPTseyc5Cw06LBCPr5zqBtv+oXiRCxO4+QB
        yEC1etW5r8VzMjWPR6A/CFK0cXBUEk0L5vFjku9xZOo8WFcqMh2smOC3l6gpyoiiO5hfqo
        FnU6PkNOhwGms5bd9z6AGJTYfatxgq8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-VMCbMNMfObe1aAvLg9J5Ew-1; Mon, 06 Mar 2023 10:35:24 -0500
X-MC-Unique: VMCbMNMfObe1aAvLg9J5Ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD77B85A588;
        Mon,  6 Mar 2023 15:35:16 +0000 (UTC)
Received: from x1.localdomain.com (unknown [10.39.193.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8FC9440DD;
        Mon,  6 Mar 2023 15:35:15 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        linux-staging@lists.linux.dev, stable@vger.kernel.org
Subject: [PATCH 2/2] staging: rtl8723bs: Pass correct parameters to cfg80211_get_bss()
Date:   Mon,  6 Mar 2023 16:35:12 +0100
Message-Id: <20230306153512.162104-2-hdegoede@redhat.com>
In-Reply-To: <20230306153512.162104-1-hdegoede@redhat.com>
References: <20230306153512.162104-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To last 2 parameters to cfg80211_get_bss() should be of
the enum ieee80211_bss_type resp. enum ieee80211_privacy types,
which WLAN_CAPABILITY_ESS very much is not.

Fix both cfg80211_get_bss() calls in ioctl_cfg80211.c to pass
the right parameters.

Note that the second call was already somewhat fixed by commenting
out WLAN_CAPABILITY_ESS and passing in 0 instead. This was still
not entirely correct though since that would limit returned
BSS-es to ESS type BSS-es with privacy on.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 3aba4e6eec8a..84a9f4dd8f95 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -350,7 +350,7 @@ int rtw_cfg80211_check_bss(struct adapter *padapter)
 	bss = cfg80211_get_bss(padapter->rtw_wdev->wiphy, notify_channel,
 			pnetwork->mac_address, pnetwork->ssid.ssid,
 			pnetwork->ssid.ssid_length,
-			WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+			IEEE80211_BSS_TYPE_ANY, IEEE80211_PRIVACY_ANY);
 
 	cfg80211_put_bss(padapter->rtw_wdev->wiphy, bss);
 
@@ -1139,8 +1139,8 @@ void rtw_cfg80211_unlink_bss(struct adapter *padapter, struct wlan_network *pnet
 
 	bss = cfg80211_get_bss(wiphy, NULL/*notify_channel*/,
 		select_network->mac_address, select_network->ssid.ssid,
-		select_network->ssid.ssid_length, 0/*WLAN_CAPABILITY_ESS*/,
-		0/*WLAN_CAPABILITY_ESS*/);
+		select_network->ssid.ssid_length, IEEE80211_BSS_TYPE_ANY,
+		IEEE80211_PRIVACY_ANY);
 
 	if (bss) {
 		cfg80211_unlink_bss(wiphy, bss);
-- 
2.39.1

