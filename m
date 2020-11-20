Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45892B9EFE
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 01:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgKTAHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 19:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgKTAHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 19:07:08 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0B0C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:08 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id x15so3898657pll.2
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ottYxhQz7cOA1vxqA+YBA5YYnnigFcEsIL44kPiPUhs=;
        b=CKJTiKQFzHsfBj90VrDOl3V2OgnoKBxxVrT1Y3/byzXDEuut8tuDqRrX8nChL5hDCS
         LbiVu6tGNQWVnyyNg+Y1AWiNfNkt6+MhuFARbuDZnctOEWkb7pp7jaY4wr7BKds0aYJL
         z0m/TTVov4H1r32VXYAX9Bzsn8Xk7b2q5cetU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ottYxhQz7cOA1vxqA+YBA5YYnnigFcEsIL44kPiPUhs=;
        b=dPLDxtY/JJza0ttAWRsip3XG8dDK/UuX10YSEtH+qWo99jAFzeg1Kbjj/wnKZaB265
         NpXbiGPywq/kGMOBizXUpOP2yMDJ52adf/pHfg0Limlut+tWZg8NhNzAXYZrsxh2IryY
         BeS+MeG5T7c9cHRMrMpioCrPByCv9IReZgjmiOwFvl7NI5hh0NocBDRLJr8Dld/uVPPB
         ucRjG55LRw33ETJvGXAacwUJU0OY/hbBk5GD7U8gONDW3mZs2tFA3BL9Ehl6CXYwjINH
         rVXWcQswUkQcOW2m24HHQIMGkHloIkh029iy9J0ZpTQv+cpPB5a6o52dgVNNOD1gU3Xp
         2Qgw==
X-Gm-Message-State: AOAM532LYERAhAW2qvU89mr2xUrwUqMlTdtY+uFsMGQLhlmgd/UXpzj9
        tS99GL+Vqpj4vXyxmJX0ar95L1psCploGA==
X-Google-Smtp-Source: ABdhPJyp7Jf05NUCG4Y8vJ4DY+6n3qfXTZeW3PUHmqOfx+MX2bqlFAz6prYtDVb6E+x1MwWdW9fh3w==
X-Received: by 2002:a17:902:7283:b029:d7:e4f5:adc7 with SMTP id d3-20020a1709027283b02900d7e4f5adc7mr11489525pll.20.1605830828195;
        Thu, 19 Nov 2020 16:07:08 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id e22sm928237pjh.45.2020.11.19.16.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 16:07:07 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.4 0/8] CVE-2020-4788: Speculation on incompletely validated data on IBM Power9
Date:   Fri, 20 Nov 2020 11:06:56 +1100
Message-Id: <20201120000704.374811-1-dja@axtens.net>
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

Daniel Axtens (2):
  powerpc/64s: Define MASKABLE_RELON_EXCEPTION_PSERIES_OOL
  powerpc/64s: move some exception handlers out of line

Nicholas Piggin (3):
  powerpc/64s: flush L1D on kernel entry
  powerpc/uaccess: Evaluate macro arguments once, before user access is
    allowed
  powerpc/64s: flush L1D after user accesses

 Documentation/kernel-parameters.txt           |   7 +
 .../powerpc/include/asm/book3s/64/kup-radix.h |  23 ++
 arch/powerpc/include/asm/exception-64s.h      |  15 +-
 arch/powerpc/include/asm/feature-fixups.h     |  19 ++
 arch/powerpc/include/asm/futex.h              |   4 +
 arch/powerpc/include/asm/kup.h                |  40 ++++
 arch/powerpc/include/asm/security_features.h  |   7 +
 arch/powerpc/include/asm/setup.h              |   4 +
 arch/powerpc/include/asm/uaccess.h            | 142 +++++++++---
 arch/powerpc/kernel/exceptions-64s.S          | 210 +++++++++++-------
 arch/powerpc/kernel/ppc_ksyms.c               |  10 +
 arch/powerpc/kernel/setup_64.c                | 138 ++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S             |  14 ++
 arch/powerpc/lib/checksum_wrappers_64.c       |   4 +
 arch/powerpc/lib/feature-fixups.c             | 104 +++++++++
 arch/powerpc/lib/string.S                     |   2 +-
 arch/powerpc/lib/string_64.S                  |   4 +-
 arch/powerpc/platforms/powernv/setup.c        |  15 ++
 arch/powerpc/platforms/pseries/setup.c        |   8 +
 19 files changed, 653 insertions(+), 117 deletions(-)
 create mode 100644 arch/powerpc/include/asm/book3s/64/kup-radix.h
 create mode 100644 arch/powerpc/include/asm/kup.h

-- 
2.25.1

