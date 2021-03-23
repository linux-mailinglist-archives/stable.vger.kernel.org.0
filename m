Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE8A345D00
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 12:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCWLfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 07:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhCWLe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 07:34:57 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38ED1C061574;
        Tue, 23 Mar 2021 04:34:57 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so954874pjb.1;
        Tue, 23 Mar 2021 04:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ElLOWUMualAIIWBPGGWJKeUgzwjaNX2HQui1EmZiBWc=;
        b=afnufsrSRgnVzKen0KAipeY2Gr5RB2YrUx3TRVnXnNLcuks/zuGRd8sJUVkJLRebIm
         9T9R9lfv2O/j0Lx1Eop4fg3WZwlp9vsYAHSHl3UjGDK3qJsXIg/ufdkQVYpGgfQW6ZBP
         v4zAUJUr22QHF7kZB0TRveNn6O3DvtfY+M/l8qwXoa5JsUp1ys7OXvBYthrMIk9DEu6i
         3sBAZXIPLXYcHkeAbWIL1QvpKClaFylFtfK3eX5a81cSXfVRbA2GQoyZUS4e6USJ4wFx
         xttZTf71IwhuMgQEu4ZxEO0bBI8i+3sxJQZuArTRbuWXBz4BiLSSWX/YcFcae1ilwHn7
         pZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ElLOWUMualAIIWBPGGWJKeUgzwjaNX2HQui1EmZiBWc=;
        b=VVUPKDMTSoJXvCt6gRsRC3VBvEd7kOTlwFX6OlFrqcc1NkKNT5f6SaUD/mY34fibE3
         79kGJWyqnC1Vy/NRI2I0pz/gOG1JsZFKdZ/V/aKB01UvNNbjwX9co63oCynHSMneiQet
         GWsW0ppKMCXR9KJu++l6mQK7uth+RDRK+NIkNPcSHU1LeLSA41k6OsWD/KXcWUtgJnlg
         mij2V5IRGn4toCiOoJPQxNpZpffmdRCN2tA8sjhAEtxHINYZBsY/64QjEB7YELZr1I5x
         uJ+HBthrLRSp+8YLambDh/sgs9SAT3HF6Ka4fTUMuCuKXVIEbpg+gp7CKZuHOS4m2kCB
         nhqQ==
X-Gm-Message-State: AOAM533d+DHFfJqc4tWcErR4Q+fxrO2qdbkiMRGEP2J2dfp6Ty6dbqWR
        vwEZFbR887QL0A8FH+++/tw=
X-Google-Smtp-Source: ABdhPJxrc64WnAAp3j44E1M3MpoM2k95vp5z1QbiTFPkZ+hE99kiQmRIJxH9dFqDMRVYDGafdJjHUQ==
X-Received: by 2002:a17:90a:bf0a:: with SMTP id c10mr3993377pjs.195.1616499296743;
        Tue, 23 Mar 2021 04:34:56 -0700 (PDT)
Received: from localhost.localdomain ([122.174.244.83])
        by smtp.gmail.com with ESMTPSA id l22sm2750385pjl.14.2021.03.23.04.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 04:34:56 -0700 (PDT)
From:   Atul Gopinathan <atulgopinathan@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] staging: rtl8192e: Fix incorrect source in memcpy()
Date:   Tue, 23 Mar 2021 17:04:12 +0530
Message-Id: <20210323113413.29179-1-atulgopinathan@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The variable "info_element" is of the following type:

	struct rtllib_info_element *info_element

defined in drivers/staging/rtl8192e/rtllib.h:

	struct rtllib_info_element {
		u8 id;
		u8 len;
		u8 data[];
	} __packed;

The "len" field defines the size of the "data[]" array. The code is
supposed to check if "info_element->len" is greater than 4 and later
equal to 6. If this is satisfied then, the last two bytes (the 4th and
5th element of u8 "data[]" array) are copied into "network->CcxRmState".

Right now the code uses "memcpy()" with the source as "&info_element[4]"
which would copy in wrong and unintended information. The struct
"rtllib_info_element" has a size of 2 bytes for "id" and "len",
therefore indexing will be done in interval of 2 bytes. So,
"info_element[4]" would point to data which is beyond the memory
allocated for this pointer (that is, at x+8, while "info_element" has
been allocated only from x to x+7 (2 + 6 => 8 bytes)).

This patch rectifies this error by using "&info_element->data[4]" which
correctly copies the last two bytes of "data[]".

NOTE: The faulty line of code came from the following commit:

commit ecdfa44610fa ("Staging: add Realtek 8192 PCI wireless driver")

The above commit created the file `rtl8192e/ieee80211/ieee80211_rx.c`
which had the faulty line of code. This file has been deleted (or
possibly renamed) with the contents copied in to a new file
`rtl8192e/rtllib_rx.c` along with additional code in the commit
94a799425eee (tagged in Fixes).

Fixes: 94a799425eee ("[PATCH 1/8] rtl8192e: Import new version of driver from realtek")
Cc: stable@vger.kernel.org
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
---
 drivers/staging/rtl8192e/rtllib_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 8415f26fd4c0..6e48b31a9afc 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -1965,15 +1965,15 @@ static void rtllib_parse_mife_generic(struct rtllib_device *ieee,
 
 	if (info_element->len > 4 &&
 	    info_element->data[0] == 0x00 &&
 	    info_element->data[1] == 0x40 &&
 	    info_element->data[2] == 0x96 &&
 	    info_element->data[3] == 0x01) {
 		if (info_element->len == 6) {
-			memcpy(network->CcxRmState, &info_element[4], 2);
+			memcpy(network->CcxRmState, &info_element->data[4], 2);
 			if (network->CcxRmState[0] != 0)
 				network->bCcxRmEnable = true;
 			else
 				network->bCcxRmEnable = false;
 			network->MBssidMask = network->CcxRmState[1] & 0x07;
 			if (network->MBssidMask != 0) {
 				network->bMBssidValid = true;
-- 
2.25.1

