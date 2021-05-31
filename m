Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3CC395F45
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhEaOJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:09:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40490 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbhEaOHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 10:07:20 -0400
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lniXs-00020H-S8
        for stable@vger.kernel.org; Mon, 31 May 2021 14:05:32 +0000
Received: by mail-wm1-f71.google.com with SMTP id v25-20020a1cf7190000b0290197a4be97b7so12672wmh.9
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/22dWA9ToAyhY9911jIG9q1G2Uf3kQrudU1QgyGPF9I=;
        b=niXeBI/Qvd2dbKbhxwU4nCqkKhT4f67IrOBmi4ZOjhtSKAuGYs3Ts5veAeRjWK+qJK
         4bTytYb7MV6qhAgKHPB2dBCS8JfKCupi7euzd2KUoLjOr/D2Gh9G/q7Rgv3qIGv4+fzI
         c2uYqj8N1rQhNFRqbKmekQvBn5UeO9d9EhJKvkiWknSt1QvmeCaDV5DLq1qYGOBSNIQR
         u2qsoGt4IOpBPWo5tb6vwxMhkbmEO90FgK4DVPDdS2WeZ61nYQgzKuQe2RmZ7qPqadrU
         UficJTFnexcQI7QdKt5vlUWCHx0l/jt85a55u0t9PxP1LAH2Q5+QivNIPFAiZfBhKYSy
         mbPw==
X-Gm-Message-State: AOAM5321teZ2AjqavAehxNYUtIRGgE1uoQTLlYvyu0HiR0Y1fXTzBjfY
        PWdDZmrO3WVxr5dBmeNMjrV2vnuOaAPH1M/fd2bYqozrgl/xGb10c+TWF44vGMQn1UuccXCFhs9
        195Q6Dadf9vAZABlLR/PB8Xz2JKYgRwBqqw==
X-Received: by 2002:a5d:4ccb:: with SMTP id c11mr16097214wrt.169.1622469932409;
        Mon, 31 May 2021 07:05:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPkxUmxrf0+R9BkW+rg/9bLBlVxRJfyf83oqeg9uhPW4GV72D36ys71GM2+XzhgODxs1LldA==
X-Received: by 2002:a5d:4ccb:: with SMTP id c11mr16097197wrt.169.1622469932252;
        Mon, 31 May 2021 07:05:32 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id a3sm8858826wra.4.2021.05.31.07.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:05:31 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 | stable v5.10 0/3] x86/kvm: fixes for hibernation
Date:   Mon, 31 May 2021 16:05:23 +0200
Message-Id: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This is version 2 of a backport for v5.10.

Changes since v2:
1. Rebased v3 of v5.4 version, I kept numbering to be consistent.
2. The context in patch 1/3 had to be adjusted.


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

 arch/x86/include/asm/kvm_para.h | 10 +---
 arch/x86/kernel/kvm.c           | 92 ++++++++++++++++++++++++---------
 arch/x86/kernel/kvmclock.c      | 26 +---------
 3 files changed, 72 insertions(+), 56 deletions(-)

-- 
2.27.0

