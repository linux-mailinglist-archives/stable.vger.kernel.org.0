Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F23413FAF
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhIVCnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhIVCni (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:43:38 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6BDC061575;
        Tue, 21 Sep 2021 19:42:09 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s11so1068786pgr.11;
        Tue, 21 Sep 2021 19:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=djejlpVOIGzKbthvgtCBLVMqxVWv3M+bkRfIAVuPSTo=;
        b=BwE61WyczsegttDH6jkSEPZUC3QU64hXktKXc17MZtGG2hnKXWYSAKL6Fk+iCv7Yxp
         AqXGs8/p1xLSyGBCZ+Of/LPN5ofrIp4vYO/bvXncqwDHZDPZnFbyN9m1Vj7yu/ll7BX2
         tdu2GS9f/bcvtgwVrX7MHOSj4UXrgr89/2ToIsQ6CEymC3oE3gEIIA0ZHi9DuJabtq+J
         kgQ+fCbuvfs//P/8JzBSq7eAH58jCg3+AyfybLvSusAyZa9YLjHfvt/gdG2aktoXYW5C
         znxp86S9g+GAG1Jrsofd55/Np8JlqlsyMfGUpn8E273ObI+AkFjJ+pkQ2j9Y0MKeFHYh
         1BuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=djejlpVOIGzKbthvgtCBLVMqxVWv3M+bkRfIAVuPSTo=;
        b=slFhJrenMrfBaqP2lmFy7BK5//VhTCO67r9Z2AHG+HuwqtpExE7lGB6n1loT/FCFyD
         v/jKZRXghd3GMnDpQ4xoYHaDy8o3IBz6WEnjYXOOE1uMjYHc03Xewb+SAjiNd52c0c7z
         XNSiAz3weto8DS0WJVp9fB4Ds63CHkD5FejxiKl9tEEUGbTFKjcju72X85oPClL08v+h
         NFgr9G0m3r8uPBE4Ekg1RA9fE2DE5Lt0+a1HB1cXBNaiLx39drTHtG+yTstkncbkifQC
         D2DwQvx6tr/S9J8kIZ0dTD9CJ1w7vkJ/t2vnZcFO8vGUYVJRom2J+KHEqo8gRQ1YcKxs
         BO5Q==
X-Gm-Message-State: AOAM530QZGcLH1C4grteKhpeLWgnxJJPk0QoeN+6ty0CU8vp+yZ2Nd12
        ouVFQNqLyGZI9Q7cqNKaJLm5fE6b0KU=
X-Google-Smtp-Source: ABdhPJzKn6a3OApcbbpcL+KjXDuVG9HNHa9qoFL+pOTAYpazt8GucNET78e4NMe4wzp8wG5IEfRQew==
X-Received: by 2002:a62:6493:0:b0:43c:e252:3dfc with SMTP id y141-20020a626493000000b0043ce2523dfcmr32937769pfb.60.1632278528559;
        Tue, 21 Sep 2021 19:42:08 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 23sm445798pfw.97.2021.09.21.19.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:42:08 -0700 (PDT)
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
Subject: [PATCH stable 4.9 0/3] ARM: ftrace MODULE_PLTS warning fixes
Date:   Tue, 21 Sep 2021 19:41:54 -0700
Message-Id: <20210922024157.60001-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series is present in v5.14 and fixes warnings seen at insmod
with FTRACE and MODULE_PLTS enabled on ARM/Linux.

Alexander Sverdlin (3):
  ARM: 9077/1: PLT: Move struct plt_entries definition to header
  ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
  ARM: 9079/1: ftrace: Add MODULE_PLTS support

 arch/arm/include/asm/ftrace.h |  3 +++
 arch/arm/include/asm/insn.h   |  8 +++---
 arch/arm/include/asm/module.h | 10 +++++++
 arch/arm/kernel/ftrace.c      | 45 +++++++++++++++++++++++++++-----
 arch/arm/kernel/insn.c        | 19 +++++++-------
 arch/arm/kernel/module-plts.c | 49 +++++++++++++++++++++++++++--------
 6 files changed, 103 insertions(+), 31 deletions(-)

-- 
2.25.1

