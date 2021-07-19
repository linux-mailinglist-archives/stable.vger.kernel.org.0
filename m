Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C3E3CE392
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbhGSPkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349076AbhGSPfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5340B610D0;
        Mon, 19 Jul 2021 16:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711375;
        bh=Mpq3AmYAT6nnSPIVQugAsnSv5AgE0ayoFpUJOym7+/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C82GilkXUTI1+vTEvlDxicUmguWIZakv2xYc7RxAeTHYYT9lkej2xkNrzw1ZmOQOa
         qKSAgoJHA48XJjWfPkIwbAKMdzI6+Ss5LOBSUEqMS+F99NvuAXX4pSV743v8vNi2RR
         re2qW6QgJmpsSrC4S8e9FKkHrUr7WYg76st6PlLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 330/351] kbuild: remove trailing slashes from $(KBUILD_EXTMOD)
Date:   Mon, 19 Jul 2021 16:54:36 +0200
Message-Id: <20210719144955.978189599@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 74ee585b7eecd98be3650e677625a0ee588d08e0 ]

M= (or KBUILD_EXTMOD) generally expects a directory path without any
trailing slashes, like M=a/b/c.

If you add a trailing slash, like M=a/b/c/, you will get ugly build
logs (two slashes in a series), but it still works fine as long as it
is consistent between 'make modules' and 'make modules_install'.

The following commands correctly build and install the modules.

  $ make M=a/b/c/ modules
  $ sudo make M=a/b/c/ modules_install

Since commit ccae4cfa7bfb ("kbuild: refactor scripts/Makefile.modinst"),
a problem happens if you add a trailing slash only for modules_install.

  $ make M=a/b/c modules
  $ sudo make M=a/b/c/ modules_install

No module is installed in this case, Johannes Berg reported. [1]

Trim any trailing slashes from $(KBUILD_EXTMOD).

I used the 'dirname' command to remove all the trailing slashes in
case someone adds more slashes like M=a/b/c/////. The Make's built-in
function, $(dir ...) cannot take care of such a case.

[1]: https://lore.kernel.org/lkml/10cc8522b27a051e6a9c3e158a4c4b6414fd04a0.camel@sipsolutions.net/

Fixes: ccae4cfa7bfb ("kbuild: refactor scripts/Makefile.modinst")
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Makefile b/Makefile
index 83f4212e004f..4258a60f6119 100644
--- a/Makefile
+++ b/Makefile
@@ -129,6 +129,11 @@ endif
 $(if $(word 2, $(KBUILD_EXTMOD)), \
 	$(error building multiple external modules is not supported))
 
+# Remove trailing slashes
+ifneq ($(filter %/, $(KBUILD_EXTMOD)),)
+KBUILD_EXTMOD := $(shell dirname $(KBUILD_EXTMOD).)
+endif
+
 export KBUILD_EXTMOD
 
 # Kbuild will save output files in the current working directory.
-- 
2.30.2



