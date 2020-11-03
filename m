Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1452A57DD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732043AbgKCVqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732056AbgKCUwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ABE92053B;
        Tue,  3 Nov 2020 20:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436733;
        bh=CW705dfPC+HRWp4+0+GOOvbCAY93A+1RXl1xBKjNevs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFaCLxFLnbIYzp5aaEGlxjxLXIu+nce+rU4Sk6u+nsgBc5eJcMmrPUuTF20uTQZa0
         E1zL2EB6udrZJTU64DxFqwV/8h6v+vDrKmE6LBvaB4wrvNEW+U8Wp3wnUA6tvsSeRs
         FKLx59AWTtIiY7SksZ+0CAUYnPy9j0B4tdvZB8Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.9 378/391] KVM: x86: Fix NULL dereference at kvm_msr_ignored_check()
Date:   Tue,  3 Nov 2020 21:37:09 +0100
Message-Id: <20201103203412.671287363@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit d383b3146d805a743658225c8973f5d38c6fedf4 upstream.

The newly introduced kvm_msr_ignored_check() tries to print error or
debug messages via vcpu_*() macros, but those may cause Oops when NULL
vcpu is passed for KVM_GET_MSRS ioctl.

Fix it by replacing the print calls with kvm_*() macros.

(Note that this will leave vcpu argument completely unused in the
 function, but I didn't touch it to make the fix as small as
 possible.  A clean up may be applied later.)

Fixes: 12bc2132b15e ("KVM: X86: Do the same ignore_msrs check for feature msrs")
BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1178280
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-Id: <20201030151414.20165-1-tiwai@suse.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -259,13 +259,13 @@ static int kvm_msr_ignored_check(struct
 
 	if (ignore_msrs) {
 		if (report_ignored_msrs)
-			vcpu_unimpl(vcpu, "ignored %s: 0x%x data 0x%llx\n",
-				    op, msr, data);
+			kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n",
+				      op, msr, data);
 		/* Mask the error */
 		return 0;
 	} else {
-		vcpu_debug_ratelimited(vcpu, "unhandled %s: 0x%x data 0x%llx\n",
-				       op, msr, data);
+		kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
+				      op, msr, data);
 		return 1;
 	}
 }


