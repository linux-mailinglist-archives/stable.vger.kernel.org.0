Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CC52BFE79
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 03:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgKWC62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 21:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgKWC62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 21:58:28 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE73C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 18:58:26 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w16so534711pga.9
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 18:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kws2Ui1UJXk8SsYl5hFV2TeU+bmMFXhPsXoMlrffbmc=;
        b=Q3ZfnDvDb+d/wmSvSrXiWiOv5lsHIxAMTT+7fKMHTGuLMNhNk8EFfPFCPUQHxXs5l0
         qO8qwO1q8esyTLf1lJCJjjzDCcEa6CHw9BxXkCkKCbaUB7vAAjsTUmWaRw4g+x73jat+
         yNFLfbxX3ykyrhLVYRu6q5kxZ+OM6MtN6W1Ow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kws2Ui1UJXk8SsYl5hFV2TeU+bmMFXhPsXoMlrffbmc=;
        b=sunsY0XF4FTWecQKvdaDK3X17Fv6B4geu6bJ3+KrroYiMxjdX0dOLgx05enBGrjHqV
         AmyZALMVOEzLaWvQ6LjsODugm/XOsME2zG9Rr+rHA8guGnzEUiKB1z+UHCy2mt+RXsuK
         OGLBH15iDO5ia1+XrlTWD1wOPnjITLrLQ5/GOSLW2Q1MqkIXuXX406IM9aWPMOaQRbpA
         EbHy1VnEFteQh12Euk7LjdAas3ctO5Y6VONEcDN2ylQZ1aCi7ML3RNjWNOL2tXfbtgKw
         kBMQVO2A7mnNEX77Ny7ANVnMTpS9aSut0NUboCMJzPxaAsRmZCUIjqVB1DwIJ0mpagF7
         gEYA==
X-Gm-Message-State: AOAM532BVVjKD5FeiAKInJlItf5DmJytKjZLTEreczItj54IT5vzoVlO
        fygT+HfDRGnYVhx2mnvt9nPTAJv3m3svgg==
X-Google-Smtp-Source: ABdhPJyNkhXycSSN5eLTsf24hE+pK47PnDbHhhe9rwXDVyLfrLSf6yMIWe6K5RQPL1Dxc3AsUfOOuw==
X-Received: by 2002:a65:5907:: with SMTP id f7mr25596252pgu.445.1606100306160;
        Sun, 22 Nov 2020 18:58:26 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7c33-03c1-9b47-98b6.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7c33:3c1:9b47:98b6])
        by smtp.gmail.com with ESMTPSA id f6sm9075795pgi.70.2020.11.22.18.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 18:58:25 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH v4.4] powerpc/uaccess-flush: fix corenet64_smp_defconfig build
Date:   Mon, 23 Nov 2020 13:58:22 +1100
Message-Id: <20201123025822.458568-1-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gunter reports problems with the corenet64_smp_defconfig:

In file included from arch/powerpc/kernel/ppc_ksyms.c:10:0:
arch/powerpc/include/asm/book3s/64/kup-radix.h:11:29: error: redefinition of ‘allow_user_access’
 static __always_inline void allow_user_access(void __user *to, const void __user *from,
			     ^~~~~~~~~~~~~~~~~
In file included from arch/powerpc/include/asm/uaccess.h:12:0,
		 from arch/powerpc/kernel/ppc_ksyms.c:8:
arch/powerpc/include/asm/kup.h:12:20: note: previous definition of ‘allow_user_access’ was here
 static inline void allow_user_access(void __user *to, const void __user *from,
		    ^~~~~~~~~~~~~~~~~

This is because ppc_ksyms.c imports asm/book3s/64/kup-radix.h guarded by
CONFIG_PPC64, rather than CONFIG_PPC_BOOK3S_64 which it should do.

Fix it.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/kernel/ppc_ksyms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index 80eb47113d5d..0f05c85cbde3 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -6,7 +6,7 @@
 #include <asm/cacheflush.h>
 #include <asm/epapr_hcalls.h>
 #include <asm/uaccess.h>
-#ifdef CONFIG_PPC64
+#ifdef CONFIG_PPC_BOOK3S_64
 #include <asm/book3s/64/kup-radix.h>
 #endif
 
@@ -50,6 +50,6 @@ EXPORT_SYMBOL(current_stack_pointer);
 
 EXPORT_SYMBOL(__arch_clear_user);
 
-#ifdef CONFIG_PPC64
+#ifdef CONFIG_PPC_BOOK3S_64
 EXPORT_SYMBOL(do_uaccess_flush);
 #endif
-- 
2.25.1

