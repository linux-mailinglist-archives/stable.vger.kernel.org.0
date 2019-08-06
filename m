Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F13B83C21
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfHFVkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729139AbfHFVgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:36:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D83921872;
        Tue,  6 Aug 2019 21:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127412;
        bh=w3ngC3KJWZkUT1tEKcDAKTAJKNEh4FF8APwIg6eCV4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6iv/hdwyHPzG2ZUH49jjO6EbWMBge+BuSdvS8IHtrfiqcoKZlBqAgJ2xnSv0pQa8
         jGMT96ffqj8AjT9+Vw9sunG9tArbaAsVjOJY7bRnIzGNI1UStQyNzgx4xuIeYFrggF
         XSKt6H4n8zdyPEvxdPWQiGVawqsT9tsWqSAMU37M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/25] kbuild: modpost: handle KBUILD_EXTRA_SYMBOLS only for external modules
Date:   Tue,  6 Aug 2019 17:36:12 -0400
Message-Id: <20190806213624.20194-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213624.20194-1-sashal@kernel.org>
References: <20190806213624.20194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit cb4819934a7f9b87876f11ed05b8624c0114551b ]

KBUILD_EXTRA_SYMBOLS makes sense only when building external modules.
Moreover, the modpost sets 'external_module' if the -e option is given.

I replaced $(patsubst %, -e %,...) with simpler $(addprefix -e,...)
while I was here.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.modpost | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 991db7d6e4df8..cf6f33b2633d5 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -75,7 +75,7 @@ modpost = scripts/mod/modpost                    \
  $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
- $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(KBUILD_EXTRA_SYMBOLS))) \
+ $(if $(KBUILD_EXTMOD),$(addprefix -e ,$(KBUILD_EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(CONFIG_SECTION_MISMATCH_WARN_ONLY),,-E)  \
-- 
2.20.1

