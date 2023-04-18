Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C986E66B9
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjDROKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjDROKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:10:00 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40CC9EC7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:09:58 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bi21-20020a05600c3d9500b003f17a8eaedbso846096wmb.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826997; x=1684418997;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DaVOZl+7O+99BrhjGzp5w68A+JQvSRP5ru4XXDIkAJY=;
        b=yG+Lcy2qIWzOlZbGfIxkibxCHQqUseoBlhC+WSM9KYQudKnTIqNs7kpRy4jCOK7Edg
         rTqRY0gABTEJUeuvkwj0rWQf2SLC7ZNmTIi2CDnwUKpbXt23M3OA/XICzmjA6KpjrNEL
         eg+QQNmWMpuUQklLVBUr4dttcK9pm78ThwNqOT92RLj4vDbQqJrh4QLuTFbdQrVq47c7
         QDtE5lEfJ/GdMxWBQ/ELThn0z1XgTAN6tBaRRZw+bI0uv2hs0vufqDghlcUPd9MRi4CL
         h3Gsb73os3v/LOtGW8rFVpxVG1lX6qBdN+ewR5vlfz2vafWJfLY9SnczS1HTeVkIQ1wZ
         aBkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826997; x=1684418997;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DaVOZl+7O+99BrhjGzp5w68A+JQvSRP5ru4XXDIkAJY=;
        b=V/1gCasKFwzP3Eqlh8VIDIY7kY/3tMi8JyvLWL38jNgodKsBnKYV5LwZ3F8WipF+Fb
         f7YhAegf2+Sd7IvBBjXdFTR2mYpeKuTg1uZUBYyXYclyI7DEvNday8Fzyj3coNg6QPuI
         xVGJgJCY0qGSM4mxp11cHSFYha8+Cv1FNpiIAvC2mLEFYzL4u9Gz1WncBq7mLN5VtSff
         zo0OWYS4fgMvVN9+3Io7TMczGG0+CarXnGQEHDowlw6RYWx9eU3G/TYUEvNRsONMF7Ge
         AqL9SQQDICtu1/hTiecQSfq/kv2EB+9nR69ssRWNpvPZSM5SQXrw3eLACAqt0Dyd649r
         w3Ew==
X-Gm-Message-State: AAQBX9cM8jh1aLMEXFmMGapCfojqDdxc1bzffkvDcF3XSUERUi+w4yR2
        OVSVObOh0wWzVWnutqHE4rycRooI6NNAT8zHA1g=
X-Google-Smtp-Source: AKy350YHVmd75cFPyIym/PDMDaWBcoKI5VrTLV76ffhBN2Efwjp1UPt1EgJiPRyRN9CBLQ+opf+CYA==
X-Received: by 2002:a05:600c:2351:b0:3f1:7b48:87b4 with SMTP id 17-20020a05600c235100b003f17b4887b4mr1187996wmq.32.1681826997452;
        Tue, 18 Apr 2023 07:09:57 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm7978018wmq.30.2023.04.18.07.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:09:57 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH v2 RESEND 00/10] Backport uclamp vs margin fixes into 5.10.y
Date:   Tue, 18 Apr 2023 15:09:33 +0100
Message-Id: <20230418140943.90621-1-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is just a resend of

	https://lore.kernel.org/stable/20230318173943.3188213-1-qyousef@layalina.io/

Changes in v2:
	* Fix compilation error against patch 7 due to misiplace #endif to
	  protect against CONFIG_SMP which doesn't contain the newly added
	  field to struct rq.

Commit 2ff401441711 ("sched/uclamp: Fix relationship between uclamp and
migration margin") was cherry-picked into 5.10 kernels but missed the rest of
the series.

This ports the remainder of the fixes.

Based on 5.10.172.

NOTE:

a2e90611b9f4 ("sched/fair: Remove capacity inversion detection") is not
necessary to backport because it has a dependency on e5ed0550c04c ("sched/fair:
unlink misfit task from cpu overutilized") which is nice to have but not
strictly required. It improves the search for best CPU under adverse thermal
pressure to try harder. And the new search effectively replaces the capacity
inversion detection, so it is removed afterwards.

Build tested on (cross compile when necessary; x86_64 otherwise):

	1. default ubuntu config which has uclamp + smp
	2. default ubuntu config without uclamp + smp
	3. default ubunto config without smp (which automatically disables
	   uclamp)
	4. reported riscv-allnoconfig, mips-randconfig, x86_64-randocnfigs

Tested on 5.10 Android GKI kernel and android device (with slight modifications
due to other conflicts on there).

Qais Yousef (10):
  sched/uclamp: Make task_fits_capacity() use util_fits_cpu()
  sched/uclamp: Fix fits_capacity() check in feec()
  sched/uclamp: Make select_idle_capacity() use util_fits_cpu()
  sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()
  sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
  sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early
    exit condition
  sched/fair: Detect capacity inversion
  sched/fair: Consider capacity inversion in util_fits_cpu()
  sched/uclamp: Fix a uninitialized variable warnings
  sched/fair: Fixes for capacity inversion detection

 kernel/sched/core.c  |  10 +--
 kernel/sched/fair.c  | 183 ++++++++++++++++++++++++++++++++++---------
 kernel/sched/sched.h |  70 ++++++++++++++++-
 3 files changed, 217 insertions(+), 46 deletions(-)

-- 
2.25.1

