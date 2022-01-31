Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695164A4224
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359055AbiAaLK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:10:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41462 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245096AbiAaLHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:07:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AA9B6102A;
        Mon, 31 Jan 2022 11:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014C7C340E8;
        Mon, 31 Jan 2022 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627220;
        bh=ZcdLGpwrRzM4z270cG3mVxCpval/I4K+QpVb6FH+tZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVW3//QlpyPkh9Ze0zzydhmJKWkzY4dg1hUuTDV3QXLyBh33g4/GcPa7HNKuvLOH/
         O5BIyg/9SjyMHwgYVSKb2yQD105TAzN6nF63HxQZXZMGq3uGcdlgBMxIoLSfW5hV30
         nH+Y5vRSDBXM36t98QXj99VLgpvDbTtjpi9KwarY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 013/171] powerpc32/bpf: Fix codegen for bpf-to-bpf calls
Date:   Mon, 31 Jan 2022 11:54:38 +0100
Message-Id: <20220131105230.458734217@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit fab07611fb2e6a15fac05c4583045ca5582fd826 upstream.

Pad instructions emitted for BPF_CALL so that the number of instructions
generated does not change for different function addresses. This is
especially important for calls to other bpf functions, whose address
will only be known during extra pass.

Fixes: 51c66ad849a703 ("powerpc/bpf: Implement extended BPF on PPC32")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/52d8fe51f7620a6f27f377791564d79d75463576.1641468127.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit_comp32.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -191,6 +191,9 @@ void bpf_jit_emit_func_call_rel(u32 *ima
 
 	if (image && rel < 0x2000000 && rel >= -0x2000000) {
 		PPC_BL_ABS(func);
+		EMIT(PPC_RAW_NOP());
+		EMIT(PPC_RAW_NOP());
+		EMIT(PPC_RAW_NOP());
 	} else {
 		/* Load function address into r0 */
 		EMIT(PPC_RAW_LIS(_R0, IMM_H(func)));


