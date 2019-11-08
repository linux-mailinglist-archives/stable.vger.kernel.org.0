Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F21F54EA
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388506AbfKHS44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732607AbfKHS44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:56:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 779102067B;
        Fri,  8 Nov 2019 18:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239415;
        bh=Yzrfcd5cKL6KuXv+Ofw10dPyZQkvoE/R25g2YhQEWUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4cpywrpEpgUWK0daunbjEbBXhmcNHAwhwyAyBl8PLYKLdda39+GWm87BkA9U+457
         omEZoA3yJBGrlGyPr/sA/WuzkNh6wsSE9TQC9b5QJKy65P+AKTnzHZ2iF6NIUtR0cT
         GeFUFGUlCwUw5ikXD6W5ubngsLF2PxTPd7zKZOvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 31/34] kbuild: add -fcf-protection=none when using retpoline flags
Date:   Fri,  8 Nov 2019 19:50:38 +0100
Message-Id: <20191108174653.027224327@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>

[ Upstream commit 29be86d7f9cb18df4123f309ac7857570513e8bc ]

The gcc -fcf-protection=branch option is not compatible with
-mindirect-branch=thunk-extern. The latter is used when
CONFIG_RETPOLINE is selected, and this will fail to build with
a gcc which has -fcf-protection=branch enabled by default. Adding
-fcf-protection=none when building with retpoline enabled
prevents such build failures.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Makefile b/Makefile
index 62ce3766032c9..1d50905aaf425 100644
--- a/Makefile
+++ b/Makefile
@@ -840,6 +840,12 @@ KBUILD_CFLAGS   += $(call cc-option,-Werror=designated-init)
 # change __FILE__ to the relative path from the srctree
 KBUILD_CFLAGS	+= $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 
+# ensure -fcf-protection is disabled when using retpoline as it is
+# incompatible with -mindirect-branch=thunk-extern
+ifdef CONFIG_RETPOLINE
+KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
+endif
+
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
-- 
2.20.1



