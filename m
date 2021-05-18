Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D738B38714B
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 07:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241113AbhERFfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 01:35:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57596 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbhERFfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 01:35:15 -0400
Date:   Tue, 18 May 2021 05:33:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621316036;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CaT83psmBX7duTpjZnoXom1QydzJmMUJFru8/TR+1pI=;
        b=3ScSKqrNT2WvdbVgTOEVX7aL+Qp2Eo+A3OT2GesZQGJtxu/ZF124MiusVlGujzp8jNtuML
        PHtqNTGD7b168x2wuvi+0xR+hhi3fccDRTcul6CpASDDjR0h1pIXFbmtvjreeoBY92J032
        2ULBGfPBEOF2bhVoothpBxjBL5AdGg82HuXcAlFZOXXpWa0MljaMbJvyxgArivBAY6mE+o
        MXfxdSrARdZIHs5k9JSxOT+kpG+DFnrMy6c9Vm+hLB9YVdXDcvsFf5GjFg9VYMMe40P2Vy
        3vaxyHukLT/E3V0EJVMrY80UaBPlGPtb80d7px2YUFiwXVCOZWMRqQOjM8M3lA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621316036;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CaT83psmBX7duTpjZnoXom1QydzJmMUJFru8/TR+1pI=;
        b=nBOGRluFnDRyo2+AftZUm1XgQd0bEQla8m97W39JRtWRMQZyR5EtZsRZr+x7KXjjQF6wNw
        qqrOkRmQyK9i9VBg==
From:   "tip-bot2 for Tom Lendacky" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev-es: Invalidate the GHCB after completing VMGEXIT
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C5a8130462e4f0057ee1184509cd056eedd78742b=2E16212?=
 =?utf-8?q?73353=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
References: =?utf-8?q?=3C5a8130462e4f0057ee1184509cd056eedd78742b=2E162127?=
 =?utf-8?q?3353=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <162131603590.29796.6135941864446470502.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a50c5bebc99c525e7fbc059988c6a5ab8680cb76
Gitweb:        https://git.kernel.org/tip/a50c5bebc99c525e7fbc059988c6a5ab8680cb76
Author:        Tom Lendacky <thomas.lendacky@amd.com>
AuthorDate:    Mon, 17 May 2021 12:42:33 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 18 May 2021 07:06:29 +02:00

x86/sev-es: Invalidate the GHCB after completing VMGEXIT

Since the VMGEXIT instruction can be issued from userspace, invalidate
the GHCB after performing VMGEXIT processing in the kernel.

Invalidation is only required after userspace is available, so call
vc_ghcb_invalidate() from sev_es_put_ghcb(). Update vc_ghcb_invalidate()
to additionally clear the GHCB exit code so that it is always presented
as 0 when VMGEXIT has been issued by anything else besides the kernel.

Fixes: 0786138c78e79 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/5a8130462e4f0057ee1184509cd056eedd78742b.1621273353.git.thomas.lendacky@amd.com
---
 arch/x86/kernel/sev-shared.c | 1 +
 arch/x86/kernel/sev.c        | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 6ec8b3b..9f90f46 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -63,6 +63,7 @@ static bool sev_es_negotiate_protocol(void)
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
+	ghcb->save.sw_exit_code = 0;
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 45e2126..4fa111b 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -457,6 +457,11 @@ static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
 		data->backup_ghcb_active = false;
 		state->ghcb = NULL;
 	} else {
+		/*
+		 * Invalidate the GHCB so a VMGEXIT instruction issued
+		 * from userspace won't appear to be valid.
+		 */
+		vc_ghcb_invalidate(ghcb);
 		data->ghcb_active = false;
 	}
 }
