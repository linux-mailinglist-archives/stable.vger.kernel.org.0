Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869B3197B9A
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 14:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgC3MOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 08:14:21 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57571 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729996AbgC3MOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 08:14:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AC41B5C059E;
        Mon, 30 Mar 2020 08:14:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 30 Mar 2020 08:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6FIrDe
        XqPqcGvjpqnv3q3QKLpvV0GVw5LFfdAZUPesQ=; b=QbP9721sbEYeNlT1E7tvgd
        HVln0d7cQJdW4njucEcfEdQ5gV/upaqwA5V6Cykgh+ukulX0PixXYiWl3GgPWyjD
        4sXPw3A/SnrV2QHdWiWezV3DuFAPi2KG1zjGk8OS70MOtWWY82QQrZ9jV2gQPK1a
        GQ8kxEBmXdby19HY/5I30C7tW44js7VcNxhQpN7VYyLSgrQzsez0C7oacgZRpuWM
        znK/lNYSFdGLQDQj290IUqerCfoZ76Ii1Hgej8Kbw1wApSI8/dAnHW/cwOkCgrbB
        8Ry2jUB0znO6AS6+rfPYbqUE0ZF9vETCMPou85fP9lCYXEMOP4URYbMnXPIpLA3A
        ==
X-ME-Sender: <xms:nOKBXl7KO5Aa2Zvmq8cap6cnt9B3VAoiSA1T_tBrueFgP40na9fgag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:nOKBXsaAXm9f0MoajR4us3Wumuc1Jb_z2EEkANQad3d_L1M2vNhISg>
    <xmx:nOKBXgvlKfCQoIjhAFU5Uk9U9iwaxTtvuyhKp6TVn3Dg65eyw7DS2Q>
    <xmx:nOKBXluyPwTviQ_krApMycybzLMI-Jq4m5moBLsYJBXNkG97O3B-8A>
    <xmx:nOKBXjD_luolwEsisr5y_oLaOtWJRaQQuycSZHh3rCXp6XY8pcevgA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 024F2306C9BE;
        Mon, 30 Mar 2020 08:14:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] clocksource/drivers/hyper-v: Make sched clock return" failed to apply to 5.5-stable tree
To:     yuboxie@microsoft.com, Tianyu.Lan@microsoft.com,
        tglx@linutronix.de, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 14:14:18 +0200
Message-ID: <158557045893151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
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

