Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F4658C016
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243065AbiHHBr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243362AbiHHBqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:46:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17BCCE0B;
        Sun,  7 Aug 2022 18:36:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E564B80E13;
        Mon,  8 Aug 2022 01:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B5DC433B5;
        Mon,  8 Aug 2022 01:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922609;
        bh=fIyATlflZQYS902OJM0Ronnev54d2XGnLkNgc18G4cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1j+7QwvPOVj0jgP2aZ+C6x7txM8pDw08Vvu6ITFVxSEyATklAJryEqUzjX72j/lF
         hzfbBUk/yW5uZYrSELXPwBlqIHKmsoyXqsVEuFBTtpI81GuY7A+neGtbRqtHYs2rVl
         P6qj4p8OUVEvLA4PKCa/b0w2b72Ex0x8JkfLxycTLx13u9HxfmvPnsfxoVKL38fFXB
         jleDduCDn5msv7o3sNL2pyyWWaRI10IV1Aik1YuFsYMLMohGvZHcKy6RIctu7fLbdT
         bqSAJ+70GrhZw+e7RHrOjTy3fZ/8mB4uYsLSrMz24lIQQu3M8UzdM0dEJqBHOJqfRr
         li9XVTUbYunGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Valentin Schneider <vschneid@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        peterz@infradead.org, vincent.guittot@linaro.org
Subject: [PATCH AUTOSEL 5.15 17/45] wait: Fix __wait_event_hrtimeout for RT/DL tasks
Date:   Sun,  7 Aug 2022 21:35:21 -0400
Message-Id: <20220808013551.315446-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013551.315446-1-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d22cf2985b8f..21044562aab7 100644
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

