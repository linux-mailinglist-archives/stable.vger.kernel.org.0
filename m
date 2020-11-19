Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC1A2B9E0C
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgKSXWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgKSXWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:22:55 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BAFC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:22:55 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id d17so3833637plr.5
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6WP7owl5YyAwbnaSXUKfNjvwHw9UyqIlfArQ/XuRd8I=;
        b=HvvXuRy8h0/B/EHK5x6RKGWh88DR6Ewd5BV5lmJN3io40N30YJXk8NYqsGcw3GdVl0
         8a+oTkG9N7pZGYTmXIt02ZDytidF3nNwYVmw3Z24p3LwBm6wqvId4O1o3t9gD6sBas/R
         YJGxMQINDS2u0w9pP9CYIF/5v29tJ4IpNDV/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6WP7owl5YyAwbnaSXUKfNjvwHw9UyqIlfArQ/XuRd8I=;
        b=NZkIhDU9YCsuN4uMcZhNR3YA5Zegb6DkOW98b2xm7aoXkEqz/wT9YRL/UJGyg2nW+8
         87VEiICtVsycNcELvBuntnpBqACuRcp6hI8dryfiM/fW4GUDIsUrcz5jtzg9CqC6exg3
         r5ytB+82PmjwJfruMLfhJI+Rir5K+0f6/H1eI+HYpVrTxVft4SBdKNI7Toy90PMXaKXe
         ba91C7itzMq2xBTsJ3mKXsAZL/9Y0xdHmcOlUE06sCqKfS1VeiGcb4wsATiMPZIajcJY
         VwlcVa14IA/iGBOFy20yjcRqEmzzb+e+cfNX4+UhcvmJEp0lp0EM+sxDLxVX5cHHD3jJ
         7HkA==
X-Gm-Message-State: AOAM533VHa3jRH4jZ8CTRrFCAPEzH4D1x+2/A3N5jXfqBam6a//0qzJZ
        xW0nylO8X8foQ3DAQTTAjH1JRsC9XwGUkw==
X-Google-Smtp-Source: ABdhPJyuu6OI2lBEwqxSnnb89i66RC5ZN+NSg5iFS6x65CMX1nmD2pvOl2EU5YzBK7OTFZdT09aaqg==
X-Received: by 2002:a17:902:c281:b029:d7:ce5d:6406 with SMTP id i1-20020a170902c281b02900d7ce5d6406mr10815054pld.35.1605828174558;
        Thu, 19 Nov 2020 15:22:54 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id b13sm1054202pfo.15.2020.11.19.15.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:22:53 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 5.9 0/5] CVE-2020-4788: Speculation on incompletely validated data on IBM Power9
Date:   Fri, 20 Nov 2020 10:22:45 +1100
Message-Id: <20201119232250.365304-1-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IBM Power9 processors can speculatively operate on data in the L1
cache before it has been completely validated, via a way-prediction
mechanism. It is not possible for an attacker to determine the
contents of impermissible memory using this method, since these
systems implement a combination of hardware and software security
measures to prevent scenarios where protected data could be leaked.

However these measures don't address the scenario where an attacker
induces the operating system to speculatively execute instructions
using data that the attacker controls. This can be used for example to
speculatively bypass "kernel user access prevention" techniques, as
discovered by Anthony Steinhauser of Google's Safeside Project. This
is not an attack by itself, but there is a possibility it could be
used in conjunction with side-channels or other weaknesses in the
privileged code to construct an attack.

This issue can be mitigated by flushing the L1 cache between privilege
boundaries of concern. This series flushes the cache on kernel entry and
after kernel user accesses.

Thanks to Nick Piggin, Russell Currey, Christopher M. Riedl, Michael
Ellerman and Spoorthy S for their work in developing, optimising,
testing and backporting these fixes, and to the many others who helped
behind the scenes.

Daniel Axtens (1):
  selftests/powerpc: entry flush test

Michael Ellerman (1):
  powerpc: Only include kup-radix.h for 64-bit Book3S

Nicholas Piggin (2):
  powerpc/64s: flush L1D on kernel entry
  powerpc/64s: flush L1D after user accesses

Russell Currey (1):
  selftests/powerpc: rfi_flush: disable entry flush if present

 .../admin-guide/kernel-parameters.txt         |   7 +
 .../powerpc/include/asm/book3s/64/kup-radix.h |  66 +++---
 arch/powerpc/include/asm/exception-64s.h      |  12 +-
 arch/powerpc/include/asm/feature-fixups.h     |  19 ++
 arch/powerpc/include/asm/kup.h                |  26 ++-
 arch/powerpc/include/asm/security_features.h  |   7 +
 arch/powerpc/include/asm/setup.h              |   4 +
 arch/powerpc/kernel/exceptions-64s.S          |  80 +++----
 arch/powerpc/kernel/setup_64.c                | 122 ++++++++++-
 arch/powerpc/kernel/syscall_64.c              |   2 +-
 arch/powerpc/kernel/vmlinux.lds.S             |  14 ++
 arch/powerpc/lib/feature-fixups.c             | 104 +++++++++
 arch/powerpc/platforms/powernv/setup.c        |  17 ++
 arch/powerpc/platforms/pseries/setup.c        |   8 +
 .../selftests/powerpc/security/.gitignore     |   1 +
 .../selftests/powerpc/security/Makefile       |   2 +-
 .../selftests/powerpc/security/entry_flush.c  | 198 ++++++++++++++++++
 .../selftests/powerpc/security/rfi_flush.c    |  35 +++-
 18 files changed, 646 insertions(+), 78 deletions(-)
 create mode 100644 tools/testing/selftests/powerpc/security/entry_flush.c

-- 
2.25.1

