Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358F927884F
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgIYMyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbgIYMya (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F9B12072E;
        Fri, 25 Sep 2020 12:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038469;
        bh=BCRCOnBkP+kbp3E2j/Kn4U87LLVqgOdCdOC7/qrITYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvYUK+mMVH0/Hb8NGIpdHsSawPmeVew3UmFzmB69e2rAbOc+CzKgApRfx1mjGqYi3
         fmS6gcS4UPAfLQDZICiL8ekpPpWFwN55ZkpoZPUXokjLljYeY42FzoFNH8CvJ4LTDj
         RyS7dJvzi8a3iSNE8hufJKG7Z+ojVGH3q84uJLdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 29/37] net: wan: wanxl: use $(M68KCC) instead of $(M68KAS) for rebuilding firmware
Date:   Fri, 25 Sep 2020 14:48:57 +0200
Message-Id: <20200925124725.338946106@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 734f3719d3438f9cc181d674c33ca9762e9148a1 upstream.

The firmware source, wanxlfw.S, is currently compiled by the combo of
$(CPP) and $(M68KAS). This is not what we usually do for compiling *.S
files. In fact, this Makefile is the only user of $(AS) in the kernel
build.

Instead of combining $(CPP) and (AS) from different tool sets, using
$(M68KCC) as an assembler driver is simpler, and saner.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -41,16 +41,16 @@ $(obj)/wanxl.o:	$(obj)/wanxlfw.inc
 
 ifeq ($(CONFIG_WANXL_BUILD_FIRMWARE),y)
 ifeq ($(ARCH),m68k)
-  M68KAS = $(AS)
+  M68KCC = $(CC)
   M68KLD = $(LD)
 else
-  M68KAS = $(CROSS_COMPILE_M68K)as
+  M68KCC = $(CROSS_COMPILE_M68K)gcc
   M68KLD = $(CROSS_COMPILE_M68K)ld
 endif
 
 quiet_cmd_build_wanxlfw = BLD FW  $@
       cmd_build_wanxlfw = \
-	$(CPP) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi $< | $(M68KAS) -m68360 -o $(obj)/wanxlfw.o; \
+	$(M68KCC) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi -c -o $(obj)/wanxlfw.o $<; \
 	$(M68KLD) --oformat binary -Ttext 0x1000 $(obj)/wanxlfw.o -o $(obj)/wanxlfw.bin; \
 	hexdump -ve '"\n" 16/1 "0x%02X,"' $(obj)/wanxlfw.bin | sed 's/0x  ,//g;1s/^/static const u8 firmware[]={/;$$s/,$$/\n};\n/' >$(obj)/wanxlfw.inc; \
 	rm -f $(obj)/wanxlfw.bin $(obj)/wanxlfw.o


