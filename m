Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BF117AB6A
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgCEROM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:14:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgCEROK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77B452146E;
        Thu,  5 Mar 2020 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428450;
        bh=YIF9xn17dm9T04tLd25uhOOCgMPiyMHx+KPiYfEmEy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7J3LwyPI4Cr1Lhbv+z+xGrv0Mq/uTDDGvOQ4myRtXOOb4GmMMdj2U86GLs7Ltp+M
         xSSf9QGqKMso0Uk0q6SaMOR7ncCGOBDxz0qETFs03IEwuoLx6WFFCohQlMlkPQpotC
         +fJeS+VOmRCLB0o6CX6yG7TclkWSjlRi+6xhha3c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 45/67] kbuild: add dt_binding_check to PHONY in a correct place
Date:   Thu,  5 Mar 2020 12:12:46 -0500
Message-Id: <20200305171309.29118-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit c473a8d03ea8e03ca9d649b0b6d72fbcf6212c05 ]

The dt_binding_check is added to PHONY, but it is invisible when
$(dtstree) is empty. So, it is not specified as phony for
ARCH=x86 etc.

Add it to PHONY outside the ifneq ... endif block.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index f86ebe1dd2bd0..4dc2dd35e9e3e 100644
--- a/Makefile
+++ b/Makefile
@@ -1239,7 +1239,7 @@ ifneq ($(dtstree),)
 %.dtb: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree) $(dtstree)/$@
 
-PHONY += dtbs dtbs_install dtbs_check dt_binding_check
+PHONY += dtbs dtbs_install dtbs_check
 dtbs dtbs_check: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree)
 
@@ -1259,6 +1259,7 @@ PHONY += scripts_dtc
 scripts_dtc: scripts_basic
 	$(Q)$(MAKE) $(build)=scripts/dtc
 
+PHONY += dt_binding_check
 dt_binding_check: scripts_dtc
 	$(Q)$(MAKE) $(build)=Documentation/devicetree/bindings
 
-- 
2.20.1

