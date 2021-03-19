Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6B7341C8B
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCSMVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhCSMVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:21:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8FB064F70;
        Fri, 19 Mar 2021 12:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156466;
        bh=Xcc8nWtyMx5sPP+4P1k1eqlJ2Cjeaazg4/FReZxbHAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqM3K4M+hTmjUA2ELWSEyFexKQhjxF9kp2CTGkXLaO1XuVbzwsy1wcssAK2+2pSNp
         HA8e/dc5j0Ltdhn/WSgyvtmId2ROL3NJ+oXd33zoDzRD3Pbmu8xlIb0VZDl4MrZvP5
         jle52on9M6c0UGAJ8EBMi5fducJAJnQ3Hnif0TZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.11 25/31] arm64: Unconditionally set virtual cpu id registers
Date:   Fri, 19 Mar 2021 13:19:19 +0100
Message-Id: <20210319121748.016916968@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

Commit 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
reorganized el2 setup in such way that virtual cpu id registers set
only in nVHE, yet they used (and need) to be set irrespective VHE
support.

Fixes: 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/el2_setup.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -111,7 +111,7 @@
 .endm
 
 /* Virtual CPU ID registers */
-.macro __init_el2_nvhe_idregs
+.macro __init_el2_idregs
 	mrs	x0, midr_el1
 	mrs	x1, mpidr_el1
 	msr	vpidr_el2, x0
@@ -163,6 +163,7 @@
 	__init_el2_stage2
 	__init_el2_gicv3
 	__init_el2_hstr
+	__init_el2_idregs
 
 	/*
 	 * When VHE is not in use, early init of EL2 needs to be done here.
@@ -171,7 +172,6 @@
 	 * will be done via the _EL1 system register aliases in __cpu_setup.
 	 */
 .ifeqs "\mode", "nvhe"
-	__init_el2_nvhe_idregs
 	__init_el2_nvhe_cptr
 	__init_el2_nvhe_sve
 	__init_el2_nvhe_prepare_eret


