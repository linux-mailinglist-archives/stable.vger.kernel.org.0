Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25416B0E4F
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCHQPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCHQPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:15:31 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3687410420
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:15:30 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id p16so10136714wmq.5
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JaJhrQVIlWswjYEXLHqG/SrK6Z+JO3tCXTUikzqyaCc=;
        b=cVbIzuihUgmsdt8tuREPD6DGAKNVpd2k+X3NAOujFFiQiPT+zDx3q2k7MFmbQ3ni0Z
         mVNXBPKaLEBuJV7cKAIQUrfFqB8FRkKJwYp90304De1bO7NmRU8cnKBxuJj2Ygjnw4Nt
         DMtJrcmW60mSE+pwPb7Pk2nI/oyUBhtym+bfYBPaIkARuZlK1EJDDn7wJo+kJqxi6ZJi
         v6vlFYPGSf4z3ln4E6+egT3jxnTUsdhDuU0TU0+m410jwKt0xg9xYFXUk+EloDyHsv4D
         ZdidaPA54MHu95L1cS0bWfdH5qihPI5btJhVZ+GQcAkQh1uH5yVdssWMwwaGEzzPhe80
         BAZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JaJhrQVIlWswjYEXLHqG/SrK6Z+JO3tCXTUikzqyaCc=;
        b=n6PkmFvtc05Qsw6sPNV10VYill2PvA01E/DcUYy1OKIQTo5Zf2f/VzOyDpV447AiaC
         mgPSQg63zFQ28lNwHNjKebxVgbf+NeHI5nu6Htk+OKab6L7veFo4Mi+nfSDUpwj4u0GE
         K13cBIVXz9NCAtO0mYYoKO9fEpz52IFTBwevbS/A4kxNEwFjmZUXm6QPOBDn8nlLhLeI
         Emu/MWc2lFhMQxstcZ2Y/oCXj3ixlaYBr3cDeIdw1rt8M7cBMbMdJ7Vo8Zdd4F5ddris
         lH5tjNFOZRhKJ575iduE+P5u1WoqffsFSGolTTj2q7dMJVO0viURdENf+H/VlLKLscSI
         GJZQ==
X-Gm-Message-State: AO0yUKWJtcT5EhKymsxrabDuZjzezjZ1o+Fuwazp5z8LzGcHrg0FS430
        aG3we1wVVIECbqGEoCxsspXyqGkkZ+4IQMGcFiE=
X-Google-Smtp-Source: AK7set9FXA8+hMyzlUqwuyjqo5zrZzfoRu9WNnnQA+zS5cmQuGa0HYXR/FUBfevQoUT9cu4oFnukPQ==
X-Received: by 2002:a05:600c:45d2:b0:3df:e6bb:768 with SMTP id s18-20020a05600c45d200b003dfe6bb0768mr16827842wmo.24.1678292128706;
        Wed, 08 Mar 2023 08:15:28 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id h19-20020a05600c30d300b003db06224953sm15632583wmn.41.2023.03.08.08.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:15:27 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 00/10] Backport uclamp vs margin fixes into 5.10.y
Date:   Wed,  8 Mar 2023 16:12:55 +0000
Message-Id: <20230308161305.2881766-1-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 2ff401441711 ("sched/uclamp: Fix relationship between uclamp and
migration margin") was cherry-picked into 5.10 kernels but missed the rest of
the series.

This ports the remainder of the fixes.

Based on 5.10.172.

Build tested on x86 with and without uclamp config enabled.

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

