Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A472594ED
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbgIAPod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731805AbgIAPoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D780206FA;
        Tue,  1 Sep 2020 15:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975071;
        bh=nHTwjStT8znvj4Mj2MbqqEye3H3B5h5Io7qJPUEPPH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CD3CsDQCflGjmbFS3YojTekJVoncpi33dXGbe8jv8LGcdSYa7b7/GURyfXVMfaaAz
         NvxMJafS5uCJ4TeMYPpYA1y66bVFj8Dkt0l0F6ot61mul37CTYBKCNyih5oqUkRqCL
         d62EMuB2QV/b1EvEZ8cr4q5E8ioUQn8uIyr513DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank van der Linden <fllinden@amazon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.8 199/255] arm64: vdso32: make vdso32 install conditional
Date:   Tue,  1 Sep 2020 17:10:55 +0200
Message-Id: <20200901151010.228049849@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank van der Linden <fllinden@amazon.com>

commit 5d28ba5f8a0cfa3a874fa96c33731b8fcd141b3a upstream.

vdso32 should only be installed if CONFIG_COMPAT_VDSO is enabled,
since it's not even supposed to be compiled otherwise, and arm64
builds without a 32bit crosscompiler will fail.

Fixes: 8d75785a8142 ("ARM64: vdso32: Install vdso32 from vdso_install")
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Cc: stable@vger.kernel.org [5.4+]
Link: https://lore.kernel.org/r/20200827234012.19757-1-fllinden@amazon.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -158,7 +158,8 @@ zinstall install:
 PHONY += vdso_install
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso $@
-	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso32 $@
+	$(if $(CONFIG_COMPAT_VDSO), \
+		$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso32 $@)
 
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:


