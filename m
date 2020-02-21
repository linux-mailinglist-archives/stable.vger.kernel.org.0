Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFDC167225
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbgBUIAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:32840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731083AbgBUIAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:00:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CDCA24656;
        Fri, 21 Feb 2020 08:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272038;
        bh=JNauHAvaIQrf67Yp3oEq2kwzb5rdyPaYy0dgHVuKJ/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmWOohD+/fq8AQk2mj3bIsM+rnb8EDWa68FWNMXb1ty1bl3N6uWxEJSoMpMnrSopi
         2vy8CAtRq5QegvVT47TE3KXkPEbCCeonBWHhj+eRkzxm9guN/VfRczQMgTdJO23qNL
         mhh+dCi05PXaAFPufjJXFg03zSWRi55pZ7Tejcz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 391/399] kbuild: make multiple directory targets work
Date:   Fri, 21 Feb 2020 08:41:56 +0100
Message-Id: <20200221072437.967704372@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit f566e1fbadb686e28f1c307e356114b2865ef588 ]

Currently, the single-target build does not work when two
or more sub-directories are given:

  $ make fs/ kernel/ lib/
    CALL    scripts/checksyscalls.sh
    CALL    scripts/atomic/check-atomics.sh
    DESCEND  objtool
  make[2]: Nothing to be done for 'kernel/'.
  make[2]: Nothing to be done for 'fs/'.
  make[2]: Nothing to be done for 'lib/'.

Make it work properly.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 1f7dc3a2e1dd1..142042ac62e21 100644
--- a/Makefile
+++ b/Makefile
@@ -1691,7 +1691,7 @@ PHONY += descend $(build-dirs)
 descend: $(build-dirs)
 $(build-dirs): prepare
 	$(Q)$(MAKE) $(build)=$@ \
-	single-build=$(if $(filter-out $@/, $(single-no-ko)),1) \
+	single-build=$(if $(filter-out $@/, $(filter $@/%, $(single-no-ko))),1) \
 	need-builtin=1 need-modorder=1
 
 clean-dirs := $(addprefix _clean_, $(clean-dirs))
-- 
2.20.1



