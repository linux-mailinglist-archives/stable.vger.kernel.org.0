Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7273464B77A
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 15:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbiLMOgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 09:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiLMOgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 09:36:07 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2646319
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 06:36:03 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id u19so18465848ejm.8
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 06:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:from:to:cc:subject:date:message-id:reply-to;
        bh=3KSo9ppIdG6X2IRIV3Is6pnJ2EnoDBDtdV9Y5rl06s4=;
        b=Y/9tXyeq5qgBjgpkb1GkdhHeISWU7Xv9O8zF73Tj2sQ8bYqGdkXOiIIMxx+m4d4Ja1
         16wdaza8wUVWtxuM3pcV+zwa7hqvmJeDrfQCYuI26NK6U7tbj60k+UREYSrOou8QsNO0
         Vs0b910kHmMPjKRwUbOqUv3H6s6lNWp9UMveA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3KSo9ppIdG6X2IRIV3Is6pnJ2EnoDBDtdV9Y5rl06s4=;
        b=y4ds6QYQP86j/kd+Gl/PoyDy/ZoLUukfJJbMqnMr+3JCkG9pFJBY/ydWeN9999ysN4
         gO3rCaxUgazIV6P5dWATzAEb6HSREbP0w0indcf/9t8iQDFxKYrE3ijYGlomKF+QjTvo
         siSyzdKo00gpk4TXjxhT/HiLc3vXnq9/2U+WcipbnYgRaI/a++GQL8nGahhwWNVQ1wiv
         83BDLtuW8x6qZiviG6BJKskRQTADj/59y3dKIh2RoQG0YvsUfJ8FbgWA6UkVkfOG0lkW
         6dwxZSFpLGxhrT9iqoEfwz6VhQzbTWlva3EOAqvm+oAai2xIpzSDR/FYrI3aqfbhwY1H
         8YXA==
X-Gm-Message-State: ANoB5pmSL975WB7qcMnTvTMakR2R+19SwzZDffWsqiCCqHGHYuXyrbPM
        ug+93RmbfVm2g27pSym8r5IIlw==
X-Google-Smtp-Source: AA0mqf7L4q7Q0AJq1ykGpUHG03QcWOsXVm0QhgmrgWarGnIBpfHiHuhZG3wfzDV501QiKR2PwgJPjg==
X-Received: by 2002:a17:907:d408:b0:7c1:d4c:f08c with SMTP id vi8-20020a170907d40800b007c10d4cf08cmr16735972ejc.4.1670942161961;
        Tue, 13 Dec 2022 06:36:01 -0800 (PST)
Received: from alco.roam.corp.google.com ([100.104.168.209])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b00781dbdb292asm4613960ejc.155.2022.12.13.06.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 06:36:01 -0800 (PST)
Subject: [PATCH v2 0/2] uvc: Fix race condition on uvc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALGNmGMC/22MwQrCMBBEf6Xs2ZUmxbZ68j/EQ7pdm0CbwMYGpO
 TfXTzLHIY3zMwBmSVwhltzgHAJOaSoYE8NkHdxYQyzMtjWWqPCvRCKI8b2aoeeXT9OrxG0PrnMOI
 mL5HUQ93XV0If8TvL53Rej9vjzVAy2SBfLZhg76sx8Jy9pC/t2TrLAs9b6BazsgwqoAAAA
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Tue, 13 Dec 2022 15:35:29 +0100
Message-Id: <20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org>
To:     Max Staudt <mstaudt@google.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Yunke Cao <yunkec@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ricardo Ribalda <ribalda@chromium.org>
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=1169; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=2Bhn1vCFMeNrxtBx4BsUuNf1hQMq9VedOxEASLCByKY=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjmI3DX7TUa1eGQvH/LR3y+nk6vN2kPSoNUfGSuDhI
 EGpQlFOJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY5iNwwAKCRDRN9E+zzrEiO8pD/
 46Uhh+cZQgbrVOWB+pBrJsfshUnnO6L5MTkdUHsNaGsAZ6wB5x/H38ja7XhCpj5rr1Dew+YM7NJhz5
 IU4UPRLzMKIFe09H8LUO62FJ/e5FQ2UYOyiSJz5tmPZ6pOV96iCMwJavzv1pD5kUt8wg/SHBHoGmhG
 S2rY193NwrwKSZ2NF8H2OOc//5CTtAd/HfzvGhPUwXv1M8AiGRmSaKFrOKHVCTgPakc0U/R55iWb+1
 zh8igTHykHL4372J0R/gbFbLx5QWytkWBmRw21NAPckfQSwLcJY9RctnhZm0Wky7Ltww9qBfrx9iNu
 GHkBM/pBj3OQTVJQtlCga+hmeRU40cux2QXHGQlpW9BTS77Cs9PBrK09AbmuVw33sLDAm7W0/1iDfY
 0kkZ0IRjIRdCxQeNuztDkwd7JdI0fu9Hb9B/pDxDcyS74ODE25YOrI0AmnC1ZW/KLG7grx8iIx9uUZ
 whJquYIl4odBjqW8sUNN+//4GW6pDaDBtAWugSRWy78dy+4BKQ67sgQcWu0cKckQY8y+GPZafz93NA
 mzfO3N0vcC7+QNGa0GNYSjy4tTJX0yHu5sfOTbVs+RqgifpplC/pQf+7es8RC7UlY1nn9JD/4N6q/s
 GuLmsaeQYWQRg88NHmI+dZZbGXXdAdQxBisDa4QTok/UdQeS/GdL0kJCbwew==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that all the async work is finished when we stop the status urb.

To: Yunke Cao <yunkec@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Max Staudt <mstaudt@google.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

---
Changes in v2:
- Add a patch for not kalloc dev->status
- Redo the logic mechanism, so it also works with suspend (Thanks Yunke!)
- Link to v1: https://lore.kernel.org/r/20221212-uvc-race-v1-0-c52e1783c31d@chromium.org

---
Ricardo Ribalda (2):
      media: uvcvideo: Fix race condition with usb_kill_urb
      media: uvcvideo: Do not alloc dev->status

 drivers/media/usb/uvc/uvc_ctrl.c   |  3 +++
 drivers/media/usb/uvc/uvc_status.c | 15 +++++++--------
 drivers/media/usb/uvc/uvcvideo.h   |  3 ++-
 3 files changed, 12 insertions(+), 9 deletions(-)
---
base-commit: 0ec5a38bf8499f403f81cb81a0e3a60887d1993c
change-id: 20221212-uvc-race-09276ea68bf8

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
