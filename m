Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9910918B673
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbgCSN1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729983AbgCSN1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:27:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A7820658;
        Thu, 19 Mar 2020 13:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624423;
        bh=gAdyxCZ+yxxTQGLWhGNzle5A/ZiLR73gT3huUdst+pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNA9pL/Bel/s/Iw3sy7d+B32FN+XcyzJtGrHUBd8646MYhcSflKwlW5wcKuadgxuz
         5z7fs5Ork6Ctu0eUH9cDktRJJ/V8zx3toPM1EsSq0huOfaACsp70A8Pivjz7cAMgCN
         oFIgQOQkE3pEd48D131C1X/OQY/yKCDeAIeE4yFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 37/65] kbuild: add dtbs_check to PHONY
Date:   Thu, 19 Mar 2020 14:04:19 +0100
Message-Id: <20200319123938.172053501@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 964a596db8db8c77c9903dd05655696696e6b3ad ]

The dtbs_check should be a phony target, but currently it is not
specified so.

'make dtbs_check' works even if a file named 'dtbs_check' exists
because it depends on another phony target, scripts_dtc, but we
should not rely on it.

Add dtbs_check to PHONY.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 5d0fdaf900e9d..362f1e2ca63ff 100644
--- a/Makefile
+++ b/Makefile
@@ -1239,7 +1239,7 @@ ifneq ($(dtstree),)
 %.dtb: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree) $(dtstree)/$@
 
-PHONY += dtbs dtbs_install dt_binding_check
+PHONY += dtbs dtbs_install dtbs_check dt_binding_check
 dtbs dtbs_check: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree)
 
-- 
2.20.1



