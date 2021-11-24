Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1444945B99E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241930AbhKXMDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:03:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:58388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241880AbhKXMD0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:03:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E41E600EF;
        Wed, 24 Nov 2021 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755217;
        bh=CSnFPTXe4NL97Uz+GIvfszQ2cxP8rajF35gfNCvRN+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6wa1Itgmz0JfPwJr6JsuYGgl8IWtQqaMqs9qHmt0PdqjQG7U1XqCBq3tr43UJ5Qp
         HV20RLXZCnJhvOB8aUP4kZ5hOAtD5B0z3shVrbuCyMcYZC+QYt2/ewmwnJkUqSOi0h
         w2ZJLSb001Rev+SbA4/qAILraX4iNkCBwtporpz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Wensheng <wangwensheng4@huawei.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 015/162] ALSA: timer: Fix use-after-free problem
Date:   Wed, 24 Nov 2021 12:55:18 +0100
Message-Id: <20211124115658.819548980@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Wensheng <wangwensheng4@huawei.com>

commit c0317c0e87094f5b5782b6fdef5ae0a4b150496c upstream.

When the timer instance was add into ack_list but was not currently in
process, the user could stop it via snd_timer_stop1() without delete it
from the ack_list. Then the user could free the timer instance and when
it was actually processed UAF occurred.

This issue could be reproduced via testcase snd_timer01 in ltp - running
several instances of that testcase at the same time.

What I actually met was that the ack_list of the timer broken and the
kernel went into deadloop with irqoff. That could be detected by
hardlockup detector on board or when we run it on qemu, we could use gdb
to dump the ack_list when the console has no response.

To fix this issue, we delete the timer instance from ack_list and
active_list unconditionally in snd_timer_stop1().

Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211103033517.80531-1-wangwensheng4@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -525,13 +525,13 @@ static int snd_timer_stop1(struct snd_ti
 	if (!timer)
 		return -EINVAL;
 	spin_lock_irqsave(&timer->lock, flags);
+	list_del_init(&timeri->ack_list);
+	list_del_init(&timeri->active_list);
 	if (!(timeri->flags & (SNDRV_TIMER_IFLG_RUNNING |
 			       SNDRV_TIMER_IFLG_START))) {
 		result = -EBUSY;
 		goto unlock;
 	}
-	list_del_init(&timeri->ack_list);
-	list_del_init(&timeri->active_list);
 	if (timer->card && timer->card->shutdown)
 		goto unlock;
 	if (stop) {


