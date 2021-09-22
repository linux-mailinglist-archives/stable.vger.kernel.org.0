Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF6E413F8D
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhIVClb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhIVClb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:41:31 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE8AC061574;
        Tue, 21 Sep 2021 19:40:02 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id m21so1054317pgu.13;
        Tue, 21 Sep 2021 19:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFHgXjDcWJ3G8g70ezF4SC+fF65z/HHpwkA2EEyQfG0=;
        b=Y1nYkbg92LDGDmAQ8ANCxWoDi10BW4D4uvcXcLZt2CEruO+stW2Z6fyRLnBUKytqQ5
         xZ59vH35JATfmaadbPE4Yrlj187e/Jrr699VVSqRv6vB6oQo8nDvs2SIXAGEocqD19Jl
         qG4jxlqW3JGEtsbUwN6Pq7VB9k2/Qb6fBU9b6vHlpF9TECJrFWu+rQQjA4szk974wOxV
         b2cMl9IvZL9fC2ZMdRtAiS4aa3Fld/O4iv604UD9FEIehYPKiSzOOQ7/UYQh5VOOuIlP
         K6FowJPtlpbD92fntf1kyLc4/GW1HQ3kZEEKvmtPr9pno2bryKni1lgGeJvlhHvILOVB
         vKXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFHgXjDcWJ3G8g70ezF4SC+fF65z/HHpwkA2EEyQfG0=;
        b=pCjP4plkoMuDAh5Ft3zyVnDS5Fe/cTB3n7+pwP4ZeKbqPOXoptIzqjZVB7KGiwCDyX
         V+OtLI/3uFEfqsMOUtB3crP+Z+Mk4+d48SHSOyGBhyoflgXw2IH1n3JuyFMhsgoawNml
         xWIF9n1o4+mJjrzq8HIHlZHBFj3ZZRalLySHIHSUF7a81Xy1bc/AqpkuIBtfOcd+9EzY
         XYELE+dmp7+oJrUVoZgSu8yhexU5sW8VKYiuILdvrVTvmH9kGYvC63mv1hk3WUj8+wnh
         RGppHg7l9QQL7Z0tdlrZn+NwBu7xSPljYXS0qsEo0AK7Sh/ixPk7YzZUcsRPmiiakJOh
         gdKQ==
X-Gm-Message-State: AOAM53142oSEmIx+glnKEQcz/dX2+UNI4loZfYR/0j1FyCRGJBZDXpgV
        MYvYyItF9ZTynlvvwmCwRuCjhlk92Jc=
X-Google-Smtp-Source: ABdhPJyvk3trlh0Amxchqfx/p+k8eDbO74VAKySEcpOEbtPMRJSz4smz4Y6x4mk6517nouORvNfU1g==
X-Received: by 2002:a63:6e03:: with SMTP id j3mr30894680pgc.465.1632278401282;
        Tue, 21 Sep 2021 19:40:01 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g19sm3805321pjl.25.2021.09.21.19.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:40:00 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 5.10 0/3] ARM: ftrace MODULE_PLTS warning fixes
Date:   Tue, 21 Sep 2021 19:39:44 -0700
Message-Id: <20210922023947.59636-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series is present in v5.14 and fixes warnings seen at insmod
with FTRACE and MODULE_PLTS enabled on ARM/Linux.

Alex Sverdlin (3):
  ARM: 9077/1: PLT: Move struct plt_entries definition to header
  ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
  ARM: 9079/1: ftrace: Add MODULE_PLTS support

 arch/arm/include/asm/ftrace.h |  3 +++
 arch/arm/include/asm/insn.h   |  8 +++---
 arch/arm/include/asm/module.h | 10 +++++++
 arch/arm/kernel/ftrace.c      | 46 ++++++++++++++++++++++++++------
 arch/arm/kernel/insn.c        | 19 +++++++-------
 arch/arm/kernel/module-plts.c | 49 +++++++++++++++++++++++++++--------
 6 files changed, 103 insertions(+), 32 deletions(-)

-- 
2.25.1

