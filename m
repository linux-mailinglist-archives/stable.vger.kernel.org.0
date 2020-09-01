Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EE72593FC
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgIAPdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731205AbgIAPdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:33:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD10621534;
        Tue,  1 Sep 2020 15:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974431;
        bh=0pLi0SLVd6e4BBOw66dxZETJ9nGIBorqtqaZQsTosqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSkNeT/3cdaAXrZjTA5kQyOKE9ehYJiCTxePvk2+xr3zsO55U8lVp6eYqKYR9r1ah
         x0qP61jE98e8R4yuEUCZTQa4q3cESAWKZoVIqSOuOLp1OV5oJKUBDedwWz3Bz43hD4
         EYFdSClzuAF6/6msxl+SZmeuhPxcNRDXHrPO2odw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank van der Linden <fllinden@amazon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.4 174/214] arm64: vdso32: make vdso32 install conditional
Date:   Tue,  1 Sep 2020 17:10:54 +0200
Message-Id: <20200901151001.316341279@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
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
@@ -146,7 +146,8 @@ zinstall install:
 PHONY += vdso_install
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso $@
-	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso32 $@
+	$(if $(CONFIG_COMPAT_VDSO), \
+		$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso32 $@)
 
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:


