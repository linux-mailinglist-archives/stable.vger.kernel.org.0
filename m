Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3655F395F1B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhEaOH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:07:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40457 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbhEaOFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 10:05:54 -0400
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lniWb-0001tr-2i
        for stable@vger.kernel.org; Mon, 31 May 2021 14:04:13 +0000
Received: by mail-wm1-f71.google.com with SMTP id o82-20020a1ca5550000b029019ae053d508so12764wme.6
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:04:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dgTSNZe6+QH6HNKJLb5tMT2tagGq/tOKzcBKc+w7RxY=;
        b=jDNEOtt179fMmHEn9Pyw9fx/XuTt/PgX7SPoLnehVCJLY8/s4TAP3hSVemNIv/6cdc
         e7+ZWS78Uzq4nU9U/rBnSxOL0lj0DmEBoyFDO60lWvJovjoMb/2HEVGOA3qXrBm5YD2s
         T9XXfpZoaNj0ZqQmHBYaKJUiEgA4VIqbxKyrklqd/7NRgCRwXXkWHKeqgAf3fd67lUff
         U9sY3qkwySc7Hepos20dKFU3be7lpCnMBMhB9hZzVvnUWa4yrvQFjtATMvrTUpJvvxgE
         DmsKXyY8hoxU6DO1up40DJuDv7w5BLUwZW7KY7VPzkgjpmkoLXFCoEHbGpqWNAjLMEah
         FztQ==
X-Gm-Message-State: AOAM533Qx+LNt16c0fsxPyqozZ69gSZsIMQdQinLFF5CXtQDQlkxmJ83
        s250vDD2o5CPScz1txjXJY9F+e6uG7RjIP8uZ78CyRbuwPR7bJl5bn9jfcx65ihvsuVbqfy79FN
        jRpSL+Xxg/I5yk/ejGgssmNEoyx+baWMdIA==
X-Received: by 2002:a1c:e90d:: with SMTP id q13mr21354714wmc.163.1622469852256;
        Mon, 31 May 2021 07:04:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQKVEWnWOKH1iQ1q2G14Jf6ofLD6Kw2Hb/0+rL+bdFmRi4ajpNvKESX1iFsCi994G8AL5oEQ==
X-Received: by 2002:a1c:e90d:: with SMTP id q13mr21354692wmc.163.1622469852091;
        Mon, 31 May 2021 07:04:12 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id b188sm13342971wmh.18.2021.05.31.07.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:04:11 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 | stable v5.4 0/3] x86/kvm: fixes for hibernation
Date:   Mon, 31 May 2021 16:03:44 +0200
Message-Id: <20210531140347.42681-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This is version 2 of a backport for v5.4.

Changes since v2:
1. Send proper backport without context changes,
2. This series is only for v5.4.

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

 arch/x86/include/asm/kvm_para.h | 10 +---
 arch/x86/kernel/kvm.c           | 92 ++++++++++++++++++++++++---------
 arch/x86/kernel/kvmclock.c      | 26 +---------
 3 files changed, 72 insertions(+), 56 deletions(-)

-- 
2.27.0

