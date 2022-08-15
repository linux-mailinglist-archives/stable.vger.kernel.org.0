Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEE05945CD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351461AbiHOWmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350177AbiHOWi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:38:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A205D7333A;
        Mon, 15 Aug 2022 12:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E535F61231;
        Mon, 15 Aug 2022 19:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17E1C433C1;
        Mon, 15 Aug 2022 19:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593081;
        bh=ZlNZIoT0xcoVZ4uXOg7Rh64aSqYXluwZIxnpm37NvZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lu8tK1LD72Uwv17ymOPA0lChmLhO421nX4fdhQAc4aO728X5zAiSXNxFaE0iyTsNI
         GdFIEuzOFTBZMDHUbqasdoM0pTYVuIBUNqJTjyZcZZhydiQ9UsJ9t50JX5+f4XlY6g
         dTzanmIPxXZqemK0iTyHFH7IJpAUifSvO3GzG3dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0889/1095] lib/smp_processor_id: fix imbalanced instrumentation_end() call
Date:   Mon, 15 Aug 2022 20:04:48 +0200
Message-Id: <20220815180506.110894226@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit bd27acaac24e4b252ee28dddcabaee80456d0faf ]

Currently instrumentation_end() won't be called if printk_ratelimit()
returned false.

Link: https://lkml.kernel.org/r/a636d8e0-ad32-5888-acac-671f7f553bb3@I-love.SAKURA.ne.jp
Fixes: 126f21f0e8d46e2c ("lib/smp_processor_id: Move it into noinstr section")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/smp_processor_id.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 046ac6297c78..a2bb7738c373 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -47,9 +47,9 @@ unsigned int check_preemption_disabled(const char *what1, const char *what2)
 
 	printk("caller is %pS\n", __builtin_return_address(0));
 	dump_stack();
-	instrumentation_end();
 
 out_enable:
+	instrumentation_end();
 	preempt_enable_no_resched_notrace();
 out:
 	return this_cpu;
-- 
2.35.1



