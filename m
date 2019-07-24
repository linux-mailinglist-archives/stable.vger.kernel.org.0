Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DED73DCD
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391197AbfGXTrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:47:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33055 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391186AbfGXTrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 15:47:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id f20so12494656pgj.0
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 12:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d+g/CVDDe6lBhitrwf0p1AVCDLXIza7GgdLv5G5rGBQ=;
        b=Ry15thyxO+qEHeX3A7H4d3046HlgvQwv7DrTLIdooSku2s5oV/JD/3aSPlCFSkhfNm
         BZBHdboUeWjI8os3SSePn+p9YwkbM2vVf5daTCPRlTS0IbG9FHPBCFXWS235e/8suW/e
         oh3SbJ1bN5kg1lamTYuqWq24ui76z0iEsZYdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d+g/CVDDe6lBhitrwf0p1AVCDLXIza7GgdLv5G5rGBQ=;
        b=e6fL+C1l/42rOsQXstpifeF7fLDmNR8mWGS2nUc/spmfT8Fhnn9a0GK0Dkdj4cuX8L
         StvQmMWYn51N9+h8Q6bTau2nQ+kjK58nHQ3ZuekbFdlaxHiXStF3J2858TElpMVE7shm
         NUGPH7c6t+OELUkGhHxzlH6Q0FXomN42rG+BB/oBbFsCFAyvjvF6PadFDkcseFhAecVO
         adS3e+au4nVJIzTvTDhsrs7L17IE7oX7e0lUEV2APSHG1vVyMq/6DfmvMfoiTGJ5eHSo
         7xMZvrXKjndkTnkogLfS5ww0Zf3WKCKy3mZM3wTpkG8GtK6cJzrBnFfMzTXmghjCdMIL
         q8oA==
X-Gm-Message-State: APjAAAWByyj4wjHQFknYFut3p6MdkSGaV1CkUklnC3+1bTGd/bgZ6q1y
        BMeN2qj5sncXX02RMn/5lw9cDQ==
X-Google-Smtp-Source: APXvYqyP16x2iGwpIlzIeQw77qWct3WHjt+nequp2zIzVsOfzCvJFuoXqx/5RSrVAR3R0U0+hJWs0Q==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr86633772pjb.138.1563997626076;
        Wed, 24 Jul 2019 12:47:06 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id k5sm36971202pjl.32.2019.07.24.12.47.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 12:47:05 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH 5.3] mwifiex: fix 802.11n/WPA detection
Date:   Wed, 24 Jul 2019 12:46:34 -0700
Message-Id: <20190724194634.205718-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant
vendor IEs") adjusted the ieee_types_vendor_header struct, which
inadvertently messed up the offsets used in
mwifiex_is_wpa_oui_present(). Add that offset back in, mirroring
mwifiex_is_rsn_oui_present().

As it stands, commit 63d7ef36103d breaks compatibility with WPA (not
WPA2) 802.11n networks, since we hit the "info: Disable 11n if AES is
not supported by AP" case in mwifiex_is_network_compatible().

Fixes: 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant vendor IEs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.h | 1 +
 drivers/net/wireless/marvell/mwifiex/scan.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 3e442c7f7882..095837fba300 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -124,6 +124,7 @@ enum {
 
 #define MWIFIEX_MAX_TOTAL_SCAN_TIME	(MWIFIEX_TIMER_10S - MWIFIEX_TIMER_1S)
 
+#define WPA_GTK_OUI_OFFSET				2
 #define RSN_GTK_OUI_OFFSET				2
 
 #define MWIFIEX_OUI_NOT_PRESENT			0
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 0d6d41727037..21dda385f6c6 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -181,7 +181,8 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC)) {
-		iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
+		iebody = (struct ie_body *)((u8 *)bss_desc->bcn_wpa_ie->data +
+					    WPA_GTK_OUI_OFFSET);
 		oui = &mwifiex_wpa_oui[cipher][0];
 		ret = mwifiex_search_oui_in_ie(iebody, oui);
 		if (ret)
-- 
2.22.0.657.g960e92d24f-goog

