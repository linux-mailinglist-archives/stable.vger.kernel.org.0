Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E815949156B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343937AbiARC2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:28:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39678 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244696AbiARCZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:25:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E92EB81253;
        Tue, 18 Jan 2022 02:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95658C36AF2;
        Tue, 18 Jan 2022 02:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472755;
        bh=Ofy4g81vDZybg2OCHJSihL8vm+laLxFzaZgH0WKhCUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eO8EtCNmj0IdX6DRQIVIk5HmsV3Won2Sk1OSCz0S0rVfd9N+jPmIXNr9DeUWARJyT
         iC7aqm14nLeDcOKO6GtY4maznjVs/d/oWTLz9kO3tLuU4IbIYxOw9JdKOq4koXvI3F
         +6MJh4M1wZsbNMRv6QFyM+qG75XDrKGITxbXbwij4XCi9zkrQVcobJsJthrQluwoD7
         NRa88b/zXj+NlseECUv+9W/VhQA5uWRI6bmttqZGLsEEs+9pWLT+/5m3WQCnTodvak
         R3vwXtOvdYJPi5lrC3+lSvh98a/X77R8SfaInVfzE0uNCW9QgpeyumQzA8y1CDOr6c
         pe5DbW/4g2JOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 125/217] x86/mce: Mark mce_end() noinstr
Date:   Mon, 17 Jan 2022 21:18:08 -0500
Message-Id: <20220118021940.1942199-125-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit b4813539d37fa31fed62cdfab7bd2dd8929c5b2e ]

It is called by the #MC handler which is noinstr.

Fixes

  vmlinux.o: warning: objtool: do_machine_check()+0xbd6: call to memset() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211208111343.8130-9-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 9a52ec55e0555..75095986e5eff 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1063,10 +1063,13 @@ static int mce_start(int *no_way_out)
  * Synchronize between CPUs after main scanning loop.
  * This invokes the bulk of the Monarch processing.
  */
-static int mce_end(int order)
+static noinstr int mce_end(int order)
 {
-	int ret = -1;
 	u64 timeout = (u64)mca_cfg.monarch_timeout * NSEC_PER_USEC;
+	int ret = -1;
+
+	/* Allow instrumentation around external facilities. */
+	instrumentation_begin();
 
 	if (!timeout)
 		goto reset;
@@ -1110,7 +1113,8 @@ static int mce_end(int order)
 		/*
 		 * Don't reset anything. That's done by the Monarch.
 		 */
-		return 0;
+		ret = 0;
+		goto out;
 	}
 
 	/*
@@ -1126,6 +1130,10 @@ static int mce_end(int order)
 	 * Let others run again.
 	 */
 	atomic_set(&mce_executing, 0);
+
+out:
+	instrumentation_end();
+
 	return ret;
 }
 
-- 
2.34.1

