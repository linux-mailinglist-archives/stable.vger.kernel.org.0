Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF209668856
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 01:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbjAMAWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 19:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjAMAWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 19:22:14 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B9AD58
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:22:13 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so25352711pjj.2
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yDLd/c7sffLZEFLE9eRRXtPje9jgj2d5fJUXABkKQP0=;
        b=LpjSq/Kastw9Uyx7f/r+AXRPp75VX1xPSml8w1HOfumTaSgX7Xs9RsbvsIteXr691a
         PvgtLM027UA7L5VjfdjU8Pk4kFOUF/8BrFWFSiQwIS8PEVk/CY3TRIgds4VX8JWsbCIQ
         /duk64ketG1O8Sh7/btJxqHc1xiTUw73+XzcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yDLd/c7sffLZEFLE9eRRXtPje9jgj2d5fJUXABkKQP0=;
        b=ui76UcF7O/2BO4FkCTK2V9RRQc7shLa2X2X9k0MMZNtdoXe2lkHcggXlhvxRvJjmgf
         8xxXVtVfniAcXxYQxzpzF3rUdt0Sbgp/N58BH+Y/dxijqTynxOzDniYVBZMwBLpKV5Kj
         ZllcMQzvDtUEUEnMNGzEc6jhmAm1FDc/rnaHXmJ0EsYptb9flIFqVKqmbSZsg+GN9t36
         OqXR55pDnb1HI+dBCKzZixXJA5O2c68rzSkbGE+mKH8t/7YCgvwUM8jL0sX4jc49olEr
         rFPXQsM3O3nMwDux61nwdksg4CzRpSNmJG5+k/NmV/RKpTg48hQOJeVQ8xAAOZvMcq3Q
         xTAA==
X-Gm-Message-State: AFqh2kqWiwN9epHBTcfwbDEP63Q031g3quLAAEXXVF6W8f8AgYTYPO6m
        fTEeJOfSRtZ817r4ASIpVmu6iQR4q1aSp0bR
X-Google-Smtp-Source: AMrXdXuOub6bFjrixZ9Yum9HR7iFKmh6XA9lU5NIhjWUIaxx11yMdgosFzluiiWICG9PJeRTO7i3nQ==
X-Received: by 2002:a05:6a20:6707:b0:af:9538:ec5c with SMTP id q7-20020a056a20670700b000af9538ec5cmr9033204pzh.51.1673569332751;
        Thu, 12 Jan 2023 16:22:12 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id 75-20020a63074e000000b004b5fb50aa6dsm4748931pgh.83.2023.01.12.16.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:22:12 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Denis Nikitin <denik@chromium.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15.y] KVM: arm64: nvhe: Fix build with profile optimization
Date:   Thu, 12 Jan 2023 16:22:10 -0800
Message-Id: <20230113002210.3984665-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Nikitin <denik@chromium.org>

commit bde971a83bbff78561458ded236605a365411b87 upstream.

Kernel build with clang and KCFLAGS=-fprofile-sample-use=<profile> fails with:

error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: Unexpected SHT_REL
section ".rel.llvm.call-graph-profile"

Starting from 13.0.0 llvm can generate SHT_REL section, see
https://reviews.llvm.org/rGca3bdb57fa1ac98b711a735de048c12b5fdd8086.
gen-hyprel does not support SHT_REL relocation section.

Filter out profile use flags to fix the build with profile optimization.

Signed-off-by: Denis Nikitin <denik@chromium.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221014184532.3153551-1-denik@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

I need this to properly compile 5.15.y stable kernels in the chromeos build
system.

 arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 8d741f71377f..964c2134ea1e 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -83,6 +83,10 @@ quiet_cmd_hypcopy = HYPCOPY $@
 # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
 # This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
+# Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profile'
+# when profile optimization is applied. gen-hyprel does not support SHT_REL and
+# causes a build failure. Remove profile optimization flags.
+KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%, $(KBUILD_CFLAGS))
 
 # KVM nVHE code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
https://chromeos.dev

