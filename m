Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E39200CCA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389251AbgFSOtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389246AbgFSOtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:49:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D67BB217D8;
        Fri, 19 Jun 2020 14:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578187;
        bh=Uw9/vRLVgKmqGjw40c38O9e7lpuxn5NHt5DzieU+7Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ii4/PIoPrdf+SvdK+tKTMgvJ1kt9sgZ6pLc5LY9ylw0vLCH6RqCo51VaZjFqS7MDf
         paUcemSvQc3OxVqJJ+PCZPglnePtA+CaemenwHWo2SY/fYuv7TJf3mdC+tJFEv8rXR
         0G9U2XclBeoi2hkHrSF94B/neVS95KBVS3mLSGC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 116/190] kgdb: Fix spurious true from in_dbg_master()
Date:   Fri, 19 Jun 2020 16:32:41 +0200
Message-Id: <20200619141639.431837006@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

[ Upstream commit 3fec4aecb311995189217e64d725cfe84a568de3 ]

Currently there is a small window where a badly timed migration could
cause in_dbg_master() to spuriously return true. Specifically if we
migrate to a new core after reading the processor id and the previous
core takes a breakpoint then we will evaluate true if we read
kgdb_active before we get the IPI to bring us to halt.

Fix this by checking irqs_disabled() first. Interrupts are always
disabled when we are executing the kgdb trap so this is an acceptable
prerequisite. This also allows us to replace raw_smp_processor_id()
with smp_processor_id() since the short circuit logic will prevent
warnings from PREEMPT_DEBUG.

Fixes: dcc7871128e9 ("kgdb: core changes to support kdb")
Suggested-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200506164223.2875760-1-daniel.thompson@linaro.org
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kgdb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index e465bb15912d..6be5545d3584 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -317,7 +317,7 @@ extern void gdbstub_exit(int status);
 extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
 #define in_dbg_master() \
-	(raw_smp_processor_id() == atomic_read(&kgdb_active))
+	(irqs_disabled() && (smp_processor_id() == atomic_read(&kgdb_active)))
 extern bool dbg_is_early;
 extern void __init dbg_late_init(void);
 #else /* ! CONFIG_KGDB */
-- 
2.25.1



