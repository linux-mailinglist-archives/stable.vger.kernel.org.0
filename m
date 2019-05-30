Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCEA2EB48
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfE3DLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728509AbfE3DLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:23 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB1A224476;
        Thu, 30 May 2019 03:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185883;
        bh=vACxFoaRYP5jpW6GY39AcU0tnRCiSOhoxjkhWlv5gfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcaJoFfRNrjLPXjhN3/v3zC4T5H3i9JilGNrdDydF4+QnyIDDx0Ddp2ir0lPVQ27A
         7EvPd7zDaUqQzA4oDl6XpdZIyx9H0c+jbPmUDOZixBttLIXezNZCodhfT5Xm8aTmmb
         cFAt1I/KppdxvP6dBEu9oHv9iGGn2lCPECXCZtOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 234/405] samples/bpf: fix build with new clang
Date:   Wed, 29 May 2019 20:03:52 -0700
Message-Id: <20190530030552.857506831@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 636e78b1cdb40b77a79b143dbd9d94847b360efa ]

clang started to error on invalid asm clobber usage in x86 headers
and many bpf program samples failed to build with the message:

  CLANG-bpf  /data/users/ast/bpf-next/samples/bpf/xdp_redirect_kern.o
In file included from /data/users/ast/bpf-next/samples/bpf/xdp_redirect_kern.c:14:
In file included from ../include/linux/in.h:23:
In file included from ../include/uapi/linux/in.h:24:
In file included from ../include/linux/socket.h:8:
In file included from ../include/linux/uio.h:14:
In file included from ../include/crypto/hash.h:16:
In file included from ../include/linux/crypto.h:26:
In file included from ../include/linux/uaccess.h:5:
In file included from ../include/linux/sched.h:15:
In file included from ../include/linux/sem.h:5:
In file included from ../include/uapi/linux/sem.h:5:
In file included from ../include/linux/ipc.h:9:
In file included from ../include/linux/refcount.h:72:
../arch/x86/include/asm/refcount.h:72:36: error: asm-specifier for input or output variable conflicts with asm clobber list
                                         r->refs.counter, e, "er", i, "cx");
                                                                      ^
../arch/x86/include/asm/refcount.h:86:27: error: asm-specifier for input or output variable conflicts with asm clobber list
                                         r->refs.counter, e, "cx");
                                                             ^
2 errors generated.

Override volatile() to workaround the problem.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/asm_goto_workaround.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/asm_goto_workaround.h b/samples/bpf/asm_goto_workaround.h
index 5cd7c1d1a5d56..7409722727ca1 100644
--- a/samples/bpf/asm_goto_workaround.h
+++ b/samples/bpf/asm_goto_workaround.h
@@ -13,4 +13,5 @@
 #define asm_volatile_goto(x...) asm volatile("invalid use of asm_volatile_goto")
 #endif
 
+#define volatile(x...) volatile("")
 #endif
-- 
2.20.1



