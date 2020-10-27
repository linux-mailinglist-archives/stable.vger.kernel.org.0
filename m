Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FEA29B4C7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793523AbgJ0PGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790473AbgJ0PEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:04:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0C4E206E5;
        Tue, 27 Oct 2020 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811081;
        bh=R5PbW+sXDK7226DchEgeE2gG3rKu+u6XKrP7QE2j8nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTT9jb/Lc+/nc4+SxTnkqbmvbQSE/b13Cd0Hs84NMKAygjeBtURLOUHSw4wgGiMby
         M8jEIjOgx51GQgO2jhFs5MwI/HyoVqJtGZRBpDVrBCxzqkDNU2ncrcnuuSUiz6t0qY
         zQCWArslQwLnhQgSyJRKfvqV6Oob5d3KQNWWz4Uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 366/633] powerpc/tau: Remove duplicated set_thresholds() call
Date:   Tue, 27 Oct 2020 14:51:49 +0100
Message-Id: <20201027135539.868953175@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 420ab2bc7544d978a5d0762ee736412fe9c796ab ]

The commentary at the call site seems to disagree with the code. The
conditional prevents calling set_thresholds() via the exception handler,
which appears to crash. Perhaps that's because it immediately triggers
another TAU exception. Anyway, calling set_thresholds() from TAUupdate()
is redundant because tau_timeout() does so.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/d7c7ee33232cf72a6a6bbb6ef05838b2e2b113c0.1599260540.git.fthain@telegraphics.com.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/tau_6xx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/kernel/tau_6xx.c b/arch/powerpc/kernel/tau_6xx.c
index 268205cc347da..b8d7e7d498e0a 100644
--- a/arch/powerpc/kernel/tau_6xx.c
+++ b/arch/powerpc/kernel/tau_6xx.c
@@ -110,11 +110,6 @@ static void TAUupdate(int cpu)
 #ifdef DEBUG
 	printk("grew = %d\n", tau[cpu].grew);
 #endif
-
-#ifndef CONFIG_TAU_INT /* tau_timeout will do this if not using interrupts */
-	set_thresholds(cpu);
-#endif
-
 }
 
 #ifdef CONFIG_TAU_INT
-- 
2.25.1



