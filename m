Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C677817077B
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 19:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgBZSSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 13:18:08 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41769 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgBZSSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 13:18:08 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4254C220BA;
        Wed, 26 Feb 2020 13:18:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 13:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hIUYX8
        cM3d1Cf5zMuiVCpHA973zECCdCCP8bLCm5HCQ=; b=qBE89qzBNpHvQUKZVEbiKa
        2ta12orkrImNVXhKr6b0BveF9Ehw1rHa3evFVzduEtnpzZXXLdyhdQZk9UXoI3yp
        aFDgY27u/2sdug+A3jwrjbzl7EzMMFqVzW0x7oKNwNHiMyTaDLLrCWYBvXRRtOEv
        2vB5NerkgQev5kH3FImxF6C+joeMMs2NznVLhWoYLhDhR3S//dbE66mz4WeFAUb9
        z2QC3V0ZBw5EzIWDm0a788HMoaWQMGu5lD8xoSQfJTahuNy6T3aZoI3Y2SARqLnJ
        9LHtRQclC2gYdITdEMt9SzHMmJxfq+rYOAf5NqS2hfUjqFufu/mJNqRWjHl+zgkA
        ==
X-ME-Sender: <xms:X7ZWXonK2jS06LiTu81suou4PWDCGBkBBOF6dRr7UqA9Uup2ep4Now>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedvne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:X7ZWXsFHkDgJkz5AONrMC2Gx2XXRU5Q5U5u9TQzqKUhYNKhidM0-LQ>
    <xmx:X7ZWXhrgfPuqcTmeNi7mEmnxxJv_XF74v61dQ4PRow_JsaDPEUtQhQ>
    <xmx:X7ZWXo7QeXjDcEo7vpQRUWevoH_9jcCgdChmvXaWZVBrcAqGVuAF2w>
    <xmx:X7ZWXo5fc575PSe3wQgXC79GkCrxpoGhxFcp06q4WAepQG9hv2aXzQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D80E030610E9;
        Wed, 26 Feb 2020 13:18:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Don't emulate instructions in guest mode" failed to apply to 4.4-stable tree
To:     pbonzini@redhat.com, oupton@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 19:17:50 +0100
Message-ID: <158274107030156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

