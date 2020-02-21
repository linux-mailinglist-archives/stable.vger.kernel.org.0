Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9441675ED
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732959AbgBUINK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732956AbgBUINK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:13:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2926620722;
        Fri, 21 Feb 2020 08:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272789;
        bh=ELlkIfK1/ej71TQAufGUncCZGSmrKBDD0FiRlst3Jtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eA7jzuuIUjxpvG6aMoNgTv2uNQUlqry+mpxa61+mhblzHEbR8dmC9oD3SynG4E7C+
         d0yJFHFDey7jq7leHBXLn74MgABbnxQBVuTLhmBvw6GWvspeonIu5B0SgOHQA2Gdss
         5W7b8RtvE7Ghi4HjpNPzAXg5HAFM8o9NNXRbSYmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 276/344] s390: adjust -mpacked-stack support check for clang 10
Date:   Fri, 21 Feb 2020 08:41:15 +0100
Message-Id: <20200221072414.810177821@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 253b3c4b2920e07ce9e2b18800b9b65245e2fafa ]

clang 10 introduces -mpacked-stack compiler option implementation. At the
same time currently it does not support a combination of -mpacked-stack
and -mbackchain. This leads to the following build error:

clang: error: unsupported option '-mpacked-stack with -mbackchain' for
target 's390x-ibm-linux'

If/when clang adds support for a combination of -mpacked-stack and
-mbackchain it would also require -msoft-float (like gcc does). According
to Ulrich Weigand "stack slot assigned to the kernel backchain overlaps
the stack slot assigned to the FPR varargs (both are required to be
placed immediately after the saved r15 slot if present)."

Extend -mpacked-stack compiler option support check to include all 3
options -mpacked-stack -mbackchain -msoft-float which must present to
support -mpacked-stack with -mbackchain.

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 478b645b20ddb..9ce1baeac2b25 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -69,7 +69,7 @@ cflags-y += -Wa,-I$(srctree)/arch/$(ARCH)/include
 #
 cflags-$(CONFIG_FRAME_POINTER) += -fno-optimize-sibling-calls
 
-ifeq ($(call cc-option-yn,-mpacked-stack),y)
+ifeq ($(call cc-option-yn,-mpacked-stack -mbackchain -msoft-float),y)
 cflags-$(CONFIG_PACK_STACK)  += -mpacked-stack -D__PACK_STACK
 aflags-$(CONFIG_PACK_STACK)  += -D__PACK_STACK
 endif
-- 
2.20.1



