Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BC868D878
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjBGNKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbjBGNJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DAA6A45
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:09:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE963B8198C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C868C433EF;
        Tue,  7 Feb 2023 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775367;
        bh=a+t01uMYyk2rCNGNkO2xxMKo9F9aNL/7zohUX9orGP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnK73375khEaW0duaoyUSV7m2ecjUtwGLX6NEX4LPrYveiwzzgl1SuGf91SbNHKnj
         wAKfkryBwMTS3BkbsWR2kSNgIBw6+r9yM5R7J76d+7OtVdeiZN6G3mEcOKWb877dsX
         bgPeF+Oue5xYZfk+zpJXxLWrvhCCZUv5w1TNN2/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hao Sun <sunhao.th@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/120] bpf: Fix a possible task gone issue with bpf_send_signal[_thread]() helpers
Date:   Tue,  7 Feb 2023 13:56:20 +0100
Message-Id: <20230207125619.165093678@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit bdb7fdb0aca8b96cef9995d3a57e251c2289322f ]

In current bpf_send_signal() and bpf_send_signal_thread() helper
implementation, irq_work is used to handle nmi context. Hao Sun
reported in [1] that the current task at the entry of the helper
might be gone during irq_work callback processing. To fix the issue,
a reference is acquired for the current task before enqueuing into
the irq_work so that the queued task is still available during
irq_work callback processing.

  [1] https://lore.kernel.org/bpf/20230109074425.12556-1-sunhao.th@gmail.com/

Fixes: 8b401f9ed244 ("bpf: implement bpf_send_signal() helper")
Tested-by: Hao Sun <sunhao.th@gmail.com>
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20230118204815.3331855-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 4daf1e044556..b314e71a008c 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -776,6 +776,7 @@ static void do_bpf_send_signal(struct irq_work *entry)
 
 	work = container_of(entry, struct send_signal_irq_work, irq_work);
 	group_send_sig_info(work->sig, SEND_SIG_PRIV, work->task, work->type);
+	put_task_struct(work->task);
 }
 
 static int bpf_send_signal_common(u32 sig, enum pid_type type)
@@ -812,7 +813,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 		 * to the irq_work. The current task may change when queued
 		 * irq works get executed.
 		 */
-		work->task = current;
+		work->task = get_task_struct(current);
 		work->sig = sig;
 		work->type = type;
 		irq_work_queue(&work->irq_work);
-- 
2.39.0



