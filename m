Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCE0413FA7
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhIVCnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhIVCnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:43:08 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF61C061574;
        Tue, 21 Sep 2021 19:41:39 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso3481756pjj.0;
        Tue, 21 Sep 2021 19:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFHgXjDcWJ3G8g70ezF4SC+fF65z/HHpwkA2EEyQfG0=;
        b=DrhaK3spo56LsKAmB7p2NdoJ+nTvOcilZysgruVMyMJyNW5UYBEJw9gb3071xTMwmc
         moRaeNQI0duVPjdC9iGbI0yaasPv6s1zRNHNO1Ag4Fyj5VL6gMrnq3LZMvZEZENso6KD
         nPQ/nlg+qD6Bwb+HCaM52IcxROnDAepZZpItK7T4fb6hmyaRBnboFrr2DAhypCi1smo/
         kErm0Iobqut0SqfHL5Rcim3qnN7Tz7cj/6CCrjf9iJFqQU+5R+7zDdWnmTklxqXF/BLZ
         /5mYflW83MJBBu6hJHybyz4MbBlrQB37IcCoOnXIcqHE8rnf2+o7QO3Ewi31L+YOdnGV
         WXhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFHgXjDcWJ3G8g70ezF4SC+fF65z/HHpwkA2EEyQfG0=;
        b=FtBuy6G+Q3hTgZQuwPQlgRw2gNgcybv1STEnY7QF7+JLkMuzfWX/Ck4gmKKaeSnH+c
         OjW76oLcrf7A2PJcmYI+vOSdV1Ng+EO7MzTd3CyokXkRB30sva3GJa1UWaXK/jNrXwg0
         3uR2NyjeZD38OQvGT8GfrJ1F9grB2b1DWyrm29FJHXi5L6lDJZ0CE6lOEgWwsN3cN9uF
         TFYENsSTXrtOqBEIzgP7BjClLdkXNg+3DL7ApJjcWBmjrnOPPdIDcHx00xaS0cM8Ht9P
         8ZEDzRC/OtIiADE4VdLMeFgZU9KyZe58R9OUif+O1Z1SoLGr9ayni3Dc7nXA+CQS4/oy
         7R4A==
X-Gm-Message-State: AOAM532qZoKT5KU+1cBtjh/IybrGXhHjnWAxP/03rH1jz9LJVvY24nwP
        bYIKOs149fisIcc3sH7YcFb0j5AIJB0=
X-Google-Smtp-Source: ABdhPJxU7VJdpqnLKu5Ras/wIZXek+JgIDE92MjtspJ/2uNbYcgSdBmstfqkZOUkp+RcrBF/b4Yh8w==
X-Received: by 2002:a17:90b:1c0b:: with SMTP id oc11mr8711721pjb.158.1632278498489;
        Tue, 21 Sep 2021 19:41:38 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u25sm440360pfh.9.2021.09.21.19.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:41:38 -0700 (PDT)
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
Subject: [PATCH stable 4.14 0/3] ARM: ftrace MODULE_PLTS warning fixes
Date:   Tue, 21 Sep 2021 19:41:25 -0700
Message-Id: <20210922024128.59910-1-f.fainelli@gmail.com>
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

