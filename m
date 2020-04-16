Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B0C1AC8FC
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405041AbgDPPRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2636304AbgDPNsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:48:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1C31208E4;
        Thu, 16 Apr 2020 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044926;
        bh=NzVsl77g47J5ch7O3/qgCHAedtZoN5S+VS8l9N5SDAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ot2RsA4DuCX9K0qVGJoAlME95UP5Kda1lU1TGxydofHdrGplMNZZ6O3R1K4Qn1kc3
         KnZG43erD2IYFxTJ6RfAph7stkHuP9RCFTRxAjCbflfOLc2sLY49j5t7h/9T6+l91N
         n0tK6bAWXZxyT9zPkwyWeq63gP5ZmnzSwlBklzjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Wood <swood@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 158/232] sched/core: Remove duplicate assignment in sched_tick_remote()
Date:   Thu, 16 Apr 2020 15:24:12 +0200
Message-Id: <20200416131334.775155848@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Wood <swood@redhat.com>

commit 82e0516ce3a147365a5dd2a9bedd5ba43a18663d upstream.

A redundant "curr = rq->curr" was added; remove it.

Fixes: ebc0f83c78a2 ("timers/nohz: Update NOHZ load in remote tick")
Signed-off-by: Scott Wood <swood@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/1580776558-12882-1-git-send-email-swood@redhat.com
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3676,7 +3676,6 @@ static void sched_tick_remote(struct wor
 	if (cpu_is_offline(cpu))
 		goto out_unlock;
 
-	curr = rq->curr;
 	update_rq_clock(rq);
 
 	if (!is_idle_task(curr)) {


