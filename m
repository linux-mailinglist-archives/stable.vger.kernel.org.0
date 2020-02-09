Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B457B156A7F
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgBINHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:07:55 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59977 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727661AbgBINHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:07:55 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1760321EA0;
        Sun,  9 Feb 2020 08:07:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:07:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EUlZRc
        N9LV7rihhYgMaczIAWwaRapgZpLTEYvFFw9ps=; b=XMGCaiXY+pe9IXh/mSXMul
        OXd81K/tZ4TPzmUsxxLNqLt6JXjgooIzhyAO3/yjpRkHIgBnVBMb3RvwwrSVcbte
        qBBkFg2XNjpD+1KEcSIzDxEbDdhFp1sRFVE8iyIeS+IYsb5bT7tp8XNlU0jsoAVp
        /lJtQ4vA12YAiaiYinT5RaEF49Ad2mogVnY1Wruk1IG5QX2+qA/F09gi99T4FRcd
        cgKSqQHXfdeWd3HcboW8d6he4+GJ24UjlugjtJVnlkfr+5YLNKftkyEAj4xTFfsA
        am8uv5XRvTN1rYkASO9rF/lAfH307zA/ClYCC1t7tACrRM4gKrwJaN6jaXuJf5jQ
        ==
X-ME-Sender: <xms:KQRAXuKG0GVUdzxUMgn733vWqeBbpKOr5EwXLIg5f501O6gdEul5kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudefne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:KQRAXrEv3RREtpgHop8tiUILi0grf8I0GNlzTtHD-Phe4jCwFz3wAQ>
    <xmx:KQRAXi-EspFU0m2azA13UANN77JPOJkQEYhPQ9Zwn4ZnlQzybJRoiw>
    <xmx:KQRAXjI4uhrk7r4vKTt0wN8kQrA5F7eFYrde49qmp8NcVY73vpuvMg>
    <xmx:KgRAXsYbhcwoj7CZI413UtKJWJv6izEPsHXObBlruFgTcAbpxky4UQ>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 811873280062;
        Sun,  9 Feb 2020 08:07:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF" failed to apply to 4.4-stable tree
To:     pomonis@google.com, ahonig@google.com, jmattson@google.com,
        nifi@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:58:06 +0100
Message-ID: <158124948610483@kroah.com>
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

From 4bf79cb089f6b1c6c632492c0271054ce52ad766 Mon Sep 17 00:00:00 2001
From: Marios Pomonis <pomonis@google.com>
Date: Wed, 11 Dec 2019 12:47:46 -0800
Subject: [PATCH] KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF
 attacks

This fixes a Spectre-v1/L1TF vulnerability in kvm_lapic_reg_write().
This function contains index computations based on the
(attacker-controlled) MSR number.

Fixes: 0105d1a52640 ("KVM: x2apic interface to lapic")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 88c3c0c6d1e3..865edce27a6a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1960,15 +1960,20 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_LVTTHMR:
 	case APIC_LVTPC:
 	case APIC_LVT1:
-	case APIC_LVTERR:
+	case APIC_LVTERR: {
 		/* TODO: Check vector */
+		size_t size;
+		u32 index;
+
 		if (!kvm_apic_sw_enabled(apic))
 			val |= APIC_LVT_MASKED;
-
-		val &= apic_lvt_mask[(reg - APIC_LVTT) >> 4];
+		size = ARRAY_SIZE(apic_lvt_mask);
+		index = array_index_nospec(
+				(reg - APIC_LVTT) >> 4, size);
+		val &= apic_lvt_mask[index];
 		kvm_lapic_set_reg(apic, reg, val);
-
 		break;
+	}
 
 	case APIC_LVTT:
 		if (!kvm_apic_sw_enabled(apic))

