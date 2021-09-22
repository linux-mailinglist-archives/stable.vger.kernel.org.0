Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23DC414E84
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbhIVRCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236752AbhIVRCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:02:36 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD48C061756;
        Wed, 22 Sep 2021 10:01:05 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v2so2169186plp.8;
        Wed, 22 Sep 2021 10:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5/G0wNYSsPonzPykbqlENShLiJ+dcmYAQjyK7QqizU=;
        b=G856MxjjGPngKxPlU4rZ15RyInBh9AUKXsgjANyyWN77Rb1n6hM2S1cbb2/oxXopxc
         64VpVvY0JeMVeiqKONUgHPA1wpLFuX3W6eJlo7OJZLeQE3c63vV1j8u6s64x71QYTCDS
         b8Hx5o+oMrfCtBJUUSvl9jwJyAiU0EBwnR/rmRrHGXEiNQo+bIReZUWGMs44VwGl6B74
         9oGMFTjd6z1z2bxNs59/YhzDxC/IkCn98Sas7+Z1hr6JLowuS7j48Y1yBKQ80pIhqTvT
         aZVD0QYCzkPKMvzVnyttFm29sEFYX79a88EIFJoPUxLTeAL/g7qcbR8qI7MkzCQYyRXy
         I6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5/G0wNYSsPonzPykbqlENShLiJ+dcmYAQjyK7QqizU=;
        b=PGFzCL0cxZrVT/ufgabln6i0o13sKd7FhOuV5aV7AND1nvHnQMy4ET4p9fIgUWXtUf
         6T8S3p6slJpBwYAeVJSspaTF1yuEFVJkYLkN7AAtrNtJWRqIBc/hmZv3Ou4hXNKYbun7
         qwk2DYZJtw8X5on7qH/EmBcwyEqx8Nzgk/+7F/l2sD1iBytPTMvErj1Bgk8hat8ARwhb
         4+hvQz7fCWvwtts4coZtkm5ne6wsuSazborbU50V7pL3kC+2wpes586FIjr+J9h52hgU
         lD6bDR3+cEciHw+PGZmHSfIbX0Vu5hxdP2ljcR65pj1NYTGnXHhYtk3y37oDu4VS/hvG
         asNg==
X-Gm-Message-State: AOAM531p2gG8kWq9/GiYdyN9N6daKHwuWNmEq+XNXx9eNaqEhLuRYIG7
        V56VqmpdhU0YZvUTmAM7NYyVkIb7qzM=
X-Google-Smtp-Source: ABdhPJzj3q9k4mc0q+v7QDk/BrK5a2ezqCe7yJCiuEODj6LKa6BgfkRSnY5ImDFFfG3msgu+uLKIWw==
X-Received: by 2002:a17:902:da89:b0:13b:7d3d:59e9 with SMTP id j9-20020a170902da8900b0013b7d3d59e9mr395643plx.41.1632330065176;
        Wed, 22 Sep 2021 10:01:05 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i27sm3041404pfq.184.2021.09.22.10.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:01:04 -0700 (PDT)
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
Subject: [PATCH stable 5.4 v2 0/4] ARM: ftrace MODULE_PLTS warning
Date:   Wed, 22 Sep 2021 10:00:30 -0700
Message-Id: <20210922170034.190023-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series is present in v5.14 and fixes warnings seen at insmod
with FTRACE and MODULE_PLTS enabled on ARM/Linux.

Changes in v2:

- included build fix without DYNAMIC_FTRACE

Alex Sverdlin (4):
  ARM: 9077/1: PLT: Move struct plt_entries definition to header
  ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
  ARM: 9079/1: ftrace: Add MODULE_PLTS support
  ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without
    DYNAMIC_FTRACE

 arch/arm/include/asm/ftrace.h |  3 +++
 arch/arm/include/asm/insn.h   |  8 +++---
 arch/arm/include/asm/module.h | 10 +++++++
 arch/arm/kernel/ftrace.c      | 46 ++++++++++++++++++++++++++------
 arch/arm/kernel/insn.c        | 19 +++++++-------
 arch/arm/kernel/module-plts.c | 49 +++++++++++++++++++++++++++--------
 6 files changed, 103 insertions(+), 32 deletions(-)

-- 
2.25.1

