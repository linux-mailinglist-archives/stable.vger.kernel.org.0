Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71354318F4
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 14:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhJRMYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 08:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhJRMYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 08:24:13 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97747C06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 05:22:02 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e3so40766302wrc.11
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 05:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Tsy0ou00jA9sgdD3QEDwwcOaq6zikEvYydKUg/U2lOI=;
        b=tL4VHalKBtDnJmE/VJ+Mhf0hiohhiXU/SvdITVRh47oKKhPg6qptsGcIfSyxZYnb6h
         Yu9Lxv4hXlNmEzDzvgiPJZVccK/oLo9uFgp/t3tdR6o/NRVl0nNE2Cr1CHmJbEPD0ntG
         pxdasCLszZ2eCwKDACJTEUhMi2Zf5eqd4SVnzDnziRh3LHRTzFXQKKn/LHfz4srVphxI
         c2Jx4jfuDHQbDJqwCFQ3EJUyZOtWP3+fpt5DIEndHdpH2OWGlooM532MEezKve1F5CTF
         WNHIsN0wz9U4N+2PutWxEIHpdgIMTQyl2yk4milADMbGvOLvO0QCCFysb3Jf+sP0vR9c
         hlXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Tsy0ou00jA9sgdD3QEDwwcOaq6zikEvYydKUg/U2lOI=;
        b=qXSrmErQhbcu4LCEfp3ded5DNxIekvZ7R8Fv/8YcUnROc2YWKZwVPIy52gI31E6aLZ
         4j9O7mX6UfWVtRuRHryl2iFKhEmamY+vM19srrRXLDZFb3CP5qTyAf2wilWXxdU0AwvJ
         4LGZlo86BXWntQ5jW1wkrDArEQoRJx3PoJnTIy8eotBpXEF50yKQXgv3gYDixEAKJXHB
         LJyWic3Oh43s/aQsfqR6sxQo3jv+95m1ruT7fnTWflzkUiI8+uFSPos35hed2xxNgN4N
         scU3Pc7L4cNY273iHPquz/RsjO2D2Rrfw6OR2Q0S0PWLJiJhStmuGQP+wZ1tKuwsxP4I
         p3Bw==
X-Gm-Message-State: AOAM533i9ucdxpQNlRx7cbT/+CyRX5iLUbtLoXRo2WNq9tPV3+hOIGEv
        kQ312EPnv2GRZL1mSY7mwvEbgw==
X-Google-Smtp-Source: ABdhPJxfXaof1I8NpiW93+giTN7/+c8qgc+weYNHGpnx1w2xIphm4XKvToGE6SyhhCovA1AIxtuPlw==
X-Received: by 2002:adf:ab58:: with SMTP id r24mr34816657wrc.200.1634559721105;
        Mon, 18 Oct 2021 05:22:01 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:9df5:c752:530b:345b])
        by smtp.gmail.com with ESMTPSA id s3sm12327725wrm.40.2021.10.18.05.22.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Oct 2021 05:22:00 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        bryan.odonoghue@linaro.org, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] wcn36xx: Fix (QoS) null data frame bitrate/modulation
Date:   Mon, 18 Oct 2021 14:33:19 +0200
Message-Id: <1634560399-15290-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We observe unexpected connection drops with some APs due to
non-acked mac80211 generated null data frames (keep-alive).
After debugging and capture, we noticed that null frames are
submitted at standard data bitrate and that the given APs are
in trouble with that.

After setting the null frame bitrate to control bitrate, all
null frames are acked as expected and connection is maintained.

Not sure if it's a requirement of the specification, but it seems
the right thing to do anyway, null frames are mostly used for control
purpose (power-saving, keep-alive...), and submitting them with
a slower/simpler bitrate/modulation is more robust.

Cc: stable@vger.kernel.org
Fixes: 512b191d9652 ("wcn36xx: Fix TX data path")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index ef1b133..ce4f631 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -535,6 +535,7 @@ static void wcn36xx_set_tx_data(struct wcn36xx_tx_bd *bd,
 	if (ieee80211_is_any_nullfunc(hdr->frame_control)) {
 		/* Don't use a regular queue for null packet (no ampdu) */
 		bd->queue_id = WCN36XX_TX_U_WQ_ID;
+		bd->bd_rate = WCN36XX_BD_RATE_CTRL;
 	}
 
 	if (bcast) {
-- 
2.7.4

