Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5583D6174
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhGZPb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237907AbhGZP32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1CAD60F6E;
        Mon, 26 Jul 2021 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315789;
        bh=kLv7WAjwTg8wAJhfsSxiyevIiTlTubskzz45JLD7Wng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnUStnm2Ae/gTyYsAhwNmXsVoUhagQPOLP7Em8BVZHXKOL2OuCxCeebYz9qvHJF8s
         nyrRpY+djUhWZvyXaQQpLR/wCeRsYozsLjSG9WKwAUghTRM8i7DcZOeMhU6BkFnRcS
         kWFwMJl2t6ddn75ToMld+dh+rm1PdhiuZ+N8xxSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lecopzer Chen <lecopzer.chen@mediatek.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 5.13 066/223] Kbuild: lto: fix module versionings mismatch in GNU make 3.X
Date:   Mon, 26 Jul 2021 17:37:38 +0200
Message-Id: <20210726153848.417277780@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lecopzer Chen <lecopzer.chen@mediatek.com>

[ Upstream commit 1d11053dc63094075bf9e4809fffd3bb5e72f9a6 ]

When building modules(CONFIG_...=m), I found some of module versions
are incorrect and set to 0.
This can be found in build log for first clean build which shows

WARNING: EXPORT symbol "XXXX" [drivers/XXX/XXX.ko] version generation failed,
symbol will not be versioned.

But in second build(incremental build), the WARNING disappeared and the
module version becomes valid CRC and make someone who want to change
modules without updating kernel image can't insert their modules.

The problematic code is
+	$(foreach n, $(filter-out FORCE,$^),				\
+		$(if $(wildcard $(n).symversions),			\
+			; cat $(n).symversions >> $@.symversions))

For example:
  rm -f fs/notify/built-in.a.symversions    ; rm -f fs/notify/built-in.a; \
llvm-ar cDPrST fs/notify/built-in.a fs/notify/fsnotify.o \
fs/notify/notification.o fs/notify/group.o ...

`foreach n` shows nothing to `cat` into $(n).symversions because
`if $(wildcard $(n).symversions)` return nothing, but actually
they do exist during this line was executed.

-rw-r--r-- 1 root root 168580 Jun 13 19:10 fs/notify/fsnotify.o
-rw-r--r-- 1 root root    111 Jun 13 19:10 fs/notify/fsnotify.o.symversions

The reason is the $(n).symversions are generated at runtime, but
Makefile wildcard function expends and checks the file exist or not
during parsing the Makefile.

Thus fix this by use `test` shell command to check the file
existence in runtime.

Rebase from both:
1. [https://lore.kernel.org/lkml/20210616080252.32046-1-lecopzer.chen@mediatek.com/]
2. [https://lore.kernel.org/lkml/20210702032943.7865-1-lecopzer.chen@mediatek.com/]

Fixes: 38e891849003 ("kbuild: lto: fix module versioning")
Co-developed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 34d257653fb4..c6bd62f518ff 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -388,7 +388,7 @@ ifeq ($(CONFIG_LTO_CLANG) $(CONFIG_MODVERSIONS),y y)
       cmd_update_lto_symversions =					\
 	rm -f $@.symversions						\
 	$(foreach n, $(filter-out FORCE,$^),				\
-		$(if $(wildcard $(n).symversions),			\
+		$(if $(shell test -s $(n).symversions && echo y),	\
 			; cat $(n).symversions >> $@.symversions))
 else
       cmd_update_lto_symversions = echo >/dev/null
-- 
2.30.2



