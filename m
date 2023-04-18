Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0AC6E6697
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjDROFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDROFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:05:14 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2880C12CB0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:05:13 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f09b9ac51dso68704715e9.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826711; x=1684418711;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ynBeS2S9BYNG4S4nhDKVIEpTUnJOEdpYuou3YGon/uE=;
        b=xyoRVwNTQUIHqkyg6c8G5EqOPRJDaduQa6kYpluzOZ1ATXqaE/0WF2XpfJWGKR0p78
         L5FnxOeC14qAn4CZtWPPuYVZWR2ptdpTJ2l3Z+V+WbRf0Q/NJKa9v5flTRvaYfhB/mUy
         zq6q/JSU7aroWlf3XFp4TYVCIqvyBkIfm15igvRF16D8lkieWvkrmgHgMnvHsyC1rj46
         +pCI3be7pwd0T3IGo9rEQC+xLan4FRv01jHzvDsyPbjvqnpSy+s92AcoGzSwyzVFcszR
         9us8dMTAUt44DwvORfZaSMGb9mD5UtIj/IVde0Wq95slDZAjMhQ+KAJHKPMlMNLJS7XV
         PgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826711; x=1684418711;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ynBeS2S9BYNG4S4nhDKVIEpTUnJOEdpYuou3YGon/uE=;
        b=LA4+ZLBCqcTSxNAuWEFIJB5wDifp6d085zqVPfxC0U1d+qgQ7KFglQWdCwk4u5TbUM
         gXNMj7qMlMmIYBzqzY53F9Rf66JdL2ZAcHd0frh74RRMypzYenekM9Ww4tTD9DRXHwIV
         0/LERV6hD2rUVs9+IjhIvNTjaWw3rD+8N9dV/3EasiFIiH2HrsFWzIro6GcZOvk1uQLa
         mIioP5bsKV9bgWcDbIn+Kw8BWfMdnvBdo7z9QuJzkVhvthZ88ZklR8nM5M56OE24biOw
         jRPS/fq/safnuv+MAXlDLv7CVMhtbfmoVIwcSGE2rC0X4FA0iBulpeH5j8dTDQhvKTKA
         Vs/w==
X-Gm-Message-State: AAQBX9fA8MYa5H1gsVbTjX4XXRyZSkWSrtfc4oiO3dEElbNaYC7vuQiF
        XVQAhC7nE5HSXGyzHTCdeZ1NLRq5C1xK8rpeO94=
X-Google-Smtp-Source: AKy350a85Pqze+vc8QuezkhB/58wnt7Z/abKiugrHPU8XD0lgMfeR1nkFJ4j3Wo/Rpl0v/X/Mz1L8w==
X-Received: by 2002:adf:f7c5:0:b0:2fb:a0eb:feaa with SMTP id a5-20020adff7c5000000b002fba0ebfeaamr1945026wrq.17.1681826711581;
        Tue, 18 Apr 2023 07:05:11 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id e16-20020a5d4e90000000b002f2782978d8sm13101943wru.20.2023.04.18.07.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:05:11 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 0/3] Backport uclamp vs margin fixes into 6.1.y
Date:   Tue, 18 Apr 2023 15:04:51 +0100
Message-Id: <20230418140454.87367-1-qyousef@layalina.io>
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

Portion of the fixes were ported to 6.1 but 3 were missed.

This ports the remainder of the fixes.

Based on 6.1.24.

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

Boot tested on x86 qemu environment only.

Qais Yousef (3):
  sched/fair: Detect capacity inversion
  sched/fair: Consider capacity inversion in util_fits_cpu()
  sched/fair: Fixes for capacity inversion detection

 kernel/sched/fair.c  | 86 +++++++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h | 19 ++++++++++
 2 files changed, 97 insertions(+), 8 deletions(-)

-- 
2.25.1

