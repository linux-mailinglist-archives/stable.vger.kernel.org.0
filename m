Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE4541881E
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 12:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhIZKfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 06:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhIZKfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 06:35:05 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB048C061570;
        Sun, 26 Sep 2021 03:33:28 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d6so42163620wrc.11;
        Sun, 26 Sep 2021 03:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OrqH5IhJDnI7HeFnItr1cUdMgxdvHJZQ3QI6ktAUmKE=;
        b=ifGObEysSyJTZSEsULqqwgB4rD87Xw5T/9K4kiIjpBZSyNUOAEs2Rs+T3r8TxaYD8R
         zDH9ZPKYWBPH/AIn31iMkbDfn/sR2sBkmnM4OZGEi7avHCnqeCn4c7h1ANM2KprHKMx4
         HcmAMOLkCc9y5MR69adER5Ic0uAy/nnAqfQvCGrCZygzOaD2YsH4wemih2h9nsc3Im1s
         T4m+SxcX80Oanv/7CEiBOwWmyeFn25mCE+tM3DryEYd18DyHM2Wzcp7+AjC//H35j3jM
         Z0ziA29YHt1CTxR2W2cBLR1CqwEJeYE5UIQ//n6UqZFOHQ0Topg9IRaNleLop+UptHNd
         MnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OrqH5IhJDnI7HeFnItr1cUdMgxdvHJZQ3QI6ktAUmKE=;
        b=J8dfmLFZtLcJ0GLIi2dtDSzCq2VrFeJ06Y4EYevlaMdlnCYCWT9BBaBrKJhqTai+5t
         eq+6CWbq+WnS41APum3Q8zvP+wIggHKziKyJYvdFq2mD1hwuPOgaNjf8lVOSzleRsAlE
         qJslecT6VELsUdhZ9tdc1GUIbo4nwbN9kXkNRHJGcecnQw1pjKlqL3pRgrmT35KJGlY/
         ifSSoQvyBmweTkiOgt+F3n3Quv4XfxmwAEK2RmbLYKw2/n+AIHRc1lPs1HKJ/gSksLg3
         ueIQW7sMFqYtDWyfkTolGVC2eh2kqP7q3tOoPMwgRQ0lUXgFPX0m4WsMN8b6NBMu6NzD
         W0ow==
X-Gm-Message-State: AOAM5306gwKHsvWVXA8Nli8wOzLclC+14jLWVDSAzO4hmYffEueAolwq
        AUHFghu/ORpRUAgG4lUolSE9k+lmEDTm6zdZ
X-Google-Smtp-Source: ABdhPJwIdselwj9HIuzXQEFEgXbDxRWdk+K+a84cQGuRi6rTyVbJlk6kSYrKMGD9F/1TJtzuou/LIw==
X-Received: by 2002:a5d:6392:: with SMTP id p18mr21123616wru.372.1632652407192;
        Sun, 26 Sep 2021 03:33:27 -0700 (PDT)
Received: from mkuron-mbp-m1.home.kuron-germany.de (i5DB53509.pool.tripleplugandplay.com. [93.181.53.9])
        by smtp.gmail.com with ESMTPSA id i27sm18007690wmb.40.2021.09.26.03.33.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Sep 2021 03:33:26 -0700 (PDT)
From:   Michael Kuron <michael.kuron@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Michael Kuron <michael.kuron@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] media: dib0700: fix undefined behavior in tuner shutdown
Date:   Sun, 26 Sep 2021 12:31:04 +0200
Message-Id: <20210926103104.1792-1-michael.kuron@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a problem where closing the tuner would leave it in a state
where it would not tune to any channel when reopened. This problem was
discovered as part of https://github.com/hselasky/webcamd/issues/16.

Since adap->id is 0 or 1, this bit-shift overflows, which is undefined
behavior. The driver still worked in practice as the overflow would in
most environments result in 0, which rendered the line a no-op. When
running the driver as part of webcamd however, the overflow could lead to
0xff due to optimizations by the compiler, which would, in the end,
improperly shut down the tuner.

The bug is a regression introduced in the commit referenced below. The
present patch causes identical behavior to before that commit for adap->id
equal to 0 or 1. The driver does not contain support for dib0700 devices
with more adapters, assuming such even exist.

Tests have been performed with the Xbox One Digital TV Tuner on amd64. Not
all dib0700 devices are expected to be affected by the regression; this
code path is only taken by those with incorrect endpoint numbers.

Cc: stable@vger.kernel.org
Fixes: 7757ddda6f4f ("[media] DiB0700: add function to change I2C-speed")
Signed-off-by: Michael Kuron <michael.kuron@gmail.com>
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 70219b3e8566..7ea8f68b0f45 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -618,8 +618,6 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 		deb_info("the endpoint number (%i) is not correct, use the adapter id instead", adap->fe_adap[0].stream.props.endpoint);
 		if (onoff)
 			st->channel_state |=	1 << (adap->id);
-		else
-			st->channel_state |=	1 << ~(adap->id);
 	} else {
 		if (onoff)
 			st->channel_state |=	1 << (adap->fe_adap[0].stream.props.endpoint-2);
-- 
2.30.1 (Apple Git-130)

