Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DC65415FC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376410AbiFGUnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376930AbiFGUks (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:40:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0315C1EE6FA;
        Tue,  7 Jun 2022 11:38:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 816D1B8233E;
        Tue,  7 Jun 2022 18:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2769C385A2;
        Tue,  7 Jun 2022 18:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627108;
        bh=qgIarFfVi30ywsrZa61GfYB3RcK1JjLpu8nUPCGSHOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEwliN9hiDgfHoWfJPuQZNdPVDoxuUzbyHcioYj7sxOfPVrNSZJR7z+LxB/+4xyhv
         FX7UzIfGw2n1uBHqCidtBs6IRxLto933vYBCNHo5eadArCKHEPssVS05wIWIfE6YeO
         xzKKsUkySDBt22lNKZZmPVsrO37namT9f0JQl60o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 603/772] tracing/timerlat: Notify IRQ new max latency only if stop tracing is set
Date:   Tue,  7 Jun 2022 19:03:15 +0200
Message-Id: <20220607165006.709755739@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit aa748949b4e665f473bc5abdc5f66029cb5f5522 ]

Currently, the notification of a new max latency is sent from
timerlat's IRQ handler anytime a new max latency is found.

While this behavior is not wrong, the send IPI overhead itself
will increase the thread latency and that is not the desired
effect (tracing overhead).

Moreover, the thread will notify a new max latency again because
the thread latency as it is always higher than the IRQ latency
that woke it up.

The only case in which it is helpful to notify a new max latency
from IRQ is when stop tracing (for the IRQ) is set, as in this
case, the thread will not be dispatched.

Notify a new max latency from the IRQ handler only if stop tracing is
set for the IRQ handler.

Link: https://lkml.kernel.org/r/2c2d9a56c0886c8402ba320de32856cbbb10c2bb.1652175637.git.bristot@kernel.org

Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Reported-by: Clark Williams <williams@redhat.com>
Fixes: a955d7eac177 ("trace: Add timerlat tracer")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_osnoise.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 5e3c62a08fc0..61c3fff488bf 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1576,11 +1576,12 @@ static enum hrtimer_restart timerlat_irq(struct hrtimer *timer)
 
 	trace_timerlat_sample(&s);
 
-	notify_new_max_latency(diff);
-
-	if (osnoise_data.stop_tracing)
-		if (time_to_us(diff) >= osnoise_data.stop_tracing)
+	if (osnoise_data.stop_tracing) {
+		if (time_to_us(diff) >= osnoise_data.stop_tracing) {
 			osnoise_stop_tracing();
+			notify_new_max_latency(diff);
+		}
+	}
 
 	wake_up_process(tlat->kthread);
 
-- 
2.35.1



