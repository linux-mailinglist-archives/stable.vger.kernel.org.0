Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE462522
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbfGHPRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732759AbfGHPRR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:17:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E287621707;
        Mon,  8 Jul 2019 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599036;
        bh=vW42ojFpOhiTN10NCddLKcIMeP7xmsRkoUUclVbHmxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kU0gCPrFEbdrsh5FXuRpFB2ogXt7pGZH8ueF4HJYFKQpZXuY6oeHbLT4XCLLGqEag
         RRdl7VMhhGhExuzvdy6S4cYf9dmsLeZBMwU81Tcb6liPrRvc4rQQeSuAt3b0uQCifT
         RYSxH3q/fVEJtuDaOv6ejLSZm1ywG94RJNSFx0tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 56/73] ARC: fix build warning in elf.h
Date:   Mon,  8 Jul 2019 17:13:06 +0200
Message-Id: <20190708150524.308561908@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1dec78585328db00e33fb18dc1a6deed0e2095a5 ]

The cast valid since TASK_SIZE * 2 will never actually cause overflow.

|   CC      fs/binfmt_elf.o
| In file included from ../include/linux/elf.h:4:0,
|                  from ../include/linux/module.h:15,
|                  from ../fs/binfmt_elf.c:12:
| ../fs/binfmt_elf.c: In function load_elf_binar:
| ../arch/arc/include/asm/elf.h:57:29: warning: integer overflow in expression [-Woverflow]
|  #define ELF_ET_DYN_BASE  (2 * TASK_SIZE / 3)
|                              ^
| ../fs/binfmt_elf.c:921:16: note: in expansion of macro ELF_ET_DYN_BASE
|     load_bias = ELF_ET_DYN_BASE - vaddr;

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/elf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/include/asm/elf.h b/arch/arc/include/asm/elf.h
index 51a99e25fe33..8ee9113b2f8b 100644
--- a/arch/arc/include/asm/elf.h
+++ b/arch/arc/include/asm/elf.h
@@ -55,7 +55,7 @@ extern int elf_check_arch(const struct elf32_hdr *);
  * the loader.  We need to make sure that it is out of the way of the program
  * that it will "exec", and that there is sufficient room for the brk.
  */
-#define ELF_ET_DYN_BASE		(2 * TASK_SIZE / 3)
+#define ELF_ET_DYN_BASE		(2UL * TASK_SIZE / 3)
 
 /*
  * When the program starts, a1 contains a pointer to a function to be
-- 
2.20.1



