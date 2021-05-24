Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A892738EEEC
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbhEXPzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235215AbhEXPzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2293661439;
        Mon, 24 May 2021 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870840;
        bh=Hkib7HmFjpGuga3aSoohJ7gDsBbzsy2qgzCm9wjyFXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPskC09HPch+Wx0pMNASQTiw/rbBgbAedXUYG4gMvlThzpIvhBsEpOD4xWsAXjNDF
         /jM4knnJEyiokCiYPYV618D5+PEXAfFPblzB4eYbjmz6clVy8h4tE8mg2olHP8aYW0
         IO7jt/YCHnRiwBHtHwTK7pND3jwCu8fIsaHSCXPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 059/104] x86/sev-es: Forward page-faults which happen during emulation
Date:   Mon, 24 May 2021 17:25:54 +0200
Message-Id: <20210524152334.813884395@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit c25bbdb564060adaad5c3a8a10765c13487ba6a3 upstream.

When emulating guest instructions for MMIO or IOIO accesses, the #VC
handler might get a page-fault and will not be able to complete. Forward
the page-fault in this case to the correct handler instead of killing
the machine.

Fixes: 0786138c78e7 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v5.10+
Link: https://lkml.kernel.org/r/20210519135251.30093-3-joro@8bytes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev-es.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -1269,6 +1269,10 @@ static __always_inline void vc_forward_e
 	case X86_TRAP_UD:
 		exc_invalid_op(ctxt->regs);
 		break;
+	case X86_TRAP_PF:
+		write_cr2(ctxt->fi.cr2);
+		exc_page_fault(ctxt->regs, error_code);
+		break;
 	case X86_TRAP_AC:
 		exc_alignment_check(ctxt->regs, error_code);
 		break;


