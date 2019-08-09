Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB09187BD6
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407282AbfHINrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406833AbfHINrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60747217F4;
        Fri,  9 Aug 2019 13:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358458;
        bh=yTQUjLiGg98j1+bl78Zq1HHFkNqXgz6yiBPO75nQCiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNbWFWQSvDHPl+/qGtGVrif5TEb4ppIbOPcQ4BCk4sohFfxcd9hRwSW35WOFZe3VE
         wXiOUT3DET+ql4hlMam977+PrsVZ0iSDOBSLs6AukYTml1HSg03KnoGAKwwVq4yqCq
         YIhQDIm7rcZytnVwFoMqHl3i/LONfJ+unizU//yE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 31/32] x86/entry/64: Use JMP instead of JMPQ
Date:   Fri,  9 Aug 2019 15:45:34 +0200
Message-Id: <20190809133923.929468509@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 64dbc122b20f75183d8822618c24f85144a5a94d upstream.

Somehow the swapgs mitigation entry code patch ended up with a JMPQ
instruction instead of JMP, where only the short jump is needed.  Some
assembler versions apparently fail to optimize JMPQ into a two-byte JMP
when possible, instead always using a 7-byte JMP with relocation.  For
some reason that makes the entry code explode with a #GP during boot.

Change it back to "JMP" as originally intended.

Fixes: 18ec54fdd6d1 ("x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations")
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -434,7 +434,7 @@ END(irq_entries_start)
 	TRACE_IRQS_OFF
 
 	CALL_enter_from_user_mode
-	jmpq	2f
+	jmp	2f
 1:
 	FENCE_SWAPGS_KERNEL_ENTRY
 2:


