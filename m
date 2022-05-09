Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CABF51F705
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 10:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbiEIIqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 04:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237437AbiEIIhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:37:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EE31D501C
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:34:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 377DC61493
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9B2C385AB;
        Mon,  9 May 2022 08:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652085208;
        bh=0rcOmI52cJJ1gsLsnSjQPI33C4fKS4UvpgPoMlcvBZI=;
        h=Subject:To:Cc:From:Date:From;
        b=iF/ewqS4Ut5G4jAOY7N6Mhr1jtyxsNuAx9fcI8nfULy7TXqwUCvGf3JI/mANM7dNS
         G90pACrYfZ3gcngnev+rb+8Xvw58UyHIRzK4t10SPXWHv9VNRPsaYK1BBAawFQTiv2
         2SDLWnPQdtR57aMlfnTw/B7BHgjTckONh/tFOEJY=
Subject: FAILED: patch "[PATCH] timekeeping: Mark NMI safe time accessors as notrace" failed to apply to 4.19-stable tree
To:     kurt@linutronix.de, rostedt@goodmis.org, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:33:18 +0200
Message-ID: <16520851988746@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2c33d775ef4c25c0e1e1cc0fd5496d02f76bfa20 Mon Sep 17 00:00:00 2001
From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Thu, 28 Apr 2022 08:24:32 +0200
Subject: [PATCH] timekeeping: Mark NMI safe time accessors as notrace

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

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index dcdcb85121e4..3b1398fbddaf 100644
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

