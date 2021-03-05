Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2B832E9A3
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhCEMd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:33:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232397AbhCEMdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:33:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7EFE65012;
        Fri,  5 Mar 2021 12:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947623;
        bh=grZjtHtZpJBxYVyZyTtT1ZRu+/zKKO77g4aT/2nIiIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENkzONjC0VfWYjhN4t7ZJAKi6NsCZAEkaYNmJtVryxDa5WpyyOKC+MSn3eJQCF7hS
         DdwZ+Px7lfnvM9pYAx4qIAvGnXciFrZx40FxyBaBp9y1jyMM9lzWbtw0jYkQDk6MEv
         ce+gyNk7Oqygaq56TKiqi6TMV+x8AHqPdgaLSvys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank van der Linden <fllinden@amazon.com>,
        Shaoying Xu <shaoyi@amazon.com>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 05/72] arm64 module: set plt* section addresses to 0x0
Date:   Fri,  5 Mar 2021 13:21:07 +0100
Message-Id: <20210305120857.616467227@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaoying Xu <shaoyi@amazon.com>

commit f5c6d0fcf90ce07ee0d686d465b19b247ebd5ed7 upstream.

These plt* and .text.ftrace_trampoline sections specified for arm64 have
non-zero addressses. Non-zero section addresses in a relocatable ELF would
confuse GDB when it tries to compute the section offsets and it ends up
printing wrong symbol addresses. Therefore, set them to zero, which mirrors
the change in commit 5d8591bc0fba ("module: set ksymtab/kcrctab* section
addresses to 0x0").

Reported-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210216183234.GA23876@amazon.com
Signed-off-by: Will Deacon <will@kernel.org>
[shaoyi@amazon.com: made same changes in arch/arm64/kernel/module.lds for 5.4]
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/module.lds |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/module.lds
+++ b/arch/arm64/kernel/module.lds
@@ -1,5 +1,5 @@
 SECTIONS {
-	.plt (NOLOAD) : { BYTE(0) }
-	.init.plt (NOLOAD) : { BYTE(0) }
-	.text.ftrace_trampoline (NOLOAD) : { BYTE(0) }
+	.plt 0 (NOLOAD) : { BYTE(0) }
+	.init.plt 0 (NOLOAD) : { BYTE(0) }
+	.text.ftrace_trampoline 0 (NOLOAD) : { BYTE(0) }
 }


