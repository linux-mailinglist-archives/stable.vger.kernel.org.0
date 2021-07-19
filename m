Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2022D3CE3DF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbhGSPks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347184AbhGSPe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA3F66145B;
        Mon, 19 Jul 2021 16:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711124;
        bh=5+Jq1NdYPypHrnF6YgOEQMzgRw5KO02+NpnxpMDtenc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPKj3lXabBVrHxCq9z55Fq1D3tTAo8KPaehcSZPlKHVupfrC4CiRvwVTJkuuwx8ad
         oNr0HJw0FFJna91ORgf2qltjvkEvyx+BVfwJpsRNF7B4tUwIFZAZv+iYNTVHiY8osd
         xu5cV4Lz7LKJGusCSIZNAjQFHDQikRVUKNt1PmfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 235/351] x86/fpu: Limit xstate copy size in xstateregs_set()
Date:   Mon, 19 Jul 2021 16:53:01 +0200
Message-Id: <20210719144952.722297472@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 07d6688b22e09be465652cf2da0da6bf86154df6 ]

If the count argument is larger than the xstate size, this will happily
copy beyond the end of xstate.

Fixes: 91c3dba7dbc1 ("x86/fpu/xstate: Fix PTRACE frames for XSAVES")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210623121452.120741557@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/regset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index c413756ba89f..6bb874441de8 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -117,7 +117,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	/*
 	 * A whole standard-format XSAVE buffer is needed:
 	 */
-	if ((pos != 0) || (count < fpu_user_xstate_size))
+	if (pos != 0 || count != fpu_user_xstate_size)
 		return -EFAULT;
 
 	xsave = &fpu->state.xsave;
-- 
2.30.2



