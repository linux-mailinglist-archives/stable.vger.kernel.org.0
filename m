Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C73E6BFC6F
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 20:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjCRTdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 15:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCRTdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 15:33:12 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36801E28E
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:09 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t15so7091398wrz.7
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679167988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WNtRhYEOCFjpiraq216z8+zMUSqLx7hSiAR/ThfRN6s=;
        b=irUlF9OCwmMnxY4cHnChWbiTHhxoCwobydHaQmGAv/kSmbSMgTZiUysxeBbzrpJZXU
         YbBEZHTyNCIUpV3ikBHMwXNNX3UzSR6fR/fBeRarG+Arc/4bihKv5uqGqX7POeoDSHJb
         jtP6sSs+Mu9a0a5wH4X8JfGifHNaciiH8E/wyCGyH0kOKHn9Huu2gxdViOmN/EG464Ug
         asQA7aniIPGW1wnw1QQ2tbEWfiU5HMD/4sBhB0lkvYrLZ75C6+C91rqgYdRjt6Ot1306
         qHB4qZF2bN5oB/ol3o7UQiJN+W6JsLMvu0k7SQMOCSk5bet3ICwrP6LC4rY/H5ThL+gw
         a92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679167988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WNtRhYEOCFjpiraq216z8+zMUSqLx7hSiAR/ThfRN6s=;
        b=wYvXEddQltLF3ddEQUh7AicBPY6R21sAZSUTrFj69XkjPQSXeGtVO85n8wLsr4ejLZ
         bL/eP2OO3y6QBR5JgycNk0B0AGJGaj12nGKv0HybQtzM67NgwHIu1CTTVFGRX+wsRL3w
         28m7mNYkIGWpf2pgNGaFHia34RBotYpe5b+aaOzaJv4jQK1pEg6Z4bSXZ9t7QZbWKlyM
         C1Qvn6zIETKhbvneKEHcDoAjw8kwPeuzCRBPpL7f8u6Z7ocBwMiH/8FBmEk6Mu0nZlTp
         mzm8QklkQaTXe3dxnSneeU57pOkW5R+IQoRSnjptK4DO+iSobyz6NuJgwKvpksHHph/Z
         NpuA==
X-Gm-Message-State: AO0yUKWDvhv4FMQvnNrnYRXpGFmku7KcvYM8foCjSWypLM5EpRMoQ+of
        XweDIdYJ+4j4VfefrWv95/M7kW1C9JxbpGlO+LE=
X-Google-Smtp-Source: AK7set/QnJ6H4HvrkbfsxhpBIfvOLWBR2mEhpiMxHq52CFzNCOETTbFDsM2o2tQgQm51VM2kKdRxlQ==
X-Received: by 2002:a5d:6a42:0:b0:2d5:a170:839d with SMTP id t2-20020a5d6a42000000b002d5a170839dmr811093wrw.25.1679167987995;
        Sat, 18 Mar 2023 12:33:07 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id o6-20020adfeac6000000b002c71a32394dsm4968696wrn.64.2023.03.18.12.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 12:33:07 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH RESEND 0/7] Backport uclamp vs margin fixes into 5.15.y
Date:   Sat, 18 Mar 2023 19:32:55 +0000
Message-Id: <20230318193302.3194615-1-qyousef@layalina.io>
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

