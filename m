Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7BB15DDE2
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388456AbgBNQBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:01:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389118AbgBNQAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:00:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 301EE24676;
        Fri, 14 Feb 2020 16:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696020;
        bh=YauOEueJuBf1r8J2JsYeH3qisH8WDR7gx8JHrcRp+/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIwKMPsX8xsEKWnxfE8Cp+qzMvhW3apfoFvdPSJ/RNxyLNJM4+N91uDpiYXM7O+Fg
         cyJr1Noi9iWKd6ZPKH6LjOhO5vDih6kheDm7HSoe93NoalVpch+QIRr5l1AkupavZl
         eBGiH4blElA61lXjz79If9KzGRUFerkXr5WvCNWY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 536/542] kbuild: make multiple directory targets work
Date:   Fri, 14 Feb 2020 10:48:48 -0500
Message-Id: <20200214154854.6746-536-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index fdaa1e262320d..b65e891c4deae 100644
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

