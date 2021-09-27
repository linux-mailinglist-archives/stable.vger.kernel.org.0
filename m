Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3942A41A0FD
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbhI0VEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbhI0VEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:04:32 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9C1C061740;
        Mon, 27 Sep 2021 14:02:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id w19so16995437pfn.12;
        Mon, 27 Sep 2021 14:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j5SSjAo98K45E+20/l2vJfSBS8YAkbvusCfPbeN4tts=;
        b=WXkjvvFw6KRq8AOFaCTJtjkf+CJpT1EnqLUrcF1s3qpv9+a4Ev1zzDz7IP1MmyRfyQ
         NtwICFjE6F4vJB9ktAtAbmAGvvJI/wDdoxCF65+iG3UafkrLF87SFvAfZgyttae6i50n
         cJyqLV6NATw37qG4aSIPCWwBIebS+7TzMkvcZyKqg7f6dLcx41QXqZNeyq0efongjU0O
         RBgkX3RyccwhZ29OyeePwqfbgju5nIb5sEuBbKueN0cYp5sCsUZuh872wSj+jP8WMa3u
         q+SSvpH9uQ/JDlyXkax1EX2YeoFcbBCZoyfsCnzySL6XVMgnuOp2Flwm75MmYz8JCd9a
         Bn7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j5SSjAo98K45E+20/l2vJfSBS8YAkbvusCfPbeN4tts=;
        b=TPfGw6DUboh3E9nBIyErB6S0a6O/u7psvBoK3jO7x0TsekGyxlFyD8PPbKVMjc3dHv
         TLDCwXpARxRMjyWdKFGKrKSZc/zhcS7ikwQBmze+YQc+gen6aImSyaQYOFzTv1wucQMD
         iy0OXw5Yot2Ud2VvFPiE6jJ6mZlfovYHp0QMVJdsGkaSDc/sSmPD0AWvbfUBTQDtr5cV
         WYVM7tyZNDA1nQc2HZoKSDpWELlQv6TyyeMhLB1c/3UYHYbz5ratpkWQoEyGz27W1mMu
         i+ILWO/OROkJ4mBxX9IH3bWphsstSKk9aQ38PhV6YeqYwqjMS3R7M8BtxZTEUC3ahfGV
         /4Mw==
X-Gm-Message-State: AOAM531jV0adI2odwnD8XrCfdlQcft1CrZJ53O6zjliHZ00+nVuH69pz
        2Yf4X8QiXe69/ILZYV5W4GKLWYSissk=
X-Google-Smtp-Source: ABdhPJwfWNHhPdoPThA4EIlzswek7Cee9JKWWBvkCoCdjIt0Dxx7OJO8D4FDIO+wR4ZymJZVFUA0Nw==
X-Received: by 2002:a63:67c3:: with SMTP id b186mr1371124pgc.229.1632776573686;
        Mon, 27 Sep 2021 14:02:53 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y3sm310537pjg.7.2021.09.27.14.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:02:53 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.19 v3 0/4] ARM: ftrace MODULE_PLTS warning
Date:   Mon, 27 Sep 2021 14:02:42 -0700
Message-Id: <20210927210246.3216892-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series is present in v5.14 and fixes warnings seen at insmod
with FTRACE and MODULE_PLTS enabled on ARM/Linux.

Changes in v3:

- resolved build error with allmodconfig enabling CONFIG_OLD_MCOUNT

Changes in v2:

- included build fix without DYNAMIC_FTRACE
- preserved Author's original name in 4.9 submission

Alex Sverdlin (4):
  ARM: 9077/1: PLT: Move struct plt_entries definition to header
  ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
  ARM: 9079/1: ftrace: Add MODULE_PLTS support
  ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without
    DYNAMIC_FTRACE

 arch/arm/include/asm/ftrace.h |  3 +++
 arch/arm/include/asm/insn.h   |  8 +++---
 arch/arm/include/asm/module.h | 10 +++++++
 arch/arm/kernel/ftrace.c      | 50 ++++++++++++++++++++++++++++-------
 arch/arm/kernel/insn.c        | 19 ++++++-------
 arch/arm/kernel/module-plts.c | 49 ++++++++++++++++++++++++++--------
 6 files changed, 105 insertions(+), 34 deletions(-)

-- 
2.25.1

