Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D635CD5ED
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbfJFRlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbfJFRlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:41:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF9782053B;
        Sun,  6 Oct 2019 17:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383698;
        bh=EwefwZg1gkRd5D8AdLXuQmAzwpk0VAcJjXwCvpznLlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhgZXXsFh60aclNlhFqaIKUusMUJojxLk8nNNd4nmfJ3SiCAB2CKj5Q1VtTMoMPz0
         sw+9ME1Jowa2cz+3ylr55iVRY3ADKa7kErmtrEyDp1g8pnFid7o06FVt9uzeAyweeh
         twP+k7tr5v9XDkanNkImv+z0NafuhKtqNEkgOWlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 062/166] powerpc/64s/exception: machine check use correct cfar for late handler
Date:   Sun,  6 Oct 2019 19:20:28 +0200
Message-Id: <20191006171218.439787495@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 0b66370c61fcf5fcc1d6901013e110284da6e2bb ]

Bare metal machine checks run an "early" handler in real mode before
running the main handler which reports the event.

The main handler runs exactly as a normal interrupt handler, after the
"windup" which sets registers back as they were at interrupt entry.
CFAR does not get restored by the windup code, so that will be wrong
when the handler is run.

Restore the CFAR to the saved value before running the late handler.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190802105709.27696-8-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/exceptions-64s.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 6ba3cc2ef8abc..36c8a3652cf3a 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1211,6 +1211,10 @@ FTR_SECTION_ELSE
 ALT_FTR_SECTION_END_IFSET(CPU_FTR_HVMODE)
 9:
 	/* Deliver the machine check to host kernel in V mode. */
+BEGIN_FTR_SECTION
+	ld	r10,ORIG_GPR3(r1)
+	mtspr	SPRN_CFAR,r10
+END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 	MACHINE_CHECK_HANDLER_WINDUP
 	EXCEPTION_PROLOG_0 PACA_EXMC
 	b	machine_check_pSeries_0
-- 
2.20.1



