Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1901022F11B
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbgG0O3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731969AbgG0OWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 438FC20FC3;
        Mon, 27 Jul 2020 14:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859770;
        bh=xpn+nNpgUhBKarM+fQiQTBmJ1lrn02PNKrtmx3CVs5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQBFJOiWtX4mo/8bUZOTiA/WaFyvJdlaQL43DFHbYrasRxZlpYzGp8uDMdrA73rOV
         5KkuXGM34QV/C1wQ6HKMTiRrU8rEDBFIWNIyG05cJ4xEo3Y/hE/O99yqVw3zCPVaR0
         5fZ4KkTS0G9IKkO8J7b7LIDsuXtqEPP2/dWSeskI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 099/179] kbuild: fix single target builds for external modules
Date:   Mon, 27 Jul 2020 16:04:34 +0200
Message-Id: <20200727134937.476337129@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 20b1be59528295e5c2a8812059b8560753dd8e68 ]

Commit f566e1fbadb6 ("kbuild: make multiple directory targets work")
broke single target builds for external modules. Fix this.

Fixes: f566e1fbadb6 ("kbuild: make multiple directory targets work")
Reported-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e622e084e7e26..74056e09f0a30 100644
--- a/Makefile
+++ b/Makefile
@@ -1730,7 +1730,7 @@ PHONY += descend $(build-dirs)
 descend: $(build-dirs)
 $(build-dirs): prepare
 	$(Q)$(MAKE) $(build)=$@ \
-	single-build=$(if $(filter-out $@/, $(filter $@/%, $(single-no-ko))),1) \
+	single-build=$(if $(filter-out $@/, $(filter $@/%, $(KBUILD_SINGLE_TARGETS))),1) \
 	need-builtin=1 need-modorder=1
 
 clean-dirs := $(addprefix _clean_, $(clean-dirs))
-- 
2.25.1



