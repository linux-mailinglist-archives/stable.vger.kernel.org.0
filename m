Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFAE6811A5
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbjA3OPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237332AbjA3OPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:15:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E863800D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:15:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A46D36104A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772AEC433EF;
        Mon, 30 Jan 2023 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088132;
        bh=oT1P5XUVK7HCEr04kgGgomyLxUUU0ytJ20oFtBoxtkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xG3RgddaKv8tWlKE1s47G73rVSsYLcPO2+i1baY9+g8AmSjqMx09xoLT0UtvvCOOp
         VslnJABXuTsu3eC0j0pii1FtWXKU71TDXF3FJ/Xlivn90+9vktlwJuKzW0ElgI0r5T
         AT8re6rDzxC0AAFhyMEoJU6KZg2enzJvVIQ2RZX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Marco Elver <elver@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Baoquan He <bhe@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/204] panic: unset panic_on_warn inside panic()
Date:   Mon, 30 Jan 2023 14:51:30 +0100
Message-Id: <20230130134322.002773651@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 1a2383e8b84c0451fd9b1eec3b9aab16f30b597c upstream.

In the current code, the following three places need to unset
panic_on_warn before calling panic() to avoid recursive panics:

kernel/kcsan/report.c: print_report()
kernel/sched/core.c: __schedule_bug()
mm/kfence/report.c: kfence_report_error()

In order to avoid copy-pasting "panic_on_warn = 0" all over the places,
it is better to move it inside panic() and then remove it from the other
places.

Link: https://lkml.kernel.org/r/1644324666-15947-4-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 5ee281b996f9..5ed1ad06f9a3 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -208,6 +208,16 @@ void panic(const char *fmt, ...)
 	int old_cpu, this_cpu;
 	bool _crash_kexec_post_notifiers = crash_kexec_post_notifiers;
 
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
+	}
+
 	/*
 	 * Disable local interrupts. This will prevent panic_smp_self_stop
 	 * from deadlocking the first cpu that invokes the panic, since
@@ -616,16 +626,8 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 	if (regs)
 		show_regs(regs);
 
-	if (panic_on_warn) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
+	if (panic_on_warn)
 		panic("panic_on_warn set ...\n");
-	}
 
 	if (!regs)
 		dump_stack();
-- 
2.39.0



