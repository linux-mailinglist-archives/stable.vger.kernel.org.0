Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779C9513E6E
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 00:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245263AbiD1WUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 18:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237230AbiD1WUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 18:20:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24CCBF31B;
        Thu, 28 Apr 2022 15:16:48 -0700 (PDT)
Date:   Thu, 28 Apr 2022 22:16:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651184206;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6XUAGNI2/DJ8fzMzq4AB/zY+bre+PBrgDH1qfXscxwI=;
        b=f7dsZ3GrfRUVfRu882jogb00ijfgvQfB0PKy7agxd885QocKyeEyMs3cXhzQ/CD7LM763q
        arD4HbhdxbAZco3Pnxa0USUGxS2+KMzZ/G8xnRbTLvpfxXCm0rLZAP9CGxB0w7EF0VQEIo
        wpw0EzM8ozW9ddeLaZ+Z6lTTZr4ROMchphW9G9g7cN0xGU1uVUpMecxzDHnlogVbCdi3Wh
        jfYRVTJs1e4XHV4rZixnwkiOd+yafs2qxvtlkACMNXl2u0foceqMGloYMuH7MxMuqsUcDB
        Z3ULDpmAz9qAjaG0bRvuDES+6iBXk9D4BwXby+Y/G6mRWgrfHHYzlrylina7aA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651184206;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6XUAGNI2/DJ8fzMzq4AB/zY+bre+PBrgDH1qfXscxwI=;
        b=A93aJha1ZsQRQzQs7MGwQkUmiolBAtNyp0jA1p4+xwo85HG4anNV+AIrY55H005HXfSoDQ
        +NPQxzD5NuFOwBCw==
From:   "tip-bot2 for Kurt Kanzenbach" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] timekeeping: Mark NMI safe time accessors as notrace
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220428062432.61063-1-kurt@linutronix.de>
References: <20220428062432.61063-1-kurt@linutronix.de>
MIME-Version: 1.0
Message-ID: <165118420512.4207.5310310414914439031.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     2c33d775ef4c25c0e1e1cc0fd5496d02f76bfa20
Gitweb:        https://git.kernel.org/tip/2c33d775ef4c25c0e1e1cc0fd5496d02f76bfa20
Author:        Kurt Kanzenbach <kurt@linutronix.de>
AuthorDate:    Thu, 28 Apr 2022 08:24:32 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 29 Apr 2022 00:07:53 +02:00

timekeeping: Mark NMI safe time accessors as notrace

Mark the CLOCK_MONOTONIC fast time accessors as notrace. These functions are
used in tracing to retrieve timestamps, so they should not recurse.

Fixes: 4498e7467e9e ("time: Parametrize all tk_fast_mono users")
Fixes: f09cb9a1808e ("time: Introduce tk_fast_raw")
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220426175338.3807ca4f@gandalf.local.home/
Link: https://lore.kernel.org/r/20220428062432.61063-1-kurt@linutronix.de
---
 kernel/time/timekeeping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index dcdcb85..3b1398f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -482,7 +482,7 @@ static __always_inline u64 __ktime_get_fast_ns(struct tk_fast *tkf)
  * of the following timestamps. Callers need to be aware of that and
  * deal with it.
  */
-u64 ktime_get_mono_fast_ns(void)
+u64 notrace ktime_get_mono_fast_ns(void)
 {
 	return __ktime_get_fast_ns(&tk_fast_mono);
 }
@@ -494,7 +494,7 @@ EXPORT_SYMBOL_GPL(ktime_get_mono_fast_ns);
  * Contrary to ktime_get_mono_fast_ns() this is always correct because the
  * conversion factor is not affected by NTP/PTP correction.
  */
-u64 ktime_get_raw_fast_ns(void)
+u64 notrace ktime_get_raw_fast_ns(void)
 {
 	return __ktime_get_fast_ns(&tk_fast_raw);
 }
