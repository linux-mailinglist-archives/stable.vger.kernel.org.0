Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBB343F23
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbfFMPzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:55:11 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:56157 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731560AbfFMIxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 04:53:11 -0400
Received: from nat-ies.mentorg.com ([192.94.31.2] helo=svr-ies-mbx-02.mgc.mentorg.com)
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hbLTo-00032A-D9 from Cedric_Hombourger@mentor.com ; Thu, 13 Jun 2019 01:53:08 -0700
Received: from FRG-W10-HOMBOUR.world.mentorg.com (137.202.0.90) by
 svr-ies-mbx-02.mgc.mentorg.com (139.181.222.2) with Microsoft SMTP Server
 (TLS) id 15.0.1320.4; Thu, 13 Jun 2019 09:53:04 +0100
From:   Cedric Hombourger <Cedric_Hombourger@mentor.com>
CC:     Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        <linux-mips@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] MIPS: have "plain" make calls build dtbs for selected platforms
Date:   Thu, 13 Jun 2019 10:52:50 +0200
Message-ID: <1560415970-844-1-git-send-email-Cedric_Hombourger@mentor.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: svr-ies-mbx-05.mgc.mentorg.com (139.181.222.5) To
 svr-ies-mbx-02.mgc.mentorg.com (139.181.222.2)
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

scripts/package/builddep calls "make dtbs_install" after executing
a plain make (i.e. no build targets specified). It will fail if dtbs
were not built beforehand. Match the arm64 architecture where DTBs get
built by the "all" target.

Signed-off-by: Cedric Hombourger <Cedric_Hombourger@mentor.com>
Cc: linux-mips@vger.kernel.org
Cc: stable@vger.kernel.org
---
 arch/mips/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 8f4486c4415b..eceff9b75b22 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -17,6 +17,7 @@ archscripts: scripts_basic
 	$(Q)$(MAKE) $(build)=arch/mips/boot/tools relocs
 
 KBUILD_DEFCONFIG := 32r2el_defconfig
+KBUILD_DTBS      := dtbs
 
 #
 # Select the object file format to substitute into the linker script.
@@ -384,7 +385,7 @@ quiet_cmd_64 = OBJCOPY $@
 vmlinux.64: vmlinux
 	$(call cmd,64)
 
-all:	$(all-y)
+all:	$(all-y) $(KBUILD_DTBS)
 
 # boot
 $(boot-y): $(vmlinux-32) FORCE
-- 
2.11.0

