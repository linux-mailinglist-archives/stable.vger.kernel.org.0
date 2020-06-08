Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B12A1F246D
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgFHXVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbgFHXVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 713BB2086A;
        Mon,  8 Jun 2020 23:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658467;
        bh=EPvLA69U/3lpdJqAkicuhqkJDkhVEvtI1+W5+HOOb80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Keg6KlwfXA3JBPmP9D1FZmVsuMYtBJQvo9zwkMmSC4ihJIQ5bgAgLJaGW4CqAyvRF
         5DwBIFkbU2gc/vvsaO4PsjxKvBlnAQYST3WTCg52zlwvTtsyXufLfAZlsxX4Giek48
         pYfzp0E6zOw4nl8agbLdWg8lHz8BAqkvyZKADv4Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Will Deacon <will@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 105/175] kgdb: Fix spurious true from in_dbg_master()
Date:   Mon,  8 Jun 2020 19:17:38 -0400
Message-Id: <20200608231848.3366970-105-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
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
index b072aeb1fd78..4d6fe87fd38f 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -323,7 +323,7 @@ extern void gdbstub_exit(int status);
 extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
 #define in_dbg_master() \
-	(raw_smp_processor_id() == atomic_read(&kgdb_active))
+	(irqs_disabled() && (smp_processor_id() == atomic_read(&kgdb_active)))
 extern bool dbg_is_early;
 extern void __init dbg_late_init(void);
 extern void kgdb_panic(const char *msg);
-- 
2.25.1

