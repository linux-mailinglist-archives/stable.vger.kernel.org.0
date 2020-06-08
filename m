Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEC61F26C5
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732230AbgFHXie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732216AbgFHX2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:28:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA48420897;
        Mon,  8 Jun 2020 23:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658903;
        bh=Uw9/vRLVgKmqGjw40c38O9e7lpuxn5NHt5DzieU+7Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQJZDW4CB0zAOxjR1p6MjK+Qj+l7ecLfh7JGxBqSCt2U5gLUWO3D0X/0dAq9WqnKJ
         5UVXwkTFiTc+nzEl+nU/TPTK+pY/m/M4FxAjGj/hIu+i4sxxaJis7g+BMBLrLzDdHj
         UJJ/L7/zidNqNMTbRLmtFcZbmuT6bdSqTVdwY6B8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Will Deacon <will@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.4 24/37] kgdb: Fix spurious true from in_dbg_master()
Date:   Mon,  8 Jun 2020 19:27:36 -0400
Message-Id: <20200608232750.3370747-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232750.3370747-1-sashal@kernel.org>
References: <20200608232750.3370747-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

