Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D964E138015
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbgAKKZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:25:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbgAKKZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:25:38 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3ACA205F4;
        Sat, 11 Jan 2020 10:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738337;
        bh=AGTuTrcikLUKSv9a/hD7qcTELIbrLlmCYe2MpA5SRmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gASRc011/rFirwU5DNOSTMuCPpBKRWUep20pVvWTKblC/NSncLhTUz3/DGXh0XWUu
         PdDbyimE3m16NaBFSuIFI2tzFrzKKJmXs6cvS2fMz6lCtyTmXu3v5mqA/tdw8gexEp
         q017qddLqNehwZXTMJlxwQdtxSvJBM1rq5r6I0i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Srikar Dronamraju <srikar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 5.4 076/165] powerpc/spinlocks: Include correct header for static key
Date:   Sat, 11 Jan 2020 10:49:55 +0100
Message-Id: <20200111094927.541261230@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 6da3eced8c5f3b03340b0c395bacd552c4d52411 upstream.

Recently, the spinlock implementation grew a static key optimization,
but the jump_label.h header include was left out, leading to build
errors:

  linux/arch/powerpc/include/asm/spinlock.h:44:7: error: implicit declaration of function ‘static_branch_unlikely’
   44 |  if (!static_branch_unlikely(&shared_processor))

This commit adds the missing header.

mpe: The build break is only seen with CONFIG_JUMP_LABEL=n.

Fixes: 656c21d6af5d ("powerpc/shared: Use static key to detect shared processor")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191223133147.129983-1-Jason@zx2c4.com
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/spinlock.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -15,6 +15,7 @@
  *
  * (the type definitions are in asm/spinlock_types.h)
  */
+#include <linux/jump_label.h>
 #include <linux/irqflags.h>
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>


