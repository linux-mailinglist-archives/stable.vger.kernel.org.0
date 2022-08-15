Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B3C594D19
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiHPArC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245366AbiHPAol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:44:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34AF193554;
        Mon, 15 Aug 2022 13:41:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 819BE61234;
        Mon, 15 Aug 2022 20:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD76C433C1;
        Mon, 15 Aug 2022 20:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596078;
        bh=ZlNZIoT0xcoVZ4uXOg7Rh64aSqYXluwZIxnpm37NvZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxPWjquORya+rMGZHv7BuNBb1UvaApczctRtpRselLrVaPRpPlAUWy0unzULNqcu3
         /d8Uf/lEWv4//02GV/Be3VQZ2OzrJme3Zin0XG/zEIKv5jJbrzBfpST+wsaJh6mu26
         +ex4mZTwQ80xOA/0R+TqF610E37F8m/3AJVDpmxc=
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
Subject: [PATCH 5.19 0965/1157] lib/smp_processor_id: fix imbalanced instrumentation_end() call
Date:   Mon, 15 Aug 2022 20:05:21 +0200
Message-Id: <20220815180518.273302726@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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



