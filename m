Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDECE21FAEB
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbgGNS45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731044AbgGNS4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F956229CA;
        Tue, 14 Jul 2020 18:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753011;
        bh=iRx1+1p0vuvi3P51WF8Ek61xIZ9udJj8O2ghz7fif+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkteAJYMrzERJ7AUJbYV3xWhX3eXhQGkNE0ieFTxLaTldTCEXUyMqSX2gY7CQBgLg
         2M0pDfjLKVBLkpLJeo2xd1F5FdXk2nz2Xv+Ff0/pXRfE1IjaB+E3PHAtfd6a8XgLG8
         6onPx2G0ptDyacImHe8BXaxYzZZ7rsZkJffeb2Ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 085/166] powerpc/64s/exception: Fix 0x1500 interrupt handler crash
Date:   Tue, 14 Jul 2020 20:44:10 +0200
Message-Id: <20200714184119.922263353@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 4557ac6b344b8cdf948ff8b007e8e1de34832f2e ]

A typo caused the interrupt handler to branch immediately to the
common "unknown interrupt" handler and skip the special case test for
denormal cause.

This does not affect KVM softpatch handling (e.g., for POWER9 TM
assist) because the KVM test was moved to common code by commit
9600f261acaa ("powerpc/64s/exception: Move KVM test to common code")
just before this bug was introduced.

Fixes: 3f7fbd97d07d ("powerpc/64s/exception: Clean up SRR specifiers")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
[mpe: Split selftest into a separate patch]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200708074942.1713396-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/exceptions-64s.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index d9ddce40bed89..fd99d4feec7a4 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2547,7 +2547,7 @@ EXC_VIRT_NONE(0x5400, 0x100)
 INT_DEFINE_BEGIN(denorm_exception)
 	IVEC=0x1500
 	IHSRR=1
-	IBRANCH_COMMON=0
+	IBRANCH_TO_COMMON=0
 	IKVM_REAL=1
 INT_DEFINE_END(denorm_exception)
 
-- 
2.25.1



