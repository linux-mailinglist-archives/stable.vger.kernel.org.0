Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C08499145
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378945AbiAXUKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44306 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353131AbiAXUAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:00:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32398B80FA1;
        Mon, 24 Jan 2022 20:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62427C36AEB;
        Mon, 24 Jan 2022 20:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054440;
        bh=zA1vUZ3qOrUG9ozfGNzjuB1i+/p5YXJFjtVkvmVp47k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jjc6107ueyZgwc+kXKR/GMxc9dzpNU9Ab4vWHeDAcown23Gyl3OBVp0XJsfkZX+G9
         FZ31SRKUhsb76bqTFi+OK8sqB+EqZo33Emc7fECv+kyWuRZPXGx5d2NA9jR0uVIA55
         6GQYB9RMSs0pLLFQQmrfbmFs5Md/VgqijLz8wNL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/563] x86/mce: Mark mce_end() noinstr
Date:   Mon, 24 Jan 2022 19:42:03 +0100
Message-Id: <20220124184036.798384907@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 64d8a96a2bf1e..2a608f0819765 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1070,10 +1070,13 @@ static int mce_start(int *no_way_out)
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
@@ -1117,7 +1120,8 @@ static int mce_end(int order)
 		/*
 		 * Don't reset anything. That's done by the Monarch.
 		 */
-		return 0;
+		ret = 0;
+		goto out;
 	}
 
 	/*
@@ -1132,6 +1136,10 @@ reset:
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



