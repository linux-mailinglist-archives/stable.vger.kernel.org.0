Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA55A197B9B
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 14:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbgC3MOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 08:14:30 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56281 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729705AbgC3MOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 08:14:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 268C05C059C;
        Mon, 30 Mar 2020 08:14:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 30 Mar 2020 08:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xIEA6y
        6VqMdhhk2KL2xxKPCEa2QltKJOlh/mIQUT3Fc=; b=bE2Pz6ery4hY5QyjtcfjvN
        huIfH8q5DJIENesyLTX1I/NOK1xrZQH4ow2H9cg6dOus0n70pm62e0Dt1OWBDDT7
        ZjUaYxbJPAgJ640N0x0vkDMDuV95tpNuClc++xuErSFlOVMhV8Dztxbzqymxumzf
        0Xi/JNyCeRKcQcZq2HQp7w2bBW1RjUqXvTmEPPeg3AZ3pNlEKSlVJBn0Riras/Lh
        o7vmP5doRdzg6ttXv7C6852aOdp8fZhm/m1H6nSYn96UvOAzOy4+c7bqzJyBGB/K
        7aU0cXRf87xt8nJQz+kmYIuAWs96XZZYUa/yhm/tmvii3ETpFjxHdq87S5bBf28w
        ==
X-ME-Sender: <xms:peKBXvkvvOpVHZLjnMeXBBrZt5WE25OerzXlbh5h1fMyKIzu_1v7wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:peKBXq_0xFe5bXLetNalZZfmcWWz4CxueH4fHVh_mzRHOQyhAV9pGw>
    <xmx:peKBXlJ2nm_OTBDHCvqH0jGj5o-5_pGR2BUWB2x2ltxYzfdD4s0GrA>
    <xmx:peKBXniLyGYrmYBPCwf-gjMzqT_5QJgVEGlBec8-OiDdc-y9WbPA2Q>
    <xmx:peKBXrWfBu3473jAdyUQDp3Xfkc1Dr46hBMJuwxi8iU9esqTVlc3FA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B809C3280065;
        Mon, 30 Mar 2020 08:14:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] clocksource/drivers/hyper-v: Make sched clock return" failed to apply to 5.4-stable tree
To:     yuboxie@microsoft.com, Tianyu.Lan@microsoft.com,
        tglx@linutronix.de, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 14:14:18 +0200
Message-ID: <158557045812216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 749da8ca978f19710aba496208c480ad42d37f79 Mon Sep 17 00:00:00 2001
From: Yubo Xie <yuboxie@microsoft.com>
Date: Thu, 26 Mar 2020 19:11:59 -0700
Subject: [PATCH] clocksource/drivers/hyper-v: Make sched clock return
 nanoseconds correctly

The sched clock read functions return the HV clock (100ns granularity)
without converting it to nanoseconds.

Add the missing conversion.

Fixes: bd00cd52d5be ("clocksource/drivers/hyperv: Add Hyper-V specific sched clock function")
Signed-off-by: Yubo Xie <yuboxie@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200327021159.31429-1-Tianyu.Lan@microsoft.com

diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index 9d808d595ca8..eb0ba7818eb0 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -343,7 +343,8 @@ static u64 notrace read_hv_clock_tsc_cs(struct clocksource *arg)
 
 static u64 read_hv_sched_clock_tsc(void)
 {
-	return read_hv_clock_tsc() - hv_sched_clock_offset;
+	return (read_hv_clock_tsc() - hv_sched_clock_offset) *
+		(NSEC_PER_SEC / HV_CLOCK_HZ);
 }
 
 static void suspend_hv_clock_tsc(struct clocksource *arg)
@@ -398,7 +399,8 @@ static u64 notrace read_hv_clock_msr_cs(struct clocksource *arg)
 
 static u64 read_hv_sched_clock_msr(void)
 {
-	return read_hv_clock_msr() - hv_sched_clock_offset;
+	return (read_hv_clock_msr() - hv_sched_clock_offset) *
+		(NSEC_PER_SEC / HV_CLOCK_HZ);
 }
 
 static struct clocksource hyperv_cs_msr = {

