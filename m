Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4AC2944B0
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 23:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392139AbgJTVpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 17:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389512AbgJTVpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 17:45:47 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477F2C0613D3
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 14:45:47 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d23so86064pll.7
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 14:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5zb2k/yQhQ8oyMKadz8VKlRfv548LEmsWMcy3EDlZOI=;
        b=eJue/YhgqPzoAvHtxwGGnR1AAhL5nzuMGilf9kh6oUy0ZKG/UkcwvAbMmdP8Mw8joZ
         m+7t7pBo8T0Ns3AEP3PzVa5SlOKwT4UKfb3zAYVPkCbHB6tQcpKBzn0DrE3W0PsSAvMp
         AamR0ipjPf/3ltevlzpJBHc0w0KZmD5DNCea4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5zb2k/yQhQ8oyMKadz8VKlRfv548LEmsWMcy3EDlZOI=;
        b=byIUyzEfK9rlxD+F2PYck7Alj6Tec+5nFT+eo/5Sw734tYvFYIEhVbbrzG1DJun1es
         vugKBp4O/eRuXJ87lmsZv2XYl+XNMFrEo87mY4LbboLYZm0XT2oxo4miWejSwUvUcdwe
         W9dp/g3g+KiRhpo4wpnwvkwjfsexNGl3RLQ+zw4H1rMO4F8uT1EBIY7T+HZr6QYJaIIL
         N7XiqDr7zQfmkz06CzLe6plsx3Kwj8PV87EApGiaJJ0abLnpm2oLA5zBBeb9DLPL7NR5
         0OufEDTQCs+svun0Owyd+aUO0Jgeejr2gp1L3hbAiudDDL/q4VPU0bFfoIwNhNIuJAsz
         /cyw==
X-Gm-Message-State: AOAM532C/rkdIc9aMM3zADWV2ZgqMdtNt9+iEpMcElEopOPHd30BdwNQ
        KjcrmrsDBzAFAd1ilac2ZMzLbw==
X-Google-Smtp-Source: ABdhPJzOOD53E9+RyIyrrpIG0jxFtoCxvbNHFdP6EwHmydJyw118zxPHplRgGT/cUCXCGu8J73L2Bg==
X-Received: by 2002:a17:902:6a8b:b029:d3:b4d2:11f0 with SMTP id n11-20020a1709026a8bb02900d3b4d211f0mr234847plk.2.1603230346663;
        Tue, 20 Oct 2020 14:45:46 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:3e52:82ff:fe6c:83ab])
        by smtp.gmail.com with ESMTPSA id j23sm130751pgh.31.2020.10.20.14.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 14:45:45 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 0/2] arm64: Fixes for spectre-v2 detection in guest kernels
Date:   Tue, 20 Oct 2020 14:45:42 -0700
Message-Id: <20201020214544.3206838-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The first patch fixes a problem with spectre-v2 detection in guest
kernels found on v5.4 and the second patch fixes an outdated comment.

Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org

Stephen Boyd (2):
  arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return
    SMCCC_RET_NOT_REQUIRED
  arm64: proton-pack: Update comment to reflect new function name

 arch/arm64/kernel/proton-pack.c | 7 +++----
 arch/arm64/kvm/hypercalls.c     | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)


base-commit: 38525c6919e2f6b27c1855905f342a0def3cbdcf
-- 
Sent by a computer, using git, on the internet

