Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BF72E3D38
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440008AbgL1OMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439910AbgL1OMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D160F206C3;
        Mon, 28 Dec 2020 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164759;
        bh=jNON4RhqYWiakI3JTWgBAK3/GWcahKidDO8HlqVMaaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOpFPOrn4sEYxFRPelA4iVeylmYoV6UOs6PI/gkXcyJiAnfuB2lG2xVCo0JoMyvkz
         1qt2I3DSJD8NYLjW7ZvK8kAOhd8O+f4ONqlAqkyv48wuYEXFezG1I2WhsJDcRDaVW8
         JYr0mA0pAqtlZqsQMKDmSW5P2clXCx9DnUjfF8xA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 289/717] arm64: mte: fix prctl(PR_GET_TAGGED_ADDR_CTRL) if TCF0=NONE
Date:   Mon, 28 Dec 2020 13:44:47 +0100
Message-Id: <20201228125034.878626884@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

[ Upstream commit 929c1f3384d7e5cd319d03242cb925c3f91236f7 ]

Previously we were always returning a tag inclusion mask of zero via
PR_GET_TAGGED_ADDR_CTRL if TCF0 was set to NONE. Fix it by making
the code for the NONE case match the others.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/Iefbea66cf7d2b4c80b82f9639b9ea7f33f7fac53
Fixes: af5ce95282dc ("arm64: mte: Allow user control of the generated random tags via prctl()")
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20201203075110.2781021-1-pcc@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/mte.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 52a0638ed967b..ef15c8a2a49dc 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -189,7 +189,8 @@ long get_mte_ctrl(struct task_struct *task)
 
 	switch (task->thread.sctlr_tcf0) {
 	case SCTLR_EL1_TCF0_NONE:
-		return PR_MTE_TCF_NONE;
+		ret |= PR_MTE_TCF_NONE;
+		break;
 	case SCTLR_EL1_TCF0_SYNC:
 		ret |= PR_MTE_TCF_SYNC;
 		break;
-- 
2.27.0



