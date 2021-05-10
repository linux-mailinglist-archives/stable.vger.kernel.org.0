Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982D43786BF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbhEJLK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232321AbhEJLDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:03:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E772361926;
        Mon, 10 May 2021 10:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644075;
        bh=3JC4aHN1cOtrTokfsLFr+sf9fBKzUi9zB+P0fCatCdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGlbl0/0AatJXxSBdY5F98w0m6PK+IQtmG6ki8ys6QBpSZoXCUKGMEjn9L8F/6mrh
         lfcqDB+kMWZObEsxdFoTfxZSj9iRrAeIOeS579F4JO2W2KrO+X6Cbl2ARhuf3xJi/7
         14q3imljXzT1pptt43uvlO8eQTHf12Gc17gg+Qek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Neuschaefer <j.neuschaefer@gmx.net>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.11 276/342] powerpc/32: Fix boot failure with CONFIG_STACKPROTECTOR
Date:   Mon, 10 May 2021 12:21:06 +0200
Message-Id: <20210510102019.223042951@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit f5668260b872e89b8d3942a8b7d4278aa9c2c981 upstream.

Commit 7c95d8893fb5 ("powerpc: Change calling convention for
create_branch() et. al.") complexified the frame of function
do_feature_fixups(), leading to GCC setting up a stack
guard when CONFIG_STACKPROTECTOR is selected.

The problem is that do_feature_fixups() is called very early
while 'current' in r2 is not set up yet and the code is still
not at the final address used at link time.

So, like other instrumentation, stack protection needs to be
deactivated for feature-fixups.c and code-patching.c

Fixes: 7c95d8893fb5 ("powerpc: Change calling convention for create_branch() et. al.")
Cc: stable@vger.kernel.org # v5.8+
Reported-by: Jonathan Neuschaefer <j.neuschaefer@gmx.net>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Jonathan Neuschaefer <j.neuschaefer@gmx.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b688fe82927b330349d9e44553363fa451ea4d95.1619715114.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -5,6 +5,9 @@
 
 ccflags-$(CONFIG_PPC64)	:= $(NO_MINIMAL_TOC)
 
+CFLAGS_code-patching.o += -fno-stack-protector
+CFLAGS_feature-fixups.o += -fno-stack-protector
+
 CFLAGS_REMOVE_code-patching.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_feature-fixups.o = $(CC_FLAGS_FTRACE)
 


