Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90917111C60
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbfLCWnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:43:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728475AbfLCWnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:43:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DADF20803;
        Tue,  3 Dec 2019 22:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413002;
        bh=fTap50hOM9PnZz9jwJ7d7gNLsTKF+xqDJGkeYz8Vz6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQEPpgHb5znYilXwouZqxqIcIY5w4b4OBusJU0MUvqpKbK6YMXxzcSEqnOyAxpFi9
         6x/3d+FmIZA+S6XeNiw4xCZ7JlSp5Xn26yq4esU5oZYpGeYPHpJ+7djLWo/QT8x0kW
         f671tUlEzXxYqYBdOEUue/NDQx9V4EME2H+6/EbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 5.3 099/135] staging: wilc1000: fix illegal memory access in wilc_parse_join_bss_param()
Date:   Tue,  3 Dec 2019 23:35:39 +0100
Message-Id: <20191203213039.028949888@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

commit c7e621bb981b76d3bfd8a595070ee8282ac4a32b upstream.

Do not copy the extended supported rates in 'param->supp_rates' if the
array is already full with basic rates values. The array size check
helped to avoid possible illegal memory access [1] while copying to
'param->supp_rates' array.

1. https://marc.info/?l=linux-next&m=157301720517456&w=2

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1487400 ("Memory - illegal accesses")
Fixes: 4e0b0f42c9c7 ("staging: wilc1000: use struct to pack join parameters for FW")
Cc: stable@vger.kernel.org
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Link: https://lore.kernel.org/r/20191106062127.3165-1-ajay.kathat@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wilc1000/wilc_hif.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/staging/wilc1000/wilc_hif.c
+++ b/drivers/staging/wilc1000/wilc_hif.c
@@ -477,16 +477,21 @@ void *wilc_parse_join_bss_param(struct c
 		memcpy(&param->supp_rates[1], rates_ie + 2, rates_len);
 	}
 
-	supp_rates_ie = cfg80211_find_ie(WLAN_EID_EXT_SUPP_RATES, ies->data,
-					 ies->len);
-	if (supp_rates_ie) {
-		if (supp_rates_ie[1] > (WILC_MAX_RATES_SUPPORTED - rates_len))
-			param->supp_rates[0] = WILC_MAX_RATES_SUPPORTED;
-		else
-			param->supp_rates[0] += supp_rates_ie[1];
+	if (rates_len < WILC_MAX_RATES_SUPPORTED) {
+		supp_rates_ie = cfg80211_find_ie(WLAN_EID_EXT_SUPP_RATES,
+						 ies->data, ies->len);
+		if (supp_rates_ie) {
+			u8 ext_rates = supp_rates_ie[1];
 
-		memcpy(&param->supp_rates[rates_len + 1], supp_rates_ie + 2,
-		       (param->supp_rates[0] - rates_len));
+			if (ext_rates > (WILC_MAX_RATES_SUPPORTED - rates_len))
+				param->supp_rates[0] = WILC_MAX_RATES_SUPPORTED;
+			else
+				param->supp_rates[0] += ext_rates;
+
+			memcpy(&param->supp_rates[rates_len + 1],
+			       supp_rates_ie + 2,
+			       (param->supp_rates[0] - rates_len));
+		}
 	}
 
 	ht_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, ies->data, ies->len);


