Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F57559449F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350024AbiHOWi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350947AbiHOWhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:37:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B8A3DBFB;
        Mon, 15 Aug 2022 12:50:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E13B0B81141;
        Mon, 15 Aug 2022 19:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E5AC433D6;
        Mon, 15 Aug 2022 19:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592990;
        bh=qD8iqtAHW8h3e52RnPcjZiRtkyWciAJc3DN0Ssk+n1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l74jWvECMZfz04E+EVUPyWuipKmtOqT/HKBqzrr2FLRjRYjq5E+piaja+mZGdBM0+
         smEXcW0bKN64NR9byPJafMKTEbkZfrwfrgZjDA8sOmRC0Z1cGyFdZMOMvmbm2rcn79
         Uu3RubiD9y0QQyOYbGpZbTIDeSVrsm2qXrICj3GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Goncalves <bgoncalv@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Valentin Schneider <vschneid@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0197/1157] wait: Fix __wait_event_hrtimeout for RT/DL tasks
Date:   Mon, 15 Aug 2022 19:52:33 +0200
Message-Id: <20220815180447.591910749@linuxfoundation.org>
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

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit cceeeb6a6d02e7b9a74ddd27a3225013b34174aa ]

Changes to hrtimer mode (potentially made by __hrtimer_init_sleeper on
PREEMPT_RT) are not visible to hrtimer_start_range_ns, thus not
accounted for by hrtimer_start_expires call paths. In particular,
__wait_event_hrtimeout suffers from this problem as we have, for
example:

fs/aio.c::read_events
  wait_event_interruptible_hrtimeout
    __wait_event_hrtimeout
      hrtimer_init_sleeper_on_stack <- this might "mode |= HRTIMER_MODE_HARD"
                                       on RT if task runs at RT/DL priority
        hrtimer_start_range_ns
          WARN_ON_ONCE(!(mode & HRTIMER_MODE_HARD) ^ !timer->is_hard)
          fires since the latter doesn't see the change of mode done by
          init_sleeper

Fix it by making __wait_event_hrtimeout call hrtimer_sleeper_start_expires,
which is aware of the special RT/DL case, instead of hrtimer_start_range_ns.

Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Link: https://lore.kernel.org/r/20220627095051.42470-1-juri.lelli@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/wait.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 851e07da2583..58cfbf81447c 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -544,10 +544,11 @@ do {										\
 										\
 	hrtimer_init_sleeper_on_stack(&__t, CLOCK_MONOTONIC,			\
 				      HRTIMER_MODE_REL);			\
-	if ((timeout) != KTIME_MAX)						\
-		hrtimer_start_range_ns(&__t.timer, timeout,			\
-				       current->timer_slack_ns,			\
-				       HRTIMER_MODE_REL);			\
+	if ((timeout) != KTIME_MAX) {						\
+		hrtimer_set_expires_range_ns(&__t.timer, timeout,		\
+					current->timer_slack_ns);		\
+		hrtimer_sleeper_start_expires(&__t, HRTIMER_MODE_REL);		\
+	}									\
 										\
 	__ret = ___wait_event(wq_head, condition, state, 0, 0,			\
 		if (!__t.task) {						\
-- 
2.35.1



