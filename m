Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9331CB02A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgEHMhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728035AbgEHMhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E388121BE5;
        Fri,  8 May 2020 12:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941432;
        bh=RzxaLZeOI3TjEXWS1O0h8b31by9pETsE3J1aMyXPpK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yGF0+U16RYUYYZn5xavlFoMPBwYnM8o+uCXM4vYwhZfzUMywnfHE7oW9y7n7wYTd5
         elhKGVMmVSh8G1hN6DjTT2AgNzUJFIoYyvTvDbmty2ayRYu42+1pYMOYBS71YZAiCH
         nOrIr7M/FuRwx8srVlCK2HUAFBvKREpEcx2gKFi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 030/312] bpf, mips: fix off-by-one in ctx offset allocation
Date:   Fri,  8 May 2020 14:30:21 +0200
Message-Id: <20200508123126.611771025@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit b4e76f7e6d3200462c6354a6ad4ae167459e61f8 upstream.

Dan Carpenter reported [1] a static checker warning that ctx->offsets[]
may be accessed off by one from build_body(), since it's allocated with
fp->len * sizeof(*ctx.offsets) as length. The cBPF arm and ppc code
doesn't have this issue as claimed, so only mips seems to be affected and
should like most other JITs allocate with fp->len + 1. A few number of
JITs (x86, sparc, arm64) handle this differently, where they only require
fp->len array elements.

  [1] http://www.spinics.net/lists/mips/msg64193.html

Fixes: c6610de353da ("MIPS: net: Add BPF JIT")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: ast@kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/13814/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/net/bpf_jit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -1207,7 +1207,7 @@ void bpf_jit_compile(struct bpf_prog *fp
 
 	memset(&ctx, 0, sizeof(ctx));
 
-	ctx.offsets = kcalloc(fp->len, sizeof(*ctx.offsets), GFP_KERNEL);
+	ctx.offsets = kcalloc(fp->len + 1, sizeof(*ctx.offsets), GFP_KERNEL);
 	if (ctx.offsets == NULL)
 		return;
 


