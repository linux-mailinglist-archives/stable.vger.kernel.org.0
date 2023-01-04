Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD4F65D99E
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbjADQ0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239754AbjADQ0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:26:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED4D11C19
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A04526177C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC5EC433D2;
        Wed,  4 Jan 2023 16:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849577;
        bh=d7qVbnylPvjOz6+l/uEdWMly/xKV8UcjOQvaxZQ9Zzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6uAqH7iNs7LGNApXu1cqKgePmRgFqZcBltAXaod1WtHw6FuiotMU2M8BuyFZwpsd
         sQ8RQZQHPBXXbTtmW+Qpof6nbCA3uVaYxEc2rJ3foRfG4j5243OiNF4j7TnKIHeFIz
         8EblMCOoEH0dXxTn5PviX+SoMuuMuZ8Bs+0M5rBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>
Subject: [PATCH 6.0 122/177] parisc: Add missing FORCE prerequisites in Makefile
Date:   Wed,  4 Jan 2023 17:06:53 +0100
Message-Id: <20230104160511.338764971@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 9086e6017957c5cd6ea28d94b70e0d513d6b7800 upstream.

Fix those make warnings:
    arch/parisc/kernel/vdso32/Makefile:30: FORCE prerequisite is missing
    arch/parisc/kernel/vdso64/Makefile:30: FORCE prerequisite is missing

Add the missing FORCE prerequisites for all build targets identified by
"make help".

Fixes: e1f86d7b4b2a5213 ("kbuild: warn if FORCE is missing for if_changed(_dep,_rule) and filechk")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # 5.18+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/vdso32/Makefile |    4 ++--
 arch/parisc/kernel/vdso64/Makefile |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/parisc/kernel/vdso32/Makefile
+++ b/arch/parisc/kernel/vdso32/Makefile
@@ -26,7 +26,7 @@ $(obj)/vdso32_wrapper.o : $(obj)/vdso32.
 
 # Force dependency (incbin is bad)
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso32.so: $(src)/vdso32.lds $(obj-vdso32) $(obj-cvdso32) $(VDSO_LIBGCC)
+$(obj)/vdso32.so: $(src)/vdso32.lds $(obj-vdso32) $(obj-cvdso32) $(VDSO_LIBGCC) FORCE
 	$(call if_changed,vdso32ld)
 
 # assembly rules for the .S files
@@ -38,7 +38,7 @@ $(obj-cvdso32): %.o: %.c FORCE
 
 # actual build commands
 quiet_cmd_vdso32ld = VDSO32L $@
-      cmd_vdso32ld = $(CROSS32CC) $(c_flags) -Wl,-T $^ -o $@
+      cmd_vdso32ld = $(CROSS32CC) $(c_flags) -Wl,-T $(filter-out FORCE, $^) -o $@
 quiet_cmd_vdso32as = VDSO32A $@
       cmd_vdso32as = $(CROSS32CC) $(a_flags) -c -o $@ $<
 quiet_cmd_vdso32cc = VDSO32C $@
--- a/arch/parisc/kernel/vdso64/Makefile
+++ b/arch/parisc/kernel/vdso64/Makefile
@@ -26,7 +26,7 @@ $(obj)/vdso64_wrapper.o : $(obj)/vdso64.
 
 # Force dependency (incbin is bad)
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso64.so: $(src)/vdso64.lds $(obj-vdso64) $(VDSO_LIBGCC)
+$(obj)/vdso64.so: $(src)/vdso64.lds $(obj-vdso64) $(VDSO_LIBGCC) FORCE
 	$(call if_changed,vdso64ld)
 
 # assembly rules for the .S files
@@ -35,7 +35,7 @@ $(obj-vdso64): %.o: %.S FORCE
 
 # actual build commands
 quiet_cmd_vdso64ld = VDSO64L $@
-      cmd_vdso64ld = $(CC) $(c_flags) -Wl,-T $^ -o $@
+      cmd_vdso64ld = $(CC) $(c_flags) -Wl,-T $(filter-out FORCE, $^) -o $@
 quiet_cmd_vdso64as = VDSO64A $@
       cmd_vdso64as = $(CC) $(a_flags) -c -o $@ $<
 


