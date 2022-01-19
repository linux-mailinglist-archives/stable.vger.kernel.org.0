Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E070493758
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 10:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbiASJcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 04:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbiASJcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 04:32:32 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A2DC061574;
        Wed, 19 Jan 2022 01:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y8LC3526/NOrnrZyFGRxwpREBuQN7kB9aPXpSl2xqp4=; b=XgGAPCv92Hm4F7nWhu4k+sK6u5
        P/H+DUbzC1DugDqnAN/MySFch/GTyD07+hM7JAZRXRmp78jf9WeiQFISEGc582LNbd8laUizIONEb
        3TJmzae/14L2QOhdj9JvHW6FQTYtVTGqVFB+qbEjSsM2t905RL7GaNPvYSw38b+2mLfMVJla5buBJ
        Azms7XCgQD1jjyIDVuMPCWXSHyEMO6od8/ypRGUQrD3QRy7wWIozpgDDwzzGI1gmjyZhex8Z/AO0V
        fndt8mKkfAvZGFAOWE22qEbjrpjybxsmJo9Qoi5bwI+G0sUbZ8NQnPjYiVHfI7uhswaM6NBuvUCFt
        H7M+x1fQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nA7K3-0021Bn-Ov; Wed, 19 Jan 2022 09:32:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F008D300222;
        Wed, 19 Jan 2022 10:32:05 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D3336200CA459; Wed, 19 Jan 2022 10:32:05 +0100 (CET)
Date:   Wed, 19 Jan 2022 10:32:05 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     mingo@redhat.com, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/fair: Fix fault in reweight_entity
Message-ID: <YefalbN+ApgkQ6zn@hirez.programming.kicks-ass.net>
References: <20220119012417.299060-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119012417.299060-1-tadeusz.struk@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 05:24:17PM -0800, Tadeusz Struk wrote:
> Syzbot found a GPF in reweight_entity. This has been bisected to commit
> c85c6fadbef0 ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")

That's a stable commit, the real commit is 4ef0c5c6b5ba1f38f0ea1cedad0cad722f00c14a

> Looks like after this change there is a time window, when
> task_struct->se.cfs_rq can be NULL. This can be exploited to trigger
> null-ptr-deref by calling setpriority on that task.

Looks like isn't good enough, either there is, in which case you explain
the window, or there isn't in which case what are we doing here?

