Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E573E8155
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbhHJR6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235287AbhHJR4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:56:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1986861373;
        Tue, 10 Aug 2021 17:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617510;
        bh=LzN8h3QUBT0+yFbN/7lI2jC5K3HR9//KGqZ/8sk/A0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFnf7yr4VEADKwmZzHHpGYL8oVgmzTvSWslqPjn239zS2gwI1M0+JRkoFEgJhXUb9
         Hh8I+WGU850ZgB1t1/y8uS/yyvzHDlHHW5EzkTSHe/DD+9lTgLPL5IQwWpnj9xwWCi
         kReUu6F72VYMrEHhYLc/aGMsFq3WVIPBsK3jDOes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John S Gruber <johnsgruber@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 063/175] kbuild: cancel sub_make_done for the install target to fix DKMS
Date:   Tue, 10 Aug 2021 19:29:31 +0200
Message-Id: <20210810173003.020042754@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 14ccc638b02f9ec500c17d9e39efe979145a4b61 ]

Since commit bcf637f54f6d ("kbuild: parse C= and M= before changing the
working directory"), external module builds invoked by DKMS fail because
M= option is not parsed.

I wanted to add 'unset sub_make_done' in install.sh but similar scripts,
arch/*/boot/install.sh, are duplicated, so I set sub_make_done empty in
the top Makefile.

Fixes: bcf637f54f6d ("kbuild: parse C= and M= before changing the working directory")
Reported-by: John S Gruber <johnsgruber@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: John S Gruber <johnsgruber@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Makefile b/Makefile
index 9d810e13a83f..218f44d7fc80 100644
--- a/Makefile
+++ b/Makefile
@@ -1366,6 +1366,15 @@ scripts_unifdef: scripts_basic
 	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
 
 # ---------------------------------------------------------------------------
+# Install
+
+# Many distributions have the custom install script, /sbin/installkernel.
+# If DKMS is installed, 'make install' will eventually recuses back
+# to the this Makefile to build and install external modules.
+# Cancel sub_make_done so that options such as M=, V=, etc. are parsed.
+
+install: sub_make_done :=
+
 # Kernel selftest
 
 PHONY += kselftest
-- 
2.30.2



