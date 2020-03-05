Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8FF17AC3E
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgCERPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:15:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbgCERPK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:15:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4DAB2146E;
        Thu,  5 Mar 2020 17:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428509;
        bh=Iry3y92U2E1yvLLBpQF94F9MQ3RtUtsLdwKvD3gdcJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oelVnF3UPq+afz/ma40hWFwukGPKhGLGY+yp7cXzNN+Nv2u2UjzDtRpH7eR3S+WGI
         YtVr/G8E0/YhPBe58+J1oHtUj3L2BFrZqQMsrFaYawQoy5d1BpJl3Kp6SZs/azVbKm
         VFvLYpOTtmg4xL17FwYbeRdDRz1nfxhSQ5W+DNGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 39/58] kbuild: add dt_binding_check to PHONY in a correct place
Date:   Thu,  5 Mar 2020 12:14:00 -0500
Message-Id: <20200305171420.29595-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
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
index 63094ce5e5744..993f87d5a0ba5 100644
--- a/Makefile
+++ b/Makefile
@@ -1242,7 +1242,7 @@ ifneq ($(dtstree),)
 %.dtb: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree) $(dtstree)/$@
 
-PHONY += dtbs dtbs_install dtbs_check dt_binding_check
+PHONY += dtbs dtbs_install dtbs_check
 dtbs dtbs_check: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree)
 
@@ -1262,6 +1262,7 @@ PHONY += scripts_dtc
 scripts_dtc: scripts_basic
 	$(Q)$(MAKE) $(build)=scripts/dtc
 
+PHONY += dt_binding_check
 dt_binding_check: scripts_dtc
 	$(Q)$(MAKE) $(build)=Documentation/devicetree/bindings
 
-- 
2.20.1

