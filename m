Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC198D8A3
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfHNQ74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:59:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36032 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbfHNQ74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 12:59:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id w2so3111576pfi.3
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 09:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdsY+TwMaRiTwpzkwjPQil+R6RpRSkcrMD7hhV3dW5s=;
        b=Fq1vnLn1OPowYUeuAqOXi83q0uG6X/WQU74UnPqF1GT+1T2czvtYvxGMoLfQglqzPD
         pGjUaK6F/qaXu6nMwRN5id7RVLAQSETwKNh5EyLU8cUZ7r1iDUBeLYrEIekSV5wQR5w9
         ozqT4VvZlkql4Z9RKULyTq/RHz2Yepxv/mMNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdsY+TwMaRiTwpzkwjPQil+R6RpRSkcrMD7hhV3dW5s=;
        b=TwLlPDpMB1e3KVLB0Q2369aeYtztB4XAAze6npFGYXOODWPJWSslN4IqsmTYhJFTJk
         NyU2n7gFzAgT37zRGhsXgLC/e8vs23GlCjiPVFHAvFG7omZhj3yc3NzkjUHhZCHLtLlo
         glgu/nY7Vwtw3Yk502+bMVet2mo6DO/0iWeVpjWo4IIn5vrVkdrh26KvnEg4l9sI/pft
         HP1cDGXDzt/FxiKEqypvmAKj2kSmTQ/lJekW8j1nSq771eH/4RLFjiKjxCXzF2jRmJOh
         SqZ5iD+8dhS1s0D/kzHVLWbWvN3rs2jf3Dat5TDwrsgO3PYPkjP1dXnUzKv05KDIGBoN
         lTbQ==
X-Gm-Message-State: APjAAAV/ADC/UGu75b3yFEuXNASobiVxSv4KtoJzans+MAy3PmCKqrKt
        /VsQehkQpb9e07Txk/xHmSTW8KGFGtQ=
X-Google-Smtp-Source: APXvYqxYR0TYDwjtJbiRkcWOC7Is35yuPFLdXyK5QuBWSgUfHCHriTJVKrnfSO8ob1wJKE9t9Y5Oeg==
X-Received: by 2002:a63:e10:: with SMTP id d16mr146198pgl.444.1565801994831;
        Wed, 14 Aug 2019 09:59:54 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id b24sm383233pfd.91.2019.08.14.09.59.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 09:59:54 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     stable@vger.kernel.org
Cc:     kvalo@codeaurora.org, Brian Norris <briannorris@chromium.org>
Subject: [PATCH 4.4] mwifiex: fix 802.11n/WPA detection
Date:   Wed, 14 Aug 2019 09:59:14 -0700
Message-Id: <20190814165914.143238-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit df612421fe2566654047769c6852ffae1a31df16 ]

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/mwifiex/main.h | 1 +
 drivers/net/wireless/mwifiex/scan.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3959f1c97f4e..466ea4e551a6 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -108,6 +108,7 @@ enum {
 
 #define MWIFIEX_MAX_TOTAL_SCAN_TIME	(MWIFIEX_TIMER_10S - MWIFIEX_TIMER_1S)
 
+#define WPA_GTK_OUI_OFFSET				2
 #define RSN_GTK_OUI_OFFSET				2
 
 #define MWIFIEX_OUI_NOT_PRESENT			0
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 673ca812bd4c..b3fa3e4bed05 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -151,7 +151,8 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 	if (((bss_desc->bcn_wpa_ie) &&
 	     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id ==
 	      WLAN_EID_VENDOR_SPECIFIC))) {
-		iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
+		iebody = (struct ie_body *)((u8 *)bss_desc->bcn_wpa_ie->data +
+					    WPA_GTK_OUI_OFFSET);
 		oui = &mwifiex_wpa_oui[cipher][0];
 		ret = mwifiex_search_oui_in_ie(iebody, oui);
 		if (ret)
-- 
2.23.0.rc1.153.gdeed80330f-goog

