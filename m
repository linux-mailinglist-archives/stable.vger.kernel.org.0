Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB6718B6D7
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgCSNXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730125AbgCSNXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:23:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70811206D7;
        Thu, 19 Mar 2020 13:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624181;
        bh=+X0ujDjCuGYkvq48UVYFgVt4Eue6hH+34n23JUj3498=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbkDbhPIOcim++rx9vBL9c34phdE+baiQUuxnFlfjFVGUNWPNF4QCDAfrR5sQ7Isc
         nG3ool/SwN4nV+4JsyIjPBnQwYMJg/hRIHkqu9mXtnBUWMTONRWUDj21rY+zC5pzq+
         Wb97FofcF9uxLpKI4FX8D6nEJP3osHwrpt5ssk3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/60] kbuild: add dt_binding_check to PHONY in a correct place
Date:   Thu, 19 Mar 2020 14:04:13 +0100
Message-Id: <20200319123930.886063941@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b308b84c069c8..cae04a373f862 100644
--- a/Makefile
+++ b/Makefile
@@ -1237,7 +1237,7 @@ ifneq ($(dtstree),)
 %.dtb: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree) $(dtstree)/$@
 
-PHONY += dtbs dtbs_install dtbs_check dt_binding_check
+PHONY += dtbs dtbs_install dtbs_check
 dtbs dtbs_check: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree)
 
@@ -1257,6 +1257,7 @@ PHONY += scripts_dtc
 scripts_dtc: scripts_basic
 	$(Q)$(MAKE) $(build)=scripts/dtc
 
+PHONY += dt_binding_check
 dt_binding_check: scripts_dtc
 	$(Q)$(MAKE) $(build)=Documentation/devicetree/bindings
 
-- 
2.20.1



