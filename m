Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C8241A10F
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbhI0VFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237292AbhI0VE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:04:58 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DCCC061769;
        Mon, 27 Sep 2021 14:03:20 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w19so16996505pfn.12;
        Mon, 27 Sep 2021 14:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DcVUI6lIUxOIn8XKZi8OklHh9gOl/KKLH3w5m4uaodk=;
        b=W4NKBIRqotI8bHmEEWsmSTHnhs4Mzq40Q6srIzErCCP+UP415SwoMdOXw89xhflPz5
         HCBhv37DHjRtvpEVaSJPJg+4S4ELX/m+MoNDzEKw8Gx8TZ5BgAtyICyaCWgoe8N14zjO
         P2BSm20qnfOONRrEZ111PkeC0fEi+vj52bDLjn0px6cz+D8pz6kyuR/u1tKH2cXA8Fhw
         nBs723XaHGRoIoYQp8XJTbuJBaEZYinyfLsJiiHyLvQbtlcU3JfKct1EFpnHtzdoSWIe
         uH0YLQsY/lgPu8URzee45pFhgooIp73XMzVX8rwwpVZ2NklqZNJyNxeztJhJ5H5QWeLN
         dgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DcVUI6lIUxOIn8XKZi8OklHh9gOl/KKLH3w5m4uaodk=;
        b=SFRTy30u0do1IuhW263Dz+RutQNBNP3vmxUbD98ouws2pqdY84eikwWgCPCXGx3IZN
         ZEUZU5UBUAcVG1GagUS82Y/G8FcK4KCisOLQOXv2obNMliUOWk6Rw/FxjA/yyXZ/Zqe+
         kuv5Z0X0kofCuuQN8/J0jjD3YX/KwRzqX6Ftva27IbqpRsXzh9NH9y9+6Vze09fhLZRK
         S2GynJ6hOPcAnx21X/1eznrzTMfne/KsDYiQ5iWHaY4AltWYo0TBw2R2atuyhAVxAkNC
         KRizgrwUK3PEW/RH/OEhIA9SlquF9cQf5sHIAYZ5xIjJHIejRjaxhWF6jrwsBPNotil9
         IbqA==
X-Gm-Message-State: AOAM533aHZS8hujlEVJOAq5O/TC29710CtOsiqiDtOUgdLWLUcO1Rr1x
        SVOauRd3nUt2POsThKfaJIZCCOTo70s=
X-Google-Smtp-Source: ABdhPJz0DqGQT2R2gSNSmmJ3H8yzyy64nrtl32kM0SfT1HycEcSp1m4hKHK1VLZ63xty8AHIo3C5nw==
X-Received: by 2002:a62:924c:0:b0:447:aae0:b6d6 with SMTP id o73-20020a62924c000000b00447aae0b6d6mr1939798pfd.52.1632776599900;
        Mon, 27 Sep 2021 14:03:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e12sm16444086pgv.82.2021.09.27.14.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:03:19 -0700 (PDT)
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
Subject: [PATCH stable 4.9 v3 0/4] ARM: ftrace MODULE_PLTS warning
Date:   Mon, 27 Sep 2021 14:03:12 -0700
Message-Id: <20210927210316.3217044-1-f.fainelli@gmail.com>
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
 arch/arm/kernel/ftrace.c      | 45 +++++++++++++++++++++++++++-----
 arch/arm/kernel/insn.c        | 19 +++++++-------
 arch/arm/kernel/module-plts.c | 49 +++++++++++++++++++++++++++--------
 6 files changed, 103 insertions(+), 31 deletions(-)

-- 
2.25.1

