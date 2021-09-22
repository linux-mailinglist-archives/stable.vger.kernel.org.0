Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0B2414EAD
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbhIVREZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbhIVREV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:04:21 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6D6C0613C1;
        Wed, 22 Sep 2021 10:02:51 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso4215085pjb.0;
        Wed, 22 Sep 2021 10:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rvl8tmfvf2C7R5Ue8yrks7dkuzK6wpg/W2fngVsGu6A=;
        b=p/OTnKhZXnU9w6ExB7IXQytxV0x7S7LWzuZk0CMovUx8RcfhVCN4VV0HT1og9MTTTl
         SA1Z22EZAzo9eqFb2XxLxjFKPzEL9zjGcll1EQebbxaVoFsJ8NqKvlU/kgL+9O5qwaA2
         eQC5RQ7esOXCW1tziyGWDKXc9Y+CzQ0sSYVS4Tmag6RSMYD4gTtv6CkVYN01k4EYRmQo
         QnjFGOoTeKJl5F3XeF0Xm7dcoZ5rAKGEH61NrbNODJDgbkqk9XPCJQ6EauYhAC0kfl/Y
         iA9dYNL8YypHv8q2VgOesWzki1c5jVPVdss+b+NWWuCdSmmuMldnKIWkWFByEZfc1Nic
         6TRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rvl8tmfvf2C7R5Ue8yrks7dkuzK6wpg/W2fngVsGu6A=;
        b=4IegDddDDFONfrTv/lUSbKYSo/NVCEjqK4D030cWkUfGVKqpicts74AuU5GOnDcppK
         f8NvXHmend9eGa2qaSnMAHCEEu3DjcC0/A0jHpOzUGsEkVpmaBUnP6Y0byUnTLfTG9+z
         t+3zfWfq86Ey6yEtxmpbd2jlGg/Y/frOtn4w2HMWFkvFBotTPeuEKvzT/UXrPyoE+ead
         dMgD7XVGdDCuVBNkrihEZFglCBf61dJJOuek/AoGFwTgWiwgSp+/gl5mrAI3O8gkPiAu
         fKPBxaJhTGqGeYbxi5RpBb5kFIngd1p+mKEFsMpEGGGJimXQUK5zQRjfjvHM7g5T5Zbm
         LLFA==
X-Gm-Message-State: AOAM532NWOh61fYx6wCDkbeg+xA/7+ow7zHSO2urLoLxEOzJflUhJFS1
        LMmDS1BmdZX1TXbv2PwgHyCgBSQtJDw=
X-Google-Smtp-Source: ABdhPJyLuBmoKI65hA710VcifTWmqWSOfB37toRSLw5mdPrpZqTnTEBL6kxY2mZ9Dj551bdg63bGXw==
X-Received: by 2002:a17:902:c205:b0:13c:a76c:4904 with SMTP id 5-20020a170902c20500b0013ca76c4904mr469264pll.85.1632330170725;
        Wed, 22 Sep 2021 10:02:50 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x128sm3061885pfd.203.2021.09.22.10.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:02:50 -0700 (PDT)
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
Subject: [PATCH stable 4.9 v2 0/4] ARM: ftrace MODULE_PLTS warning
Date:   Wed, 22 Sep 2021 10:02:42 -0700
Message-Id: <20210922170246.190499-1-f.fainelli@gmail.com>
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
 arch/arm/kernel/ftrace.c      | 45 +++++++++++++++++++++++++++-----
 arch/arm/kernel/insn.c        | 19 +++++++-------
 arch/arm/kernel/module-plts.c | 49 +++++++++++++++++++++++++++--------
 6 files changed, 103 insertions(+), 31 deletions(-)

-- 
2.25.1

