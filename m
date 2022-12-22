Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB226546C0
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 20:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbiLVTfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 14:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235694AbiLVTf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 14:35:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14B331DE2;
        Thu, 22 Dec 2022 11:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5WVxTcB+b0StMIPAz0QjpKHV+SYjjUj1ByXRlgq48cY=; b=D/2QgDTqN5q+6D6m7bJ0lSwAUe
        SD0RApHTIISjYZPTSdXkc7A5EWB7J+30m4hm7SaFhOPZkN1jAEngUm6RhweCn/n404JkeKyG3xFO7
        StvS82M+QMsmSwtqdrQ/Ukq99Gm/R+RPKEt9wjLx9ElT+r+r+thpMzcw34E2wnaKC1Lx7Spg3AaPi
        NInmN9Hqayfz1jzu+LjyZXjQTqmzlJDnzsKv218d+KoM6lS8YBNSRFPo6pPWcIGl8mv7w5t6PqE2y
        wqnRTUog0sB+HZHqsn5Moq2ENr1nASar1kGd4BM39YoRRS6Qpg4qsd+btXwSrwmmH37WYjQE/pkqJ
        zTIgWJww==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p8RKk-003tbf-HP; Thu, 22 Dec 2022 19:34:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7017D300322;
        Thu, 22 Dec 2022 20:34:15 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5768820165191; Thu, 22 Dec 2022 20:34:15 +0100 (CET)
Date:   Thu, 22 Dec 2022 20:34:15 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Waiman Long <longman@redhat.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Phil Auld <pauld@redhat.com>,
        Wenjie Li <wenjieli@qti.qualcomm.com>,
        David Wang =?utf-8?B?546L5qCH?= <wangbiao3@xiaomi.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH-tip v2] sched: Fix use-after-free bug in
 dup_user_cpus_ptr()
Message-ID: <Y6SxNwUn7/4/8IQa@hirez.programming.kicks-ass.net>
References: <20221205164832.2151247-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205164832.2151247-1-longman@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 11:48:32AM -0500, Waiman Long wrote:
> Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
> restricted on asymmetric systems"), the setting and clearing of
> user_cpus_ptr are done under pi_lock for arm64 architecture. However,
> dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
> protection. When racing with the clearing of user_cpus_ptr in
> __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
> double-free in arm64 kernel.

How? the task cannot be in migrate_enable() and fork() at the same time,
no?
