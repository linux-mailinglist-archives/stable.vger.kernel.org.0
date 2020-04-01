Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F3019B277
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389450AbgDAQoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389546AbgDAQoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:44:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6BC2063A;
        Wed,  1 Apr 2020 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759454;
        bh=5MkXauhoehfgF1bchJUtFa+ktvr7TubTgXLAVcWSsPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMJZCm1PiJ7oGWgVSWFjIT0ICXL8mvjxojEUI2Zw5EQecmonSRVYIPeT929ddyqjE
         roVOCaErOSJzTeEin7AjOcQSUzoh6SXsIUYdgx6VFGvmXL28zwN62aKojPcmx8QO4F
         3ay91iZJDYIcL49P6DnD1n6PGunFFIr97tjTStVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 085/148] arm64: ptrace: map SPSR_ELx<->PSR for compat tasks
Date:   Wed,  1 Apr 2020 18:17:57 +0200
Message-Id: <20200401161601.264697375@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 76fc52bd07d3e9cb708f1a50b60c825c96acd606 upstream.

The SPSR_ELx format for exceptions taken from AArch32 is slightly
different to the AArch32 PSR format.

Map between the two in the compat ptrace code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Fixes: 7206dc93a58fb764 ("arm64: Expose Arm v8.4 features")
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/ptrace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -833,6 +833,7 @@ static int compat_gpr_get(struct task_st
 			break;
 		case 16:
 			reg = task_pt_regs(target)->pstate;
+			reg = pstate_to_compat_psr(reg);
 			break;
 		case 17:
 			reg = task_pt_regs(target)->orig_x0;
@@ -900,6 +901,7 @@ static int compat_gpr_set(struct task_st
 			newregs.pc = reg;
 			break;
 		case 16:
+			reg = compat_psr_to_pstate(reg);
 			newregs.pstate = reg;
 			break;
 		case 17:


