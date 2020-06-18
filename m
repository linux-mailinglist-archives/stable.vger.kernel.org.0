Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40871FDBD6
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgFRBPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbgFRBPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 274AB21D7E;
        Thu, 18 Jun 2020 01:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442901;
        bh=D93pV5GFvpRHLErS7J7MDSQ80njR/gHakMfqSDGt6Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zH+2hO0PHbcoILZQeyi2eH7UfHWKaNneGyRLnPBnoE8BHijGyxgSJT7KaB4pWrnXq
         GkFI9c2C9qeyZZ3Oj9hi9HBkcxhN8RIU8BZGaZwfLXfz0WjR+p6Lis3wkqDVTyKlsx
         0phP0wBUD/4mJBk7lXKgPhqQ5t74Qa7URtFYYqZ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 322/388] modpost: fix -i (--ignore-errors) MAKEFLAGS detection
Date:   Wed, 17 Jun 2020 21:06:59 -0400
Message-Id: <20200618010805.600873-322-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 91e6ee581270b8ae970f028b898314d73f16870b ]

$(filter -i,$(MAKEFLAGS)) works only in limited use-cases.

The representation of $(MAKEFLAGS) depends on various factors:
  - GNU Make version (version 3.8x or version 4.x)
  - The presence of other flags like -j

In my experiments, $(MAKEFLAGS) is expanded as follows:

  * GNU Make 3.8x:

    * without -j option:
      --no-print-directory -Rri

    * with -j option:
      --no-print-directory -Rr --jobserver-fds=3,4 -j -i

  * GNU Make 4.x:

    * without -j option:
      irR --no-print-directory

    * with -j option:
      irR -j --jobserver-fds=3,4 --no-print-directory

For GNU Make 4.x, the flags are grouped as 'irR', which does not work.

For the single thread build with GNU Make 3.8x, the flags are grouped
as '-Rri', which does not work either.

To make it work for all cases, do likewise as commit 6f0fa58e4596
("kbuild: simplify silent build (-s) detection").

BTW, since commit ff9b45c55b26 ("kbuild: modpost: read modules.order
instead of $(MODVERDIR)/*.mod"), you also need to pass -k option to
build final *.ko files. 'make -i -k' ignores compile errors in modules,
and build as many remaining *.ko as possible.

Please note this feature is kind of dangerous if other modules depend
on the broken module because the generated modules will lack the correct
module dependency or CRC. Honestly, I am not a big fan of it, but I am
keeping this feature.

Fixes: eed380f3f593 ("modpost: Optionally ignore secondary errors seen if a single module build fails")
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.modpost | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 957eed6a17a5..33aaa572f686 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -66,7 +66,7 @@ __modpost:
 
 else
 
-MODPOST += $(subst -i,-n,$(filter -i,$(MAKEFLAGS))) -s -T - \
+MODPOST += -s -T - \
 	$(if $(KBUILD_NSDEPS),-d $(MODULES_NSDEPS))
 
 ifeq ($(KBUILD_EXTMOD),)
@@ -82,6 +82,11 @@ include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
              $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
 endif
 
+# 'make -i -k' ignores compile errors, and builds as many modules as possible.
+ifneq ($(findstring i,$(filter-out --%,$(MAKEFLAGS))),)
+MODPOST += -n
+endif
+
 # find all modules listed in modules.order
 modules := $(sort $(shell cat $(MODORDER)))
 
-- 
2.25.1

