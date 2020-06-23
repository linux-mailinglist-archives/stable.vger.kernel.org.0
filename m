Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44D22058E2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387566AbgFWRgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387558AbgFWRgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:36:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69C5120780;
        Tue, 23 Jun 2020 17:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933783;
        bh=OdrbbhhWQZGnY0NNBfY4QgSV2sGEsBiGQfBbE3xbNg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6/lM0d78cXaXGDSaycKVxeZBUDK6AjOfeCRssRREkSxShzFjjHsBpey215ex8S94
         hMeri2Xz7BD2DEDDI+UypK6/PGJYbghvo9X20VqdRd3A/hpQnFyvW8PajGgBOtWW8R
         COO0pWehyDgdpIrImABiAQhwr9/fy7cupOj4G3Gg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/24] kbuild: improve cc-option to clean up all temporary files
Date:   Tue, 23 Jun 2020 13:35:54 -0400
Message-Id: <20200623173559.1355728-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173559.1355728-1-sashal@kernel.org>
References: <20200623173559.1355728-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit f2f02ebd8f3833626642688b2d2c6a7b3c141fa9 ]

When cc-option and friends evaluate compiler flags, the temporary file
$$TMP is created as an output object, and automatically cleaned up.
The actual file path of $$TMP is .<pid>.tmp, here <pid> is the process
ID of $(shell ...) invoked from cc-option. (Please note $$$$ is the
escape sequence of $$).

Such garbage files are cleaned up in most cases, but some compiler flags
create additional output files.

For example, -gsplit-dwarf creates a .dwo file.

When CONFIG_DEBUG_INFO_SPLIT=y, you will see a bunch of .<pid>.dwo files
left in the top of build directories. You may not notice them unless you
do 'ls -a', but the garbage files will increase every time you run 'make'.

This commit changes the temporary object path to .tmp_<pid>/tmp, and
removes .tmp_<pid> directory when exiting. Separate build artifacts such
as *.dwo will be cleaned up all together because their file paths are
usually determined based on the base name of the object.

Another example is -ftest-coverage, which outputs the coverage data into
<base-name-of-object>.gcno

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Kbuild.include | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index d1dd4a6b6adb6..7da10afc92c61 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -82,20 +82,21 @@ cc-cross-prefix = $(firstword $(foreach c, $(1), \
 			$(if $(shell command -v -- $(c)gcc 2>/dev/null), $(c))))
 
 # output directory for tests below
-TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)
+TMPOUT = $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/).tmp_$$$$
 
 # try-run
 # Usage: option = $(call try-run, $(CC)...-o "$$TMP",option-ok,otherwise)
 # Exit code chooses option. "$$TMP" serves as a temporary file and is
 # automatically cleaned up.
 try-run = $(shell set -e;		\
-	TMP="$(TMPOUT).$$$$.tmp";	\
-	TMPO="$(TMPOUT).$$$$.o";	\
+	TMP=$(TMPOUT)/tmp;		\
+	TMPO=$(TMPOUT)/tmp.o;		\
+	mkdir -p $(TMPOUT);		\
+	trap "rm -rf $(TMPOUT)" EXIT;	\
 	if ($(1)) >/dev/null 2>&1;	\
 	then echo "$(2)";		\
 	else echo "$(3)";		\
-	fi;				\
-	rm -f "$$TMP" "$$TMPO")
+	fi)
 
 # as-option
 # Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
-- 
2.25.1

