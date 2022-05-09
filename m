Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A32751F71D
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 10:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbiEIIrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 04:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237456AbiEIIh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:37:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C471D6203
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:34:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE54AB81002
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234AEC385A8;
        Mon,  9 May 2022 08:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652085200;
        bh=ZZDNhVBp4aeYXTONo1/apxQcALkrG+wvn3svDJDLb04=;
        h=Subject:To:Cc:From:Date:From;
        b=ZcZTk4hucOz/oZwbPjavk/7yNTRby6uxckqgBbNYZk5M2rlaG/73V3Jk8hk+Hu7B3
         K9NVGAnq6Xt1X0X0rtBTI8wHU/HExCZoHkn7pRfB+9PsRppk+Tg4iLSpO2lK8lOxYm
         vUfSQ7Y8UmzZmHam4G7BdKQFmO5Vh6nshZTE05JA=
Subject: FAILED: patch "[PATCH] timekeeping: Mark NMI safe time accessors as notrace" failed to apply to 4.9-stable tree
To:     kurt@linutronix.de, rostedt@goodmis.org, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:33:17 +0200
Message-ID: <165208519740125@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
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

