Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15215799F9
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbiGSMKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238493AbiGSMIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:08:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A263C50045;
        Tue, 19 Jul 2022 05:01:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2200A616FB;
        Tue, 19 Jul 2022 12:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C2AC341CA;
        Tue, 19 Jul 2022 12:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232112;
        bh=ma7NhXFgC+7hwyuEmkcP1+W4Jkc830HpQ+gJrpBWGww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDbFMGwbKqMmi+SVtySq6LrGW67wRT/k5qj/iumVfTkNV5tFRU+bIyXDKFgulOJqo
         Nlqpym5i3JRTFh4iH9qRY7VOcnDD4wTTFbqJTGzrW4FEwGpPE/TqeDvidaCTOFKLmt
         DnXJbN+KGx4zQaKMRulcyQi92rrb/UbsBhg8xYck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Wei Wang <wvw@google.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.4 17/71] sched/rt: Disable RT_RUNTIME_SHARE by default
Date:   Tue, 19 Jul 2022 13:53:40 +0200
Message-Id: <20220719114553.906618615@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@redhat.com>

commit 2586af1ac187f6b3a50930a4e33497074e81762d upstream.

The RT_RUNTIME_SHARE sched feature enables the sharing of rt_runtime
between CPUs, allowing a CPU to run a real-time task up to 100% of the
time while leaving more space for non-real-time tasks to run on the CPU
that lend rt_runtime.

The problem is that a CPU can easily borrow enough rt_runtime to allow
a spinning rt-task to run forever, starving per-cpu tasks like kworkers,
which are non-real-time by design.

This patch disables RT_RUNTIME_SHARE by default, avoiding this problem.
The feature will still be present for users that want to enable it,
though.

Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Wei Wang <wvw@google.com>
Link: https://lkml.kernel.org/r/b776ab46817e3db5d8ef79175fa0d71073c051c7.1600697903.git.bristot@redhat.com
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/features.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -77,7 +77,7 @@ SCHED_FEAT(WARN_DOUBLE_CLOCK, false)
 SCHED_FEAT(RT_PUSH_IPI, true)
 #endif
 
-SCHED_FEAT(RT_RUNTIME_SHARE, true)
+SCHED_FEAT(RT_RUNTIME_SHARE, false)
 SCHED_FEAT(LB_MIN, false)
 SCHED_FEAT(ATTACH_AGE_LOAD, true)
 


