Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66DD6101844
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbfKSFdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbfKSFdd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:33:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33B2121783;
        Tue, 19 Nov 2019 05:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141612;
        bh=n5yr41YAv3AwtUDx9GH1S0juy9nxJL2b9z1AYymp6yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxPu9gAdWpIICQeiDn6nRUAynhfTd9F4KpwaN8Yb4Zdgu0bPOoTLNiOkQ4DkiiQBk
         9r2t6vjatBGR0UXjnG2NuLnULIi23eryTSZsMVmQz98MhaNGJvf9921/41NCxTFG42
         OMFjogfHDk0YJY7Zk2O3x8FcVU2Gpbb+k6vdzPEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hari Vyas <hari.vyas@broadcom.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 219/422] arm64: fix for bad_mode() handler to always result in panic
Date:   Tue, 19 Nov 2019 06:16:56 +0100
Message-Id: <20191119051412.815727853@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Vyas <hari.vyas@broadcom.com>

[ Upstream commit e4ba15debcfd27f60d43da940a58108783bff2a6 ]

The bad_mode() handler is called if we encounter an uunknown exception,
with the expectation that the subsequent call to panic() will halt the
system. Unfortunately, if the exception calling bad_mode() is taken from
EL0, then the call to die() can end up killing the current user task and
calling schedule() instead of falling through to panic().

Remove the die() call altogether, since we really want to bring down the
machine in this "impossible" case.

Signed-off-by: Hari Vyas <hari.vyas@broadcom.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/traps.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index a0099be4311ae..c8dc3a3640e7e 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -611,7 +611,6 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 		handler[reason], smp_processor_id(), esr,
 		esr_get_class_string(esr));
 
-	die("Oops - bad mode", regs, 0);
 	local_daif_mask();
 	panic("bad mode");
 }
-- 
2.20.1



