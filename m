Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F1731F47
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfFANnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbfFANSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BB33251C3;
        Sat,  1 Jun 2019 13:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395112;
        bh=ovK+AB50RkngX4ySnqrgWIrQ10Rt36zLYGZVQ5jDaEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOoX3RVSC2czln8hXAFsYlqAA9ywtxCUbgqthgcsFAcFMhBZjV9Z/9FB/jwjk5gX0
         /li0cRVty374P7gtvQ3yNUWlCndYmdo2iiV7G4bmnR5dun9+hPairYLFmZXNH21STR
         dAAAVv94lsdp/Ulh9cnrjS3D5FTJ//eVQofdBh6I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Douglas Anderson <dianders@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        kernel-hardening@lists.openwall.com
Subject: [PATCH AUTOSEL 5.1 037/186] gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC < 6
Date:   Sat,  1 Jun 2019 09:14:13 -0400
Message-Id: <20190601131653.24205-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 259799ea5a9aa099a267f3b99e1f7078bbaf5c5e ]

Use gen_rtx_set instead of gen_rtx_SET. The former is a wrapper macro
that handles the difference between GCC versions implementing
the latter.

This fixes the following error on my system with g++ 5.4.0 as the host
compiler

   HOSTCXX -fPIC scripts/gcc-plugins/arm_ssp_per_task_plugin.o
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c:42:14: error: macro "gen_rtx_SET" requires 3 arguments, but only 2 given
          mask)),
               ^
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c: In function ‘unsigned int arm_pertask_ssp_rtl_execute()’:
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c:39:20: error: ‘gen_rtx_SET’ was not declared in this scope
    emit_insn_before(gen_rtx_SET

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Fixes: 189af4657186 ("ARM: smp: add support for per-task stack canaries")
Cc: stable@vger.kernel.org
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
index 89c47f57d1ce1..8c1af9bdcb1bb 100644
--- a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
+++ b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
@@ -36,7 +36,7 @@ static unsigned int arm_pertask_ssp_rtl_execute(void)
 		mask = GEN_INT(sext_hwi(sp_mask, GET_MODE_PRECISION(Pmode)));
 		masked_sp = gen_reg_rtx(Pmode);
 
-		emit_insn_before(gen_rtx_SET(masked_sp,
+		emit_insn_before(gen_rtx_set(masked_sp,
 					     gen_rtx_AND(Pmode,
 							 stack_pointer_rtx,
 							 mask)),
-- 
2.20.1

