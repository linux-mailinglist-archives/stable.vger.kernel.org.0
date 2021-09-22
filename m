Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5117C413F9F
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhIVCml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhIVCmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:42:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B40DC061574;
        Tue, 21 Sep 2021 19:41:10 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q23so1386058pfs.9;
        Tue, 21 Sep 2021 19:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFHgXjDcWJ3G8g70ezF4SC+fF65z/HHpwkA2EEyQfG0=;
        b=W5Yjb66h1dn/pY8ZsxqupE1mCIl5jKTCoODohYJo1W59f2VZUWRovquErFNpliHmmz
         8HCfbuIZgtkRc0e+viII41G1unhm1UTT4R9W4gMuDQZr1KZZt97fR5zLl450Wv9Iadle
         2vLH2H8SlJ735Qq1WKEBbGVst0mPA2rol0rMs88WY421VjrdlhQOERl79m/Cp02oACTR
         YDmvduCsmG4AUwlxEI+d+DgZhlis4kkLgC2eIwgL89ZvnH9ERk3xRGVMU9h0PUXa0BkF
         nHgQW4fBWH826s2JFeB6OVc4pyw86yzM7Vy4JW+95fpaaS99UE7h2LhheCmiQ7GC611W
         mMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFHgXjDcWJ3G8g70ezF4SC+fF65z/HHpwkA2EEyQfG0=;
        b=2rBAQ86ac9yt3TYhmKHxmJiLhT8fdm0gH//K4pFUagc0i4s+tt8UFWb1zehcwsO43M
         L0Eypg14Ic6TZ9DBOPPlUjDEEFpbzgB4SWkXqibjDgOfG4ffQmtoTjZzoDljCvObKnyK
         1kHXLbmvH8fEaxU7J8uxI5Iuzcc5MV3LCtwn/BxJs/3+o7cEC0TtWF4ml0oHxqL/zsUX
         FPwMSdUrcniD8tE7hSWiHXzod9PtliOImdgwTBqfEZ1oRBX6eGWK8JhMLbwDMgdqsIzE
         Uq1Xt+u17q8GFvRmVMA02LGH0+6fn45rIcCOuSVJw4wUXtqwkjgPAXtp1MUX2nyElqFG
         ax9g==
X-Gm-Message-State: AOAM530emsDMYZLgutqlnWNFCvuZVYWV/6zLHBavmsEyW1zbc3qmvrnq
        /y+3XI1lfSbJsX+JdFn6CB83PCMeroc=
X-Google-Smtp-Source: ABdhPJzKGRgmKaTWtXRNY7oHFPwX1U09iVT5CWb7ceey6gK+gVHX+gDqorY5cSM4vIoW93p0qy21Pg==
X-Received: by 2002:a63:2047:: with SMTP id r7mr30245212pgm.398.1632278469854;
        Tue, 21 Sep 2021 19:41:09 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f24sm426309pfk.198.2021.09.21.19.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:41:09 -0700 (PDT)
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
Subject: [PATCH stable 4.19 0/3] ARM: ftrace MODULE_PLTS warning fixes
Date:   Tue, 21 Sep 2021 19:40:45 -0700
Message-Id: <20210922024048.59818-1-f.fainelli@gmail.com>
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

