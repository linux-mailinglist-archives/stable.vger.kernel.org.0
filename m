Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118392B9EB0
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgKSXwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgKSXwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:52:49 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B982C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:52:49 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so6102050pfu.1
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eYXvMyHWBVoY+WzFyM2nyBJSi53kaZ7lO+5m6H0cv98=;
        b=aGyNcXJTjUCpbZwYGY6S5ifXoqipapdduPsnRLRsokvkuRtv5E/eRS3aQkMwUCsiF1
         76SqxxKsBgvTcJRZoEVM0gbRAGhX67Yz3GeaboXFppdm+llR/2rU60EjiGWvk4sWVgHP
         cxBypGd7BVrFUCoTrTFHb19OwqwK+/7DIy0Po=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eYXvMyHWBVoY+WzFyM2nyBJSi53kaZ7lO+5m6H0cv98=;
        b=TW1/N/DppokVEDVLkbzyAEzRl9W5pQsPq+H1krq5LcclUoTdC75P1OOuFkjKvISPg/
         wDWoJF9znyvghie8hsY1r7BpKxC1KJlTPG+Qaz6lC2iWkydGC9Py2WWzbsfkc64vn01D
         ItuEu5iyOeNONMKZ6csnr0V+t4mrD6S+8XbRpIPCm583wNNURV/DNiEmYUY7ujqGc7I2
         BjTFf4I9SztedaW4x0X4mkkbG+erahmelQ23kKD8fG7EGsA2ddu03WKPQh8xGQ+sYuH6
         1p+8j/+2th7iQkZlA4qJOK0n2wljR+AOkM+xcU/Tv7SnrCv2kOy02ZM1Y1qbIZbBiHDq
         vZXw==
X-Gm-Message-State: AOAM532xS273n6SirwMayNRuPTITncOnR9oIEx45RfjBBdOLLnxZw2W2
        E/JCxLOwVr7/Aefl1307j8OPemUKuokTSQ==
X-Google-Smtp-Source: ABdhPJwqLpkdXziDYeiW/MQqmSmuBQnlYEd4+SVQfqNAZyrJR/WohYA+aa5P+xPUmqsDYc68Xf8U6w==
X-Received: by 2002:a63:da18:: with SMTP id c24mr14845100pgh.12.1605829968620;
        Thu, 19 Nov 2020 15:52:48 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id gg19sm971354pjb.21.2020.11.19.15.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:52:47 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.14 0/8] CVE-2020-4788: Speculation on incompletely validated data on IBM Power9
Date:   Fri, 20 Nov 2020 10:52:36 +1100
Message-Id: <20201119235244.373127-1-dja@axtens.net>
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

 .../admin-guide/kernel-parameters.txt         |   7 +
 .../powerpc/include/asm/book3s/64/kup-radix.h |  22 +++
 arch/powerpc/include/asm/exception-64s.h      |  13 +-
 arch/powerpc/include/asm/feature-fixups.h     |  19 +++
 arch/powerpc/include/asm/futex.h              |   4 +
 arch/powerpc/include/asm/kup.h                |  40 +++++
 arch/powerpc/include/asm/security_features.h  |   7 +
 arch/powerpc/include/asm/setup.h              |   4 +
 arch/powerpc/include/asm/uaccess.h            | 148 ++++++++++++++----
 arch/powerpc/kernel/exceptions-64s.S          |  96 +++++++-----
 arch/powerpc/kernel/setup_64.c                | 122 ++++++++++++++-
 arch/powerpc/kernel/vmlinux.lds.S             |  14 ++
 arch/powerpc/lib/checksum_wrappers.c          |   4 +
 arch/powerpc/lib/feature-fixups.c             | 104 ++++++++++++
 arch/powerpc/lib/string.S                     |   4 +-
 arch/powerpc/lib/string_64.S                  |   6 +-
 arch/powerpc/platforms/powernv/setup.c        |  17 ++
 arch/powerpc/platforms/pseries/setup.c        |   8 +
 18 files changed, 558 insertions(+), 81 deletions(-)
 create mode 100644 arch/powerpc/include/asm/book3s/64/kup-radix.h
 create mode 100644 arch/powerpc/include/asm/kup.h

-- 
2.25.1

