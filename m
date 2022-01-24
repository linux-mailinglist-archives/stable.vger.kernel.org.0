Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223ED498C91
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346472AbiAXTXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:23:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47230 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349128AbiAXTUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:20:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C5936131E;
        Mon, 24 Jan 2022 19:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA6EC340E5;
        Mon, 24 Jan 2022 19:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052016;
        bh=IV9sGNAAhIv0lTHD76UObbI1oGTX0q68vnnkRH5LISs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlRi065GJUkhqaDp9aXO8Q1+v2tZMTZrH8nBivPvF0XGw1El23mtiNdsBDUNPnwkH
         n4hxhfj2Eop7usjUJuF6S5iXrZVv9t2lzHmQb+20tImWUjq6hmZcLJaIE27XMtXTjX
         dNQ3ntfHdJBy5fjZ5/f8vDk07p+EnHEKOZ0m272Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/239] x86/mce: Mark mce_end() noinstr
Date:   Mon, 24 Jan 2022 19:43:01 +0100
Message-Id: <20220124183947.646418035@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
 arch/x86/kernel/cpu/mcheck/mce.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 56c4456434a82..26adaad3f2587 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1030,10 +1030,13 @@ static int mce_start(int *no_way_out)
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
@@ -1077,7 +1080,8 @@ static int mce_end(int order)
 		/*
 		 * Don't reset anything. That's done by the Monarch.
 		 */
-		return 0;
+		ret = 0;
+		goto out;
 	}
 
 	/*
@@ -1092,6 +1096,10 @@ reset:
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



