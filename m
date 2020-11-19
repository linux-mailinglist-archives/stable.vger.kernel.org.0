Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB002B9EEB
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgKSX5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgKSX5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:57:47 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DEBC0613D4
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:57:47 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w4so5687693pgg.13
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QiL5RuXovHAy6bI5fhTj39tmpH0G5RvzPp63CdU0c6o=;
        b=oOEngAkg/viiCWPOPA5TeA1dagqhUV33grnAvWs+Q+eZcKj/ywVV/moaFfr7gLePSf
         ZeGA+4YgP4YBq62Wc4ftu5DQVehuM+K1dEusk1b/z8lMkKoDZnChKxDNRDBjRbXEFoSe
         R8tqwpHFsEHyVpxYC1TzGRBLr5RJ9Axdyr9lo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QiL5RuXovHAy6bI5fhTj39tmpH0G5RvzPp63CdU0c6o=;
        b=B5grUITtWl4e5H9Njo3UjfhWoHewhsAVsG0cp5m+CVxIdoMURKSeDlkQqbrKaayQs1
         oRIRdhgUUPdhHhAPULETLggHT823EGYXnA57UXeRw5FnJoGYUEcrR+VdqGvJ2+dn/9zM
         oF4wa6HWkf7yxqQeq167B0krcLS5LNIyOPzkOYTA/1JqU0COsrRFsin8+2NyAZmNS+JY
         HtQQfOGD5jZEGILhSK9sTfI0wZ8mYm3MEVZ2MiDsoA/snfX5ioQa3ddfPzGXkO5OKIXc
         Km2q8Omud1/PImddTdschbejkNXd+yR+JypHxtu3MxuXChbiid6+sCNaHy+m7/iqBWQX
         EPyg==
X-Gm-Message-State: AOAM533Cuqzvy7r7V2NXuMJWGPxr6NdBF7Mys0SH4VD/XSQKCe33jk8G
        pYrWZkWa3cFwzA2VRwkbs+lRJyJTE/U3Cw==
X-Google-Smtp-Source: ABdhPJwwfLvXk94VIHLRr+VGV9SwFebuurWa805LLY2Lzx9Zr9vCVOemO+O01XUFx9Ea4hQDumoxbQ==
X-Received: by 2002:aa7:9435:0:b029:195:f6a2:b610 with SMTP id y21-20020aa794350000b0290195f6a2b610mr11235092pfo.32.1605830266517;
        Thu, 19 Nov 2020 15:57:46 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id i130sm892977pgc.7.2020.11.19.15.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:57:46 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.9 0/8] CVE-2020-4788: Speculation on incompletely validated data on IBM Power9
Date:   Fri, 20 Nov 2020 10:57:35 +1100
Message-Id: <20201119235743.373635-1-dja@axtens.net>
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
 .../powerpc/include/asm/book3s/64/kup-radix.h |  22 +++
 arch/powerpc/include/asm/exception-64s.h      |  13 +-
 arch/powerpc/include/asm/feature-fixups.h     |  19 +++
 arch/powerpc/include/asm/futex.h              |   4 +
 arch/powerpc/include/asm/kup.h                |  40 +++++
 arch/powerpc/include/asm/security_features.h  |   7 +
 arch/powerpc/include/asm/setup.h              |   4 +
 arch/powerpc/include/asm/uaccess.h            | 143 ++++++++++++++----
 arch/powerpc/kernel/exceptions-64s.S          | 130 ++++++++--------
 arch/powerpc/kernel/setup_64.c                | 120 +++++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S             |  14 ++
 arch/powerpc/lib/checksum_wrappers.c          |   4 +
 arch/powerpc/lib/feature-fixups.c             | 104 +++++++++++++
 arch/powerpc/lib/string.S                     |   4 +-
 arch/powerpc/lib/string_64.S                  |   6 +-
 arch/powerpc/platforms/powernv/setup.c        |  15 ++
 arch/powerpc/platforms/pseries/setup.c        |   8 +
 18 files changed, 567 insertions(+), 97 deletions(-)
 create mode 100644 arch/powerpc/include/asm/book3s/64/kup-radix.h
 create mode 100644 arch/powerpc/include/asm/kup.h

-- 
2.25.1

