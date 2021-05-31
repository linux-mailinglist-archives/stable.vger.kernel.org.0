Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE031395958
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 13:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhEaLCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 07:02:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36924 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhEaLCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 07:02:39 -0400
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lnffG-0001KQ-Nh
        for stable@vger.kernel.org; Mon, 31 May 2021 11:00:58 +0000
Received: by mail-wr1-f72.google.com with SMTP id n2-20020adfb7420000b029010e47b59f31so3805902wre.9
        for <stable@vger.kernel.org>; Mon, 31 May 2021 04:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nzYc2tYtxPVFKt3OxgtwLlLbO7+qByb2EC+2C9fSPYQ=;
        b=Xg9nUzbuFv8Q43DxRo3kUZLktL3kBiaZxPYhLr7IXtb1o43cwf8rz+FWzLRd9+4lvQ
         5pN/c/5Svyqu+myZIy0JghOQqPjOe6o5SwxwzxXg9jrN8kwR57p4zMqvcYH0Tj8Q9apv
         kWnld3hVdDBO0s05gs0M7POL6eErE0ST3anclzLuOl+d0a3EqzxakE5M5sXz8dvStXaE
         T7C3ehU8azNGhe7Y0vfF6jYM9B7it8zp1rYt+EOHU2Ej0pzmsbKa5QZ0O0N8iqHEqb3Q
         tgtaUaVmjywXUx/KPp0OZEVKnwgz/6eo2/scEw8L1TanzxwMfTbqJ5hnVetMktGCfvEw
         eKRA==
X-Gm-Message-State: AOAM532xiJZLfv+DKeYEzVispzB8o+L8clatZZyvyR/YHPnUCVH2FDMN
        78bkwU9xGRes+a/S62Nll+1wG4hwp4tBjFLpuLquKn3fp4eTNaO04tHT/NSwUizlprNp3Jo7jaK
        LThueg51RU2r3Ondgj3aHQI1Jhob3/RoRvQ==
X-Received: by 2002:a5d:4e0c:: with SMTP id p12mr22098883wrt.268.1622458857821;
        Mon, 31 May 2021 04:00:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRlaMORsw/Mmya/YTQp/i5hyPpUGEs59cgCVcdgLWskShsknH7xeNvJVcHPiTG+WIGp0jGMw==
X-Received: by 2002:a5d:4e0c:: with SMTP id p12mr22098867wrt.268.1622458857650;
        Mon, 31 May 2021 04:00:57 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id n20sm14608799wmk.12.2021.05.31.04.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 04:00:57 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v2 | stable v5.4+ 0/3] x86/kvm: fixes for hibernation
Date:   Mon, 31 May 2021 13:00:50 +0200
Message-Id: <20210531110053.14640-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This is version 2 of aa backport for v5.4+.

Changes since v1:
1. Clean backport, without context changes.

The first patch specifically fixes bug aftert 2nd resume:
  BUG: Bad page state in process dbus-daemon  pfn:18b01
  page:ffffea000062c040 refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 compound_mapcount: -30591
  flags: 0xfffffc0078141(locked|error|workingset|writeback|head|mappedtodisk|reclaim)
  raw: 000fffffc0078141 dead0000000002d0 dead000000000100 0000000000000000
  raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
  page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag set
  bad because of flags: 0x78141(locked|error|workingset|writeback|head|mappedtodisk|reclaim)

Best regards,
Krzysztof


Vitaly Kuznetsov (3):
  x86/kvm: Teardown PV features on boot CPU as well
  x86/kvm: Disable kvmclock on all CPUs on shutdown
  x86/kvm: Disable all PV features on crash

 arch/x86/include/asm/kvm_para.h |  9 +---
 arch/x86/kernel/kvm.c           | 75 ++++++++++++++++++++++++++-------
 arch/x86/kernel/kvmclock.c      | 26 +-----------
 3 files changed, 63 insertions(+), 47 deletions(-)

-- 
2.27.0

