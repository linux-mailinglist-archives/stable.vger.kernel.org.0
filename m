Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50035560CDF
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 01:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiF2XAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 19:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiF2W7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 18:59:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE28940E46
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 15:58:49 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s6-20020a17090a760600b001ec3ace381bso398159pjk.5
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 15:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8z7eHNzBfwIuJwCaqp0hLyBEJakQJmDKDOySk1lfElA=;
        b=eUbZyr9mx264NFAW9qP8q5MAEgRHqfK3anwe0Dc6IZP2ewEvLqCfm5XeD3SqBPuHRs
         Z3DFo/8B71PWjvM7Sjd7EV6J4Ri36PXB8WjTA36Ijc2QEkc7patrc5xTB/g8L0UBAFqT
         eJU2mtgFdwsWAiV/MeqVvTFqX2q/ZiC+XX0ynNKA11nahSlv7rgGITwOL6spBMbdKbsZ
         h8v7EbauDRv+lffCvbNiJLm0YluRrrCyxahEIw5qTil54hs193V3pJTWXEkLWBdUSHW+
         w66B6USScOGYDqWNzX1qVAX3OZFPTNJ5XZFxCOUZ2sNQJVugTYXrtAbACF5c70mnpmP0
         kBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8z7eHNzBfwIuJwCaqp0hLyBEJakQJmDKDOySk1lfElA=;
        b=gmrtB3dPPBmulXHGLI3ChxfV+gcbkjhJldsrVLPF7rx1MTTbvbvmwCJU0mQWZbwX2K
         VyK3pq4nQAGYowTjLZYfL3GyyXhE4myIO2pvyUM00+bMXiXi1MnasbG8eQHSrd4hFdFP
         53nyxABmGaz4yTrpb2l4sPjsce+NlZAAZRfErBopAv0YMZU4wxfHRhpVWa+RWGsBAd7B
         ZDAuyZbwOFKDlnnQrWB6tCDC9JWybUWrMrd//+EEE+5kkFSeGOrYHDT+MqrnnWLeTRuz
         3A8I9DFpq5h+ytipKxUWAqRoGcAk9HJoyHou7McGHC1tWmlSSig4iC6Nj47/VLING/om
         NULw==
X-Gm-Message-State: AJIora9Ul5CQZc0KjynRHkFpolHj77OaN69HyOYdBxxfiFcRdX/ZFac8
        nSynqOZeTnJUP0l27g9KxDtljeELMXfU6OooIFPzMueVUqmr5za/XlWsltmQm4BS5vy0/A1mLX8
        hgKMh8au13R4w0yBTGP3YTgJs+IipNdA7kZDgddn8d1L04SQx0VgifBDqclyW8deAoRIDfMvvEn
        qWHg==
X-Google-Smtp-Source: AGRyM1sxAWgSTfU8h6zzPTVjW8sbDkhdxhC4OHr5/BcukTSsR5JtIFMQdh0mUZ7VmE/cPm/SDJkgsIXcnorKQHBuIuY=
X-Received: from willmcvicker.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:2dd0])
 (user=willmcvicker job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with
 SMTP id t9-20020a17090a024900b001e0a8a33c6cmr315pje.0.1656543528054; Wed, 29
 Jun 2022 15:58:48 -0700 (PDT)
Date:   Wed, 29 Jun 2022 22:58:40 +0000
Message-Id: <20220629225843.332453-1-willmcvicker@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 4.19 v1 0/2] Fixes for thermal hwmon registration
From:   Will McVicker <willmcvicker@google.com>
To:     stable@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     kernel-team@android.com, Will McVicker <willmcvicker@google.com>,
        linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

These two patches fix issues with thermal hwmon registration on 4.19.
The upstream commit ddaefa209c4a ("hwmon: Make chip parameter for
with_info API mandatory") forces the chip parameter to be mandatory
which breaks thermal subsystem devices from probing. These fixes were
pulled into 5.4, but missed from 4.19. I have verified them on Pixel
5 with the 4.19 kernel.

Thanks,
Will

Guenter Roeck (2):
  hwmon: Introduce hwmon_device_register_for_thermal
  thermal/drivers/thermal_hwmon: Use hwmon_device_register_for_thermal()

 drivers/hwmon/hwmon.c           | 25 +++++++++++++++++++++++++
 drivers/thermal/thermal_hwmon.c |  4 ++--
 include/linux/hwmon.h           |  3 +++
 3 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.37.0.rc0.161.g10f37bed90-goog

