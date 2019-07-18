Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 210E06C7B0
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389194AbfGRD0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389432AbfGRDDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:03:47 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8659F21849;
        Thu, 18 Jul 2019 03:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419027;
        bh=a47H8W+xBmolqSVRMvi/L/n07whQ4LJQJZWsbtD/mu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqE94u0f64OJYIK3YUDRWxh+QNLxNrhgPixEimtq8cpq6eqlEtBl0cElhzHi0V3hI
         mgGuWeL38Kn8MaP3v3JxhyyKSAiaG1pXlm11X8V8Twj+oicMR27eAdSQG6D6+9bI4Z
         zOsOjSqzfWTi3mPUkBcpNy8urjwYYA28GVySjqlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 21/21] x86/entry/32: Fix ENDPROC of common_spurious
Date:   Thu, 18 Jul 2019 12:01:39 +0900
Message-Id: <20190718030036.725973946@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
References: <20190718030030.456918453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1cbec37b3f9cff074a67bef4fc34b30a09958a0a ]

common_spurious is currently ENDed erroneously. common_interrupt is used
in its ENDPROC. So fix this mistake.

Found by my asm macros rewrite patchset.

Fixes: f8a8fe61fec8 ("x86/irq: Seperate unused system vectors from spurious entry again")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190709063402.19847-1-jslaby@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 44c6e6f54bf7..f49e11669271 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1125,7 +1125,7 @@ common_spurious:
 	movl	%esp, %eax
 	call	smp_spurious_interrupt
 	jmp	ret_from_intr
-ENDPROC(common_interrupt)
+ENDPROC(common_spurious)
 #endif
 
 /*
-- 
2.20.1



