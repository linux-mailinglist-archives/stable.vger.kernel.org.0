Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CCC2B9E98
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgKSXmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgKSXmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:42:07 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15BAC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:42:07 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id p6so1480927plr.7
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYWnWbedHA7PjvZ5oFPrf4blweyPiAT1hgFfJmA8XV8=;
        b=cQUOsR+8dkz09Zd0tShhlxUKR++PegvzykmTPi0NEPGLoSukHGA5M9fU9DdF4+wjys
         zdjsYhBeN4Mkb09cvEI0xZJf5PHZiaREZG8W7azRhmdXZYQzkX7ArTWOCXIhpagbonXy
         aMj9MfjbNyK5q5e4Z6pgqdvBlNiiKUKvKlTRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYWnWbedHA7PjvZ5oFPrf4blweyPiAT1hgFfJmA8XV8=;
        b=gCw9XKQS+qe3tMgITi4uwtDBL628k7oZXwQ9EjuNMWs2QuzX02IadntZkTFPyfbYP9
         HzuizVyDDdeCbeAtFSH6OyTql4BEN7o+D6GAFSLI1UAXCxASPL3IZuua3u4dQ6dKu95k
         wUIIIYXbd/LL2/GYXd5EA0synz35ZnB5CoSeHQ5uFIU3G1/LC6heMIRaXY7uJejyTyI+
         aNyLtYbr8qoyOZozqv0CA3/cRHb1HPXZFhV6vKxl2OFXKVJqYzadnQimp9UK86TGUv30
         AYBlKTrcgUea1bb1GpUD2KPj98oJlYsI7EbwMi51AYUgHQloRtiW188TLXshRAODNv6j
         /Yxw==
X-Gm-Message-State: AOAM530yrhDDBlic/06Vpd074rfPUupH0BN0vGsoNHS0uLDxWiD9OSXg
        hhJ72B1dtB/hgkm7utVKIK6KA6a/ie4z1w==
X-Google-Smtp-Source: ABdhPJwKsD5o7b1K9hUtSfR1MPYtSR+osEg0XJMB7onvclL7cSMKYz5GIQgm7H3mHhK4+oN9QR0UuQ==
X-Received: by 2002:a17:902:7c12:b029:d6:ed57:fe13 with SMTP id x18-20020a1709027c12b02900d6ed57fe13mr10725326pll.59.1605829327005;
        Thu, 19 Nov 2020 15:42:07 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id k9sm1058442pfi.188.2020.11.19.15.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:42:06 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.19 0/7] CVE-2020-4788: Speculation on incompletely validated data on IBM Power9
Date:   Fri, 20 Nov 2020 10:41:56 +1100
Message-Id: <20201119234203.370400-1-dja@axtens.net>
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

Andrew Donnellan (1):
  powerpc: Fix __clear_user() with KUAP enabled

Christophe Leroy (2):
  powerpc: Add a framework for user access tracking
  powerpc: Implement user_access_begin and friends

Daniel Axtens (1):
  powerpc/64s: move some exception handlers out of line

Nicholas Piggin (3):
  powerpc/64s: flush L1D on kernel entry
  powerpc/uaccess: Evaluate macro arguments once, before user access is
    allowed
  powerpc/64s: flush L1D after user accesses

 .../admin-guide/kernel-parameters.txt         |   7 +
 .../powerpc/include/asm/book3s/64/kup-radix.h |  22 +++
 arch/powerpc/include/asm/exception-64s.h      |   9 +-
 arch/powerpc/include/asm/feature-fixups.h     |  19 +++
 arch/powerpc/include/asm/futex.h              |   4 +
 arch/powerpc/include/asm/kup.h                |  40 +++++
 arch/powerpc/include/asm/security_features.h  |   7 +
 arch/powerpc/include/asm/setup.h              |   4 +
 arch/powerpc/include/asm/uaccess.h            | 147 ++++++++++++++----
 arch/powerpc/kernel/exceptions-64s.S          |  96 +++++++-----
 arch/powerpc/kernel/setup_64.c                | 122 ++++++++++++++-
 arch/powerpc/kernel/vmlinux.lds.S             |  14 ++
 arch/powerpc/lib/checksum_wrappers.c          |   4 +
 arch/powerpc/lib/feature-fixups.c             | 104 +++++++++++++
 arch/powerpc/lib/string_32.S                  |   4 +-
 arch/powerpc/lib/string_64.S                  |   6 +-
 arch/powerpc/platforms/powernv/setup.c        |  17 ++
 arch/powerpc/platforms/pseries/setup.c        |   8 +
 18 files changed, 553 insertions(+), 81 deletions(-)
 create mode 100644 arch/powerpc/include/asm/book3s/64/kup-radix.h
 create mode 100644 arch/powerpc/include/asm/kup.h

-- 
2.25.1

