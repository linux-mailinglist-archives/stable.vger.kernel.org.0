Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E99200E2D
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391315AbgFSPFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391331AbgFSPFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:05:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71E412158C;
        Fri, 19 Jun 2020 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579140;
        bh=q2rVo/aR3JTRBRIML0kZmbB8f0+fBsJ6fAx8XSXDfSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzOiDE924EOoSB++dhIKtoxaTUsFNVvQZBm2KEvni9Rh4nyoGfVBh8YlWfFtKvFaw
         MfnGptHuzZT5h1QnjI7CDZ+Fr4pZnKHkaJyia2BhfPAUJycxDO+64pgJ63rnCKt0nO
         1PLNzt72FNR/5wViCHYJm8EpcFFnjcrmMHbsGgtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/261] arm64: cacheflush: Fix KGDB trap detection
Date:   Fri, 19 Jun 2020 16:30:33 +0200
Message-Id: <20200619141650.972111586@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

[ Upstream commit ab8ad279ceac4fc78ae4dcf1a26326e05695e537 ]

flush_icache_range() contains a bodge to avoid issuing IPIs when the kgdb
trap handler is running because issuing IPIs is unsafe (and not needed)
in this execution context. However the current test, based on
kgdb_connected is flawed: it both over-matches and under-matches.

The over match occurs because kgdb_connected is set when gdb attaches
to the stub and remains set during normal running. This is relatively
harmelss because in almost all cases irq_disabled() will be false.

The under match is more serious. When kdb is used instead of kgdb to access
the debugger then kgdb_connected is not set in all the places that the
debug core updates sw breakpoints (and hence flushes the icache). This
can lead to deadlock.

Fix by replacing the ad-hoc check with the proper kgdb macro. This also
allows us to drop the #ifdef wrapper.

Fixes: 3b8c9f1cdfc5 ("arm64: IPI each CPU after invalidating the I-cache for kernel mappings")
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20200504170518.2959478-1-daniel.thompson@linaro.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cacheflush.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index 665c78e0665a..3e7dda6f1ab1 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -79,7 +79,7 @@ static inline void flush_icache_range(unsigned long start, unsigned long end)
 	 * IPI all online CPUs so that they undergo a context synchronization
 	 * event and are forced to refetch the new instructions.
 	 */
-#ifdef CONFIG_KGDB
+
 	/*
 	 * KGDB performs cache maintenance with interrupts disabled, so we
 	 * will deadlock trying to IPI the secondary CPUs. In theory, we can
@@ -89,9 +89,9 @@ static inline void flush_icache_range(unsigned long start, unsigned long end)
 	 * the patching operation, so we don't need extra IPIs here anyway.
 	 * In which case, add a KGDB-specific bodge and return early.
 	 */
-	if (kgdb_connected && irqs_disabled())
+	if (in_dbg_master())
 		return;
-#endif
+
 	kick_all_cpus_sync();
 }
 
-- 
2.25.1



