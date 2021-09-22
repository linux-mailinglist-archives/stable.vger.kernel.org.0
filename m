Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66164414E74
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbhIVRBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbhIVRBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:01:42 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6FFC061574;
        Wed, 22 Sep 2021 10:00:12 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y1so2158522plk.10;
        Wed, 22 Sep 2021 10:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5/G0wNYSsPonzPykbqlENShLiJ+dcmYAQjyK7QqizU=;
        b=bCiSO1RjV2L3LpjoA5ysOFPVI9okeQQJmZJFQz22kJHCsYKAWXSGNNu941CzVjFET+
         VGrlY1x3HS9G3993YqdtmDmfWzvFkKiQd5fSrhrlEEUx/YQMLiWl27f5GXsUGr6SaBgM
         TEbXIlKbIf28qBn9mkmb1bbKYk6+zv2b4ZzhXfrHuXGRZrn37A/SvN/kIaBRG7Lkx+Jr
         yYzs50nDEYfvniXwixw3/smiAHfXdWRT1rjGJa6vBYe6QI+JwEuC5SJL/zRWxmIUo/NL
         55tuByGD98V3Efva7dhzgGg/l4mYZjbvcH4LGRYdf0fdP1gqDu0yjI0eaIQSpc37KVk1
         XF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5/G0wNYSsPonzPykbqlENShLiJ+dcmYAQjyK7QqizU=;
        b=Q52iWadtAiUy5UlGkCCOXsevJe5YypYwf3qWyAbUiw5XlB1ZNvXI4fgOdNrD7SqyUk
         6zcEQq7ivVQdZUM/u7ac4GTvVW817rOCjYyYYDkSotfZxW0lDlaQKjI576jBzHMOuqvS
         yAEnbPWGouilGCgjUTlPqtVN9IL3VJWTlkmVzRu2z003Hj4E7iCEuxzhpbQ9qofxHxAl
         iWj4P1kpsF/l6GraAdWwtjeN1c1kwQ9f8q1+PbnxDowjnwPb7jU8fbw01tA/3UfpWDjY
         eldWDHBpDyrgTtBKTtCPGykDnKrTAI8eYCoElUyioph3soFQnQFxkpooO5pRV9L8/WUV
         ztmg==
X-Gm-Message-State: AOAM532ZZQCNPqGWAoaLY/nQ2LnildFLyFAew8sNacJ1D4pT1EAFkHK1
        Y95RHHBq5tBAHYn0mnyoApWytmTFRCk=
X-Google-Smtp-Source: ABdhPJzngwIelENeRl/TKHGG6s8FLGP6QT9+nJBnMnFfToww2yvWGcujROuR0GG9UUqo1jOnYMlOqQ==
X-Received: by 2002:a17:902:d2c8:b0:13a:54b2:81c9 with SMTP id n8-20020a170902d2c800b0013a54b281c9mr479607plc.21.1632330011394;
        Wed, 22 Sep 2021 10:00:11 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j23sm3196336pfr.208.2021.09.22.10.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:00:10 -0700 (PDT)
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
Subject: [PATCH stable 5.10 v2 0/4] ARM: ftrace MODULE_PLTS warning
Date:   Wed, 22 Sep 2021 09:59:54 -0700
Message-Id: <20210922165958.189843-1-f.fainelli@gmail.com>
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

