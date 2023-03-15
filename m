Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FC96BB166
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjCOM1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjCOM0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A0D77E2D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3201061D49
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470C5C433D2;
        Wed, 15 Mar 2023 12:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883153;
        bh=y53Ujcfmhrnz1WE6AZYTw70nFJZNtSTvP6L9YrDW0nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRvXIJy334WXNtFKc8uM5dN0xAhJEfuZJYYLlenHHVZjDLwjJIiSQLMahc4opnkKn
         TCOE7QQjVAaIiK1lzTeN5L+E0qpo5WvOpKZQJJOqOTZT+eqY5ahqeOn5yAJxUwwyIy
         YQPltyc4XgZ8cPcd3/hAUi5dgX4Fs10cY8o57uVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 008/145] staging: rtl8723bs: Pass correct parameters to cfg80211_get_bss()
Date:   Wed, 15 Mar 2023 13:11:14 +0100
Message-Id: <20230315115739.265193255@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit d17789edd6a8270c38459e592ee536a84c6202db upstream.

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
Link: https://lore.kernel.org/r/20230306153512.162104-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -358,7 +358,7 @@ int rtw_cfg80211_check_bss(struct adapte
 	bss = cfg80211_get_bss(padapter->rtw_wdev->wiphy, notify_channel,
 			pnetwork->mac_address, pnetwork->ssid.ssid,
 			pnetwork->ssid.ssid_length,
-			WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+			IEEE80211_BSS_TYPE_ANY, IEEE80211_PRIVACY_ANY);
 
 	cfg80211_put_bss(padapter->rtw_wdev->wiphy, bss);
 
@@ -1239,8 +1239,8 @@ void rtw_cfg80211_unlink_bss(struct adap
 
 	bss = cfg80211_get_bss(wiphy, NULL/*notify_channel*/,
 		select_network->mac_address, select_network->ssid.ssid,
-		select_network->ssid.ssid_length, 0/*WLAN_CAPABILITY_ESS*/,
-		0/*WLAN_CAPABILITY_ESS*/);
+		select_network->ssid.ssid_length, IEEE80211_BSS_TYPE_ANY,
+		IEEE80211_PRIVACY_ANY);
 
 	if (bss) {
 		cfg80211_unlink_bss(wiphy, bss);


