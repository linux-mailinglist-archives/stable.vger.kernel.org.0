Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA806E669C
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjDROF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjDROF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:05:58 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEBC83D4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:05:56 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bi21-20020a05600c3d9500b003f17a8eaedbso837938wmb.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826755; x=1684418755;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WNtRhYEOCFjpiraq216z8+zMUSqLx7hSiAR/ThfRN6s=;
        b=dUQyvWhZ+Syr/c+IHqKO++Wj+idUHzb5aT/2voEVe5Gux4Rfm+g459qhq8hG9QgvcL
         rnP9U4gTBASfxBx2SHYJfY238ly+E58aftCFNoTZPhlRcjv4L+3JqCVMDC58/M0exb1s
         40iN/za1Pml4Ujbny381DsLqgCKvPbKCtBYlkAf+mRzuDItnT2afYwL/CB9KE+nl+fs0
         yjes4omelaZpPWyzt6tX8byxo/x7/r6yRE/w4rczUn9eEdsLUwUsH93eHvblE4en2oTc
         L8HCDudf2PPiwoTSioDJ5rymi4WZEAxNNAmdxodJbRPdwEqXJTLRvslzwlDdeJwq8Gj/
         f3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826755; x=1684418755;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WNtRhYEOCFjpiraq216z8+zMUSqLx7hSiAR/ThfRN6s=;
        b=e/+xR8CNxH8Uel5oSMbyCTNh0To5J29ExiMiQWZ2deiHJU+dL2litB1TWo0699kNNa
         C+ejUUosk4sT+cw8krnXDqozFZimnmkKULCF74kMkfOJDiCRr/nbF6srxViKCW0Ctf7i
         OCIts2vUulRz7l8PCF7owW3U5wZYgxyi0ACXb6q66DFvszwS74sWyINHGEI5VkmOSzhC
         13U+ZKcqBjssVKjMWKMEmiyfvsGNk5LyY5kema2JBix/6gnml6HpScZLsKBAuwQ5fx6O
         EVRPG/sHw58MB3b4j8Wh0wXvu52Yh6f9ArXkTHAspwfBq/CEKWwAVWxHe9SIk9GMTEpV
         WFHQ==
X-Gm-Message-State: AAQBX9cc7c0VDMaIMUdcMFjZHuHV0o1PplIePjRAYqc6PycWWM3q005Z
        Buir9x0qasIghtpHtMEaesTQwEYLkRKHdLd2ifw=
X-Google-Smtp-Source: AKy350aRdxBSEWQoSTdPBgQYoCKLPvNuXxHgBA+/TOUCY3g/Q0CV5f47AxowxHPMDtvJlaXOzb9i0Q==
X-Received: by 2002:a7b:c84c:0:b0:3f1:6ef5:b444 with SMTP id c12-20020a7bc84c000000b003f16ef5b444mr7469775wml.40.1681826755326;
        Tue, 18 Apr 2023 07:05:55 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c210900b003f17c1384c4sm571420wml.12.2023.04.18.07.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:05:54 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH RESEND 0/7] Backport uclamp vs margin fixes into 5.15.y
Date:   Tue, 18 Apr 2023 15:05:40 +0100
Message-Id: <20230418140547.88035-1-qyousef@layalina.io>
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

This is a resend of

	https://lore.kernel.org/stable/20230308162207.2886641-1-qyousef@layalina.io/

Which was dropped because of build errors on 5.10 equivalent backport.
I extended the testing to make sure this series is not impacted like 5.10
backport. And update the cover letter to clarify there's no need to take
further backports which removes capacity inversion detection.



Portion of the fixes were ported in 5.15 but missed some.

This ports the remainder of the fixes.

Based on 5.15.98.

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

Boot tested on android 5.15 GKI with slight modifications due to other
conflicts there. I need more time to be able to do full functional testing on
5.15 - but since some patches were already taken - posting the remainder now.

Sorry due to job/email change I missed the emails when the other backports were
partially taken.

Qais Yousef (7):
  sched/uclamp: Fix fits_capacity() check in feec()
  sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
  sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early
    exit condition
  sched/fair: Detect capacity inversion
  sched/fair: Consider capacity inversion in util_fits_cpu()
  sched/uclamp: Fix a uninitialized variable warnings
  sched/fair: Fixes for capacity inversion detection

 kernel/sched/core.c  |  10 ++--
 kernel/sched/fair.c  | 128 +++++++++++++++++++++++++++++++++++++------
 kernel/sched/sched.h |  61 ++++++++++++++++++++-
 3 files changed, 174 insertions(+), 25 deletions(-)

-- 
2.25.1

