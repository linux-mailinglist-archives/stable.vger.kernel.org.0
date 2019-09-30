Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19C0C290B
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 23:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfI3Vpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 17:45:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43345 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfI3Vpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 17:45:41 -0400
Received: by mail-pl1-f194.google.com with SMTP id f21so4393849plj.10
        for <stable@vger.kernel.org>; Mon, 30 Sep 2019 14:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ruDqNKuGSU2nVlbiXjG0y95FwzvT0teQMa8Utr4bjY=;
        b=mz2RyE2T1EEgFtF2UoSk0GlId6YYMtxfaH0WZSz1pBxbMFDcZJgaudo+MEtEnhYd47
         kpdtaTObWcCO5VnWRUNVW6cbxu9RyElOZc7C7kZx2scjX/MBTERcMog61yB/thr8wR0e
         gZbmsHTqrvMCEE/LZfgDFzGnE/5BLJT3GzjBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ruDqNKuGSU2nVlbiXjG0y95FwzvT0teQMa8Utr4bjY=;
        b=ePiFpV1yWgbyfTMkocBQtYBs1X6xpxa4cFpRdW718S3Wr/O7RgJ5EsgoajZmU5hZNx
         dmnBUa+iTr4FT6gNzh5Rl6h0nMp7NruJxdYGd8So4k6JuEzCJr45nagATSZ/EBbPPZV6
         ZQjGu011TIg2V7tZ2XYetVyAahMFNQvBdRNxIEGdC49y/dzUp6PN9UK6Hdv26mMcJt7l
         vMR7uRa7OqbY6z3SOJZ3p6OvYl2+XnnAo6jZEMt+lJ3F0cTkBKrSNfSXsaS6+yMkKJB0
         hpCDZl4Hn0A5DkQDB+Qnxs6fwkaEP4TjSKiTHhXJHSEEmDhBhaI3ydSTz9pXx6Xg33SG
         +8mQ==
X-Gm-Message-State: APjAAAXHggFH7mJNDBqF4LhHD4+GKjy4nH1hI3D4TavnWWGaEknfxpyr
        6v5K30RvASqrDRZ0CX68oGGMoQ==
X-Google-Smtp-Source: APXvYqxnFdaDxDxYpbu8HAxNuStIYedtTAtZN+OLvOJowJsm2okX8LAbs9bA+tVGyBnqbwGoCdrzDg==
X-Received: by 2002:a17:902:9684:: with SMTP id n4mr23179781plp.14.1569879940623;
        Mon, 30 Sep 2019 14:45:40 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id r185sm13893394pfr.68.2019.09.30.14.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 14:45:39 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hung-Te Lin <hungte@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Guenter Roeck <groeck@chromium.org>
Subject: [PATCH] firmware: google: increment VPD key_len properly
Date:   Mon, 30 Sep 2019 14:45:22 -0700
Message-Id: <20190930214522.240680-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 4b708b7b1a2c ("firmware: google: check if size is valid when
decoding VPD data") adds length checks, but the new vpd_decode_entry()
function botched the logic -- it adds the key length twice, instead of
adding the key and value lengths separately.

On my local system, this means vpd.c's vpd_section_create_attribs() hits
an error case after the first attribute it parses, since it's no longer
looking at the correct offset. With this patch, I'm back to seeing all
the correct attributes in /sys/firmware/vpd/...

Fixes: 4b708b7b1a2c ("firmware: google: check if size is valid when decoding VPD data")
Cc: <stable@vger.kernel.org>
Cc: Hung-Te Lin <hungte@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/firmware/google/vpd_decode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/google/vpd_decode.c b/drivers/firmware/google/vpd_decode.c
index dda525c0f968..5c6f2a74f104 100644
--- a/drivers/firmware/google/vpd_decode.c
+++ b/drivers/firmware/google/vpd_decode.c
@@ -52,7 +52,7 @@ static int vpd_decode_entry(const u32 max_len, const u8 *input_buf,
 	if (max_len - consumed < *entry_len)
 		return VPD_FAIL;
 
-	consumed += decoded_len;
+	consumed += *entry_len;
 	*_consumed = consumed;
 	return VPD_OK;
 }
-- 
2.23.0.444.g18eeb5a265-goog

