Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0311EE00
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730332AbfEOLPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbfEOLPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:15:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 134BC20843;
        Wed, 15 May 2019 11:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918938;
        bh=3dMdubc3fnkI4z6VbCojTb2u4IhQBd4DzL3jTUJC2IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iewD5jWvhtkes9jf1agOz5uVCNRZrYHC1hX5u7lOWD+3KpnahFIQXHg78bmN7DjiU
         lLhETj0W1Gm9K7iovNcY6dsjSuuHCQ/RD/f2uI6kxoIIknQmMsOVdTmRbqLhnTrWFj
         QRt7TUhKosOoRtDMfJXyOwBiC9VxuYgLKo3qzjNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 34/51] Revert "x86/vdso: Drop implicit common-page-size linker flag"
Date:   Wed, 15 May 2019 12:56:09 +0200
Message-Id: <20190515090626.730665433@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
References: <20190515090616.669619870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 408d67a0fecf4cfe7869f518211ae278ee44376e.

The commit message in the 4.9 stable tree did not have a reference to
the upstream commit id.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vdso/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 0d3ebdfa07396..cec8cb28eabae 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -48,7 +48,7 @@ targets += $(vdso_img_sodbg)
 export CPPFLAGS_vdso.lds += -P -C
 
 VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -soname linux-vdso.so.1 --no-undefined \
-			-z max-page-size=4096
+			-z max-page-size=4096 -z common-page-size=4096
 
 $(obj)/vdso64.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,vdso)
@@ -95,7 +95,7 @@ CFLAGS_REMOVE_vvar.o = -pg
 
 CPPFLAGS_vdsox32.lds = $(CPPFLAGS_vdso.lds)
 VDSO_LDFLAGS_vdsox32.lds = -m elf32_x86_64 -soname linux-vdso.so.1 \
-			   -z max-page-size=4096
+			   -z max-page-size=4096 -z common-page-size=4096
 
 # 64-bit objects to re-brand as x32
 vobjs64-for-x32 := $(filter-out $(vobjs-nox32),$(vobjs-y))
-- 
2.20.1



