Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE95341A108
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbhI0VEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237235AbhI0VEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:04:48 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6634FC061575;
        Mon, 27 Sep 2021 14:03:10 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 75so2577453pga.3;
        Mon, 27 Sep 2021 14:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j5SSjAo98K45E+20/l2vJfSBS8YAkbvusCfPbeN4tts=;
        b=U3/6i5CfJ6Ae/A18rmADou2ZEaQrQq+hWlermqbIUhTxbWqex+ymSXYVipMtZ82DzX
         azbIo/rccEQE8LtYKzsxGh6lARUEsL6i0xNTxzFzw9iB6IH2CrWbVnV+//KQ3MTZRWgE
         9azoXzhh6oNUm6SkrnIK8eHqqUUiPQTHk1ykA4pbL5ZZ8OMX4NAD16IxiCqEoGcFREDf
         FQujt5QhAXoRHgGz5qQqRstXvNZZWj3vdUoSiXiLwvJWvtE9p79Gb/l3HS4Hv7R3scey
         WNPqJD8+0pkTQkUTw1eidaqKOPyr/jrXPW9v8afbHqtvDvxMsza+LuVivDOXlzt6R9Bu
         vJjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j5SSjAo98K45E+20/l2vJfSBS8YAkbvusCfPbeN4tts=;
        b=nNUFo38UVY/CNpEHiHtUoPYmBnvyOmxu+pWh9EsyhMeuINIWZ1j+gF8J9upCefOGu0
         pz6oY3TRSeQKy4T9cVEuo+DKjOmqv7EysYKrtLixmDsE30OqzcNucCZ+wyZ/ptxA/0o9
         u0LK+qbOYB1GibAHAfOEquxPIvvmX38XwTGjs7jVKVjL6Bz9RZASFc8Gbv34bOdZARHp
         EMFCDPFu/fIwh4tbhidOnVh2mGHdKNForcyxxlDwcXaOKJUooYcJF7s2YOQwk0NaWq8i
         6dcSc6nmlLusfq/uxJ+5+KpORe97SEpgDLU7hYa2hlqt1er6X62o0Jc+6lSyv+cIrYEG
         YkFA==
X-Gm-Message-State: AOAM5327b1qhe8cN8le7dyaBpcenhPbHZy8rlou7UJZjuQ6z7eBYxWyo
        GtEBr5VQ2SXNAJXvnymV01bFbB6jIRE=
X-Google-Smtp-Source: ABdhPJzq9Z4Y4jt4xPDxWSMNUH3ahGQUbTWn35uDE+XK/IfCQ/TRJW8uKGEwhSRNrAoQN0PkcEdlVw==
X-Received: by 2002:a63:514e:: with SMTP id r14mr1406671pgl.282.1632776589693;
        Mon, 27 Sep 2021 14:03:09 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm19227652pgv.29.2021.09.27.14.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:03:09 -0700 (PDT)
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
Subject: [PATCH stable 4.14 v3 0/4] ARM: ftrace MODULE_PLTS warning
Date:   Mon, 27 Sep 2021 14:02:55 -0700
Message-Id: <20210927210259.3216965-1-f.fainelli@gmail.com>
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

