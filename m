Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657194EC2A5
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344297AbiC3MAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345884AbiC3LzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86446264F42;
        Wed, 30 Mar 2022 04:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 320F4B81C24;
        Wed, 30 Mar 2022 11:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236DFC340F3;
        Wed, 30 Mar 2022 11:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641119;
        bh=rIZn5+eI9OGZYfZ/nAxEa+l5OOXQL4kgFdHi9HXbh3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5vPU26q3JPrMJgLpezIr9egkdAu3UeLtDB4k2zasuFIpkW1elVd9vZF0d4mcy9Av
         CuKSPcyh/5vxbDFnjLlxiUqJ2kOIBPGp0bt4snAcJNQOXiS+8rUX2foDyasiFA+mFz
         TGPHQw6tK9p+1ll1zs3z6XZnpeWagmVEPSg10eB4JSCgUPLrn2TXIGJA2ALXDF1ogu
         Cu8w72Z9x5YpoqoPueYadoGjU3Jtr5KGr/MHz1MjvnSqrWAsPE9Lnd3i+nKCmV/q4K
         WB8Pse2nbl9pdYrmrBzqM+xtt12lzxIFVz3xL00ZH9M6NYfYe6rdE5141a11tcEkWl
         rM8vCBDD+lCig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Brennan <stephen.s.brennan@oracle.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Subject: [PATCH AUTOSEL 5.10 22/37] printk: Add panic_in_progress helper
Date:   Wed, 30 Mar 2022 07:51:07 -0400
Message-Id: <20220330115122.1671763-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115122.1671763-1-sashal@kernel.org>
References: <20220330115122.1671763-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Stephen Brennan <stephen.s.brennan@oracle.com>

[ Upstream commit 77498617857f68496b360081dde1a492d40c28b2 ]

This will be used help avoid deadlocks during panics. Although it would
be better to include this in linux/panic.h, it would require that header
to include linux/atomic.h as well. On some architectures, this results
in a circular dependency as well. So instead add the helper directly to
printk.c.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20220202171821.179394-2-stephen.s.brennan@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 85351a12c85d..c131ad6fadfe 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -256,6 +256,11 @@ static void __up_console_sem(unsigned long ip)
 }
 #define up_console_sem() __up_console_sem(_RET_IP_)
 
+static bool panic_in_progress(void)
+{
+	return unlikely(atomic_read(&panic_cpu) != PANIC_CPU_INVALID);
+}
+
 /*
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
-- 
2.34.1

