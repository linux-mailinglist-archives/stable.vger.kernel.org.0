Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EF5156A7B
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgBINHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:07:14 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58051 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:07:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6971B21EE9;
        Sun,  9 Feb 2020 08:07:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:07:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ef5Ll8
        +ID1m7tEPL9JmywSZNHPgOtL4m3KWVWNA68+A=; b=qPmAOjfOZ4Bmh9SOUG4wWw
        v0urLIUbL77l+2BuZjnETE5+DZbCvUdDAMX7fpmoIxyn0pvSUFXvVJGQoF9orcW3
        Fi7ujW7u/hFO8lDFFjtfCiz7rbI+G7fbHzkpY92KPDicHwRQFla/yk3WS+iP+Rsv
        yJSgWkRGsVEwqUUrx9cc6AWgDZEl6Rhp0YscbWMkwo62vHyJ21bODvdWQj8gO0P0
        1o6DAV0MGL9OLzQNiYR+Hpmvh7G1hdnyg5yhm/FBq+hxQTgn/VNa7hlzDAFIW6mx
        vGJVlQRarHnlRoqI+YKp7PV/vlRJZeXZdih9PeRgJj37CbSoqXvTUN/+B6lonvmA
        ==
X-ME-Sender: <xms:AQRAXs7X3BoUmCG8WhHuQRmpiHFcXGf1O-yuLGFX7VkvBUFsCmuzkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepleenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AQRAXvvhe3VVm1WmXglgBpWcAcEXfo-L5btVUfV95OBAI-5IsswMhg>
    <xmx:AQRAXtPjj-7z1aO6vzL1O2KHhMqzvARqj2USLRsvCUYUIyOTxEVY8w>
    <xmx:AQRAXiVdmaJjfYjPkxHpRipf3kC7u1YmI8or8594Ubu2zEyYbhuGMw>
    <xmx:AQRAXvlhXB6qeGwDEMDNd4yXGFHJbKWV_-kohjoW1VniSF1pXesRsA>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 114193060272;
        Sun,  9 Feb 2020 08:07:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF" failed to apply to 4.4-stable tree
To:     pomonis@google.com, ahonig@google.com, jmattson@google.com,
        nifi@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:54:21 +0100
Message-ID: <158124926134148@kroah.com>
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

From 14e32321f3606e4b0970200b6e5e47ee6f1e6410 Mon Sep 17 00:00:00 2001
From: Marios Pomonis <pomonis@google.com>
Date: Wed, 11 Dec 2019 12:47:43 -0800
Subject: [PATCH] KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF
 attacks

This fixes a Spectre-v1/L1TF vulnerability in picdev_write().
It replaces index computations based on the (attacked-controlled) port
number with constants through a minor refactoring.

Fixes: 85f455f7ddbe ("KVM: Add support for in-kernel PIC emulation")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 8b38bb4868a6..629a09ca9860 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -460,10 +460,14 @@ static int picdev_write(struct kvm_pic *s,
 	switch (addr) {
 	case 0x20:
 	case 0x21:
+		pic_lock(s);
+		pic_ioport_write(&s->pics[0], addr, data);
+		pic_unlock(s);
+		break;
 	case 0xa0:
 	case 0xa1:
 		pic_lock(s);
-		pic_ioport_write(&s->pics[addr >> 7], addr, data);
+		pic_ioport_write(&s->pics[1], addr, data);
 		pic_unlock(s);
 		break;
 	case 0x4d0:

