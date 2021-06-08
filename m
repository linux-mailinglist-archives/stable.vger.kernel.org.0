Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDE33A03DE
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237304AbhFHTWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238638AbhFHTTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E624F61432;
        Tue,  8 Jun 2021 18:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178337;
        bh=oI1Gcw5iYbmyceXcrYOim1sfboeXONWKu14l+TQTLQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+9lCCKlroMhaFNeKXCFSAPCCR+UpCVCtIGxf/2CZcU92GEJohcFnF4urIXKH11g4
         BH6b3QVlfS3NPN+h/eaDfT1hSDzPcJiHFUjBbxwD0oMjJ2WWDGeDIVkiX5lMAKKFFo
         vJxw1wGmdcw+Y5NWPJ/3ExbQ9nALOOmDjTqGSxaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiashuo Liang <liangjs@pku.edu.cn>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.12 158/161] x86/fault: Dont send SIGSEGV twice on SEGV_PKUERR
Date:   Tue,  8 Jun 2021 20:28:08 +0200
Message-Id: <20210608175950.794678689@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiashuo Liang <liangjs@pku.edu.cn>

commit 5405b42c2f08efe67b531799ba2fdb35bac93e70 upstream.

__bad_area_nosemaphore() calls both force_sig_pkuerr() and
force_sig_fault() when handling SEGV_PKUERR. This does not cause
problems because the second signal is filtered by the legacy_queue()
check in __send_signal() because in both cases, the signal is SIGSEGV,
the second one seeing that the first one is already pending.

This causes the kernel to do unnecessary work so send the signal only
once for SEGV_PKUERR.

 [ bp: Massage commit message. ]

Fixes: 9db812dbb29d ("signal/x86: Call force_sig_pkuerr from __bad_area_nosemaphore")
Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiashuo Liang <liangjs@pku.edu.cn>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Link: https://lkml.kernel.org/r/20210601085203.40214-1-liangjs@pku.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/fault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -836,8 +836,8 @@ __bad_area_nosemaphore(struct pt_regs *r
 
 	if (si_code == SEGV_PKUERR)
 		force_sig_pkuerr((void __user *)address, pkey);
-
-	force_sig_fault(SIGSEGV, si_code, (void __user *)address);
+	else
+		force_sig_fault(SIGSEGV, si_code, (void __user *)address);
 
 	local_irq_disable();
 }


