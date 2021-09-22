Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE8C413F96
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhIVCmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhIVCl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:41:59 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F20C061574;
        Tue, 21 Sep 2021 19:40:30 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 145so1362764pfz.11;
        Tue, 21 Sep 2021 19:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFHgXjDcWJ3G8g70ezF4SC+fF65z/HHpwkA2EEyQfG0=;
        b=ecXTE7t5FKcZv/9KAdcMsYRqO5N5cVW7T1xbXUt+ISvO/L1AT89giGCghpMO50vQAF
         5xj8LbaUIvS9OxTh1qbSJVO6L9HM6eUfql5rY7jKTmoXPy1sdSPfgjYir+oQf66gIvBp
         3bzHeS8aeBvlPMwmtv1Y/wSYKiMmQQDcQwvRzOOhchPhPDg36GLiZOIkoM9+9ATeRrdD
         2L0f2/6wbeD/Qnrjvgo9wVF9z8nIsdGAucFJbu677XSnAqdAjRuOT8qPdo5O7SLFzds7
         +/3c460r+mkfLZJekUfOXZNYksPVOLQEGrRBFmPooZFWe4iV1AWg5r/4kcvd6jyw4dvQ
         tl7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFHgXjDcWJ3G8g70ezF4SC+fF65z/HHpwkA2EEyQfG0=;
        b=jd9M7ngzlOhyxxvo5o215ayZrxjmwG90Rut+YK0Cw6hvYEgoaqLsdK1CgicgZEcabp
         VNs5RFEoQhSSCF6+4lzRJMfZ3IoI45VMZXPZfRf9D1Fp2WE0XSu3ob6FP8iZKHXWv9wr
         0Dmp01qxYR7w9/MV8/6/E8O3EBuN1inaIfRsxeEGRLlz/T1Pennz2PlbZMuygxjhBaOa
         6yu3KJD/t10dSIW0Ic54SQByTdasToIzc/0YwNOtseQMhYR8FtU6a1XKRM7g8KudTRRI
         eIYOvpeVxZg9ESOUQ5pfdMIcSnHVCjtjznnY/jI4ptV7UNvFQtjV9nfWgYlJUfzanGy7
         jGcQ==
X-Gm-Message-State: AOAM532/+EJt0CkkvocGINN6EMrjmmrQNF3hi5sZjb5JyyuztdK9AxBe
        XWrinLYc7hYcRECJcIUUY5joK0sOYMY=
X-Google-Smtp-Source: ABdhPJwY0OBtjBq/oJyyLvIMVD2cJWVGEaMe3AOmJ4JxVcvkrVOmBVSUNyYMHmQsKdyMN4NcSG/LSg==
X-Received: by 2002:a05:6a00:15c8:b0:441:b4f1:652e with SMTP id o8-20020a056a0015c800b00441b4f1652emr31388893pfu.74.1632278429877;
        Tue, 21 Sep 2021 19:40:29 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b85sm438328pfb.0.2021.09.21.19.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:40:29 -0700 (PDT)
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
Subject: [PATCH stable 5.4 0/3] ARM: ftrace MODULE_PLTS warning fixes
Date:   Tue, 21 Sep 2021 19:40:16 -0700
Message-Id: <20210922024019.59726-1-f.fainelli@gmail.com>
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

