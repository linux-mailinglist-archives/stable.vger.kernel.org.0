Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8082B9E64
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgKSXfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgKSXfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:35:22 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC7BC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:20 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id i13so5663522pgm.9
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rStsmNBqR+u8n/QTNsX5Xu/n6cFSi1nWwPG8W4XdpmA=;
        b=U7QaquLYi+4eciTgejBCb1zcwI2ES3rXwOK5sRPwTYeZ0Hp29HneG9XQV3aqnuMDW/
         NXqgU6mqQNL15TYKFcbtKxe8sEJws/YTj7pNPAULACZORRAMjoAv8hLWxFfZ+VMm+hBe
         CHYoRVIupXXeQUfY4F2pLbqemAndAfiN6L3t0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rStsmNBqR+u8n/QTNsX5Xu/n6cFSi1nWwPG8W4XdpmA=;
        b=oPOZYz07fokwNHjJyPfj2UF9vyCN7+h/3OYAXTfWvzUTM7Dd845iPHmDNKXOugaNNU
         NBt/ZPt6sfNfHatPE6LUsw0pya28r97yrO+uih5by5EwKN/0ntK8V9kpnW9Ek7pEp0xh
         2TkXgw8lxgLMhwztEGpkss0x1ZkqIJQYbgvSA6XeHrTev2pevvewBt7lOWjiFp/WMdTQ
         BZu8kDBdd6t8W6LXi6b2wpIgy8Ce2zmSa74odiJ5nEFCHzmr73iEbNJsfP1AypqBKkdf
         485u4r9vD/AgudY9X0UMn4X2yghD1IkeuVgVwuBVXgjV6iTEQIU6QFMoGfVc02H61Mt7
         OIqw==
X-Gm-Message-State: AOAM531tc/xs+0Z0ltY9C73ZtAkDhfbs2t/4DrTek3a1AlyRfij7c0J5
        gShKqR8dEF92PdKX8KPe1WW69taQ1wjHfQ==
X-Google-Smtp-Source: ABdhPJw+IHsiAzBPc8WV8x/ewycRD3Tkif4T4nD7ZY1g962JXbR/SwrFLfQt9DQ9s4MCHNUbM6QhHg==
X-Received: by 2002:a17:90a:9f8c:: with SMTP id o12mr6867326pjp.79.1605828920099;
        Thu, 19 Nov 2020 15:35:20 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id c2sm1058747pfi.21.2020.11.19.15.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:35:19 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 5.4 0/5] CVE-2020-4788: Speculation on incompletely validated data on IBM Power9
Date:   Fri, 20 Nov 2020 10:35:11 +1100
Message-Id: <20201119233516.368194-1-dja@axtens.net>
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
 .../powerpc/include/asm/book3s/64/kup-radix.h |  29 ++--
 arch/powerpc/include/asm/exception-64s.h      |  12 +-
 arch/powerpc/include/asm/feature-fixups.h     |  19 ++
 arch/powerpc/include/asm/kup.h                |  27 ++-
 arch/powerpc/include/asm/security_features.h  |   7 +
 arch/powerpc/include/asm/setup.h              |   4 +
 arch/powerpc/kernel/exceptions-64s.S          |  88 +++++-----
 arch/powerpc/kernel/setup_64.c                | 122 ++++++++++++-
 arch/powerpc/kernel/vmlinux.lds.S             |  14 ++
 arch/powerpc/lib/feature-fixups.c             | 104 +++++++++++
 arch/powerpc/platforms/powernv/setup.c        |  17 ++
 arch/powerpc/platforms/pseries/setup.c        |   8 +
 .../selftests/powerpc/security/.gitignore     |   1 +
 .../selftests/powerpc/security/Makefile       |   2 +-
 .../selftests/powerpc/security/entry_flush.c  | 163 ++++++++++++++++++
 .../selftests/powerpc/security/rfi_flush.c    |  35 +++-
 17 files changed, 592 insertions(+), 67 deletions(-)
 create mode 100644 tools/testing/selftests/powerpc/security/entry_flush.c

-- 
2.25.1

