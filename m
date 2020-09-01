Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614FD25933F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgIAPXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729788AbgIAPXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:23:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF627206FA;
        Tue,  1 Sep 2020 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973792;
        bh=s1FMidq3wD/dyOM19kLBhZ8R6vwh+ZWiVn506wglIyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWdKRL6XJ2qons59x5uH10LzyiMDBXMCrb9SQuENUrkGIWsVFZPqWdP9Vt8fXAidO
         Ha0rBcdy0MD3WDVSyJeHkxME7A8ioJc5tI8mHsw+D7XCxtswXfD0eg6nV+7hoQ6okZ
         LjaErRgpnQKh0T27qDe/1iJXc+Fn+Y4L6qARhgYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Brazdil <dbrazdil@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/125] KVM: arm64: Fix symbol dependency in __hyp_call_panic_nvhe
Date:   Tue,  1 Sep 2020 17:10:03 +0200
Message-Id: <20200901150936.906354748@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Brazdil <dbrazdil@google.com>

[ Upstream commit b38b298aa4397e2dc74a89b4dd3eac9e59b64c96 ]

__hyp_call_panic_nvhe contains inline assembly which did not declare
its dependency on the __hyp_panic_string symbol.

The static-declared string has previously been kept alive because of a use in
__hyp_call_panic_vhe. Fix this in preparation for separating the source files
between VHE and nVHE when the two users land in two different compilation
units. The static variable otherwise gets dropped when compiling the nVHE
source file, causing an undefined symbol linker error later.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200625131420.71444-2-dbrazdil@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index f3978931aaf40..3cdefd84af545 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -626,7 +626,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 	 * making sure it is a kernel address and not a PC-relative
 	 * reference.
 	 */
-	asm volatile("ldr %0, =__hyp_panic_string" : "=r" (str_va));
+	asm volatile("ldr %0, =%1" : "=r" (str_va) : "S" (__hyp_panic_string));
 
 	__hyp_do_panic(str_va,
 		       spsr,  elr,
-- 
2.25.1



