Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B327483BE1
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfHFVie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbfHFViI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:38:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE9CF2189D;
        Tue,  6 Aug 2019 21:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127487;
        bh=kZNJw0eCXlGn7+HslIMV99ipbELnDDDiwrkO3ZxK5Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFj+RKc5IA2jEbvGbxSpYBXVPKotqPrapTwQpDUz8vzWYgmb8euASD2v7pxSKWapr
         0GNkES8BWowyASymDj4SS9+ziLMoDJHy3jRPFeP4dO+6yEVMa/90xnr38kihZFyfZv
         cU36iNChqX/eWRFoOhWvuOvXAprVrJb5oYfNtKro=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/14] kbuild: modpost: handle KBUILD_EXTRA_SYMBOLS only for external modules
Date:   Tue,  6 Aug 2019 17:37:44 -0400
Message-Id: <20190806213749.20689-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213749.20689-1-sashal@kernel.org>
References: <20190806213749.20689-1-sashal@kernel.org>
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
index 1366a94b6c395..7718a64b1cd15 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -74,7 +74,7 @@ modpost = scripts/mod/modpost                    \
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

