Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D56450E05
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbhKOSKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:10:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239848AbhKOSEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24602632E6;
        Mon, 15 Nov 2021 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997980;
        bh=XzweCvmoHTy63gnpL5NBLwzrwLQJJgkukG8j1sy6zHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXW/f7LkMrDBGCZe5w/CF5QctZll7e4MclJaQ1yjxN0VgW1OGsQhPDO9v/Lk8iduA
         zSFFFEKZU4x2oGDl+vJL7j2qaK/Us2PmGGweGnNRQSXULtk6Zr33Hy7LU4E6lgBubQ
         Pa6/bjwg5SNwV6P0/aHstBnyIHvpsSgd4xQgHbjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 344/575] x86/sev: Fix stack type check in vc_switch_off_ist()
Date:   Mon, 15 Nov 2021 18:01:09 +0100
Message-Id: <20211115165355.694642447@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 5681981fb788281b09a4ea14d310d30b2bd89132 ]

The value of STACK_TYPE_EXCEPTION_LAST points to the last _valid_
exception stack. Reflect that in the check done in the
vc_switch_off_ist() function.

Fixes: a13644f3a53de ("x86/entry/64: Add entry code for #VC handler")
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20211021080833.30875-2-joro@8bytes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 7692bf7908e6c..143fcb8af38f4 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -701,7 +701,7 @@ asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *r
 	stack = (unsigned long *)sp;
 
 	if (!get_stack_info_noinstr(stack, current, &info) || info.type == STACK_TYPE_ENTRY ||
-	    info.type >= STACK_TYPE_EXCEPTION_LAST)
+	    info.type > STACK_TYPE_EXCEPTION_LAST)
 		sp = __this_cpu_ist_top_va(VC2);
 
 sync:
-- 
2.33.0



