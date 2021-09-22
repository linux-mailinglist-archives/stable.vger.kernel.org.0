Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD5C414E91
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhIVRDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbhIVRDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:03:17 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9657DC061574;
        Wed, 22 Sep 2021 10:01:47 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y8so3251546pfa.7;
        Wed, 22 Sep 2021 10:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5/G0wNYSsPonzPykbqlENShLiJ+dcmYAQjyK7QqizU=;
        b=YI+skPwF1xS+eCcWi/fmHjUPcQ43JsPysilOr/P5Y1iqh9Ve+PI6j//qGwWKwlejxA
         IecIl4kiRvTF/xIpIFWq/F0BH0DL8t+BWXHzaIFT79eH3ckNJ9qd4ZxDbEVHiooKvd62
         kztSa9BTVYcx3dDDhW4R1pVjkbX/Rdz6ww/bWuxrqSkShgUUQYfFUf2LalGFsJWIlc49
         981cI3b4oz921h3c8HztRiX07fX6W3ewAPy66VWYDkkA587THOuioZ7ntXfqfYiaEhFx
         SS+kSy1JKlqVKakwTP6PUczfwdhh0kcFUpuCkusYF62uHcmECXw77kP1TAM8aQxY12K2
         Fcjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5/G0wNYSsPonzPykbqlENShLiJ+dcmYAQjyK7QqizU=;
        b=J0iu25lgGW41ipb8raeOdIsonWUMYKu/4yrBlCAGqYtHRdEvNyd/KT2a8k49dMb7I9
         xDPJAajZ+uuMlGkBMJnyFBUpPorsZnP+gGyDxW/M6lCLbf/7+BYbnYsIC4er2AffRc6l
         jTpzAlKrCMWbA9XI76+J/YNDq2ijIHl5ZRrVkr7rWX0Jxj5RhX3qKdebj9e3XKtgNUWl
         IaA3IAq+JN0Mz/cv5twl18PzBm2T8VMAdJX2LlqhlsHxpPI8TPIxBvayyDONQJqHaR9T
         Z+c/k8i7eXT7Ew4IcBmCJcUelOxGzKUuwbfGKGaxIBr0hdyXZLBV460s57S2T8nVntop
         KWLg==
X-Gm-Message-State: AOAM533RSKjJLFWLimP6+0hagB5BpbebbUCtiysaAS8cllGZnzNxgnFT
        5ae+A2dnxAQDejpCFvgKYGGVv26YQ9Q=
X-Google-Smtp-Source: ABdhPJzsxXns6nX/LBL1pzMjnCpKp0r1iGaaB/+baTl6oZpTofKtMEMMaFMWmUK2I4SHKcntTOYKlw==
X-Received: by 2002:a63:e74b:: with SMTP id j11mr646551pgk.322.1632330106763;
        Wed, 22 Sep 2021 10:01:46 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j7sm3101087pfh.168.2021.09.22.10.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:01:46 -0700 (PDT)
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
Subject: [PATCH stable 4.19 v2 0/4] ARM: ftrace MODULE_PLTS warning
Date:   Wed, 22 Sep 2021 10:01:24 -0700
Message-Id: <20210922170128.190321-1-f.fainelli@gmail.com>
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

