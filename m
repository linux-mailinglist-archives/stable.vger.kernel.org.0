Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37A0170779
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 19:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgBZSRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 13:17:52 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40455 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726970AbgBZSRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 13:17:52 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 18275220B5;
        Wed, 26 Feb 2020 13:17:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 13:17:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=n7Dru7
        vcs3PdYYA9+1FuQzc2w46tUlKu8xBF64cIXlk=; b=lTZ7wBlHKpZvyIKmbCHEQE
        ggwuft3u56x2fN/e5c/SK0GrZeTnZeMcoOBdorKOvTbvI+M1Lw9kCXonW32loPb8
        Ymdq5pzAwE3kCD1SxgMhz+ynzVQOCC+okoXYmnfJXil4g9nGYCg+pjLljCeoMCUD
        8QYAUMw+ZsfBHYji/7UqC3nbmR9YRb35ZfCAc3fauDz2W9q5spiaXP2bSSHF5wDN
        GyBGhWipljN+xSXOE17Z+BP7Oo/B4m2wkiuUah6bs2jqPtSmUthhMFQv/GdIfFXF
        MMyGpG1f5FD0nJxbsatj9sBJ+QHSd042GWmrh1l4JltRcIZBlrg7ay2UAeV654xg
        ==
X-ME-Sender: <xms:TrZWXhcQbiZNO73vWjJQo1b3aI-IXlU2OV5-8mPUQN8sQI_IuJgbJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TrZWXrOBPeeYDw1QyAWvEpT2YoiNWA5SdiRFivD6x9QUOp281LetSQ>
    <xmx:TrZWXstbfgViIxICPlzDeHln_9yJxe6maWo1SYSaXk3HFh9_hQxCwA>
    <xmx:TrZWXsBXHblfUOjbUj74Jrr7HsYKrwrwng7EC2YOoz3U3tTk0FofZA>
    <xmx:T7ZWXqTpnbqTj6AWhRgJqeyfIjeiUqrVsD-jtjzBDdgyYYInStxvqw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A3023280066;
        Wed, 26 Feb 2020 13:17:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Don't emulate instructions in guest mode" failed to apply to 4.14-stable tree
To:     pbonzini@redhat.com, oupton@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 19:17:49 +0100
Message-ID: <158274106920052@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 07721feee46b4b248402133228235318199b05ec Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 4 Feb 2020 15:26:29 -0800
Subject: [PATCH] KVM: nVMX: Don't emulate instructions in guest mode

vmx_check_intercept is not yet fully implemented. To avoid emulating
instructions disallowed by the L1 hypervisor, refuse to emulate
instructions by default.

Cc: stable@vger.kernel.org
[Made commit, added commit msg - Oliver]
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dcca514ffd42..5801a86f9c24 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7164,7 +7164,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	}
 
 	/* TODO: check more intercepts... */
-	return X86EMUL_CONTINUE;
+	return X86EMUL_UNHANDLEABLE;
 }
 
 #ifdef CONFIG_X86_64

