Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE33595A21
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiHPLas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiHPLaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:30:01 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD2F12080;
        Tue, 16 Aug 2022 03:47:39 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M6SRf31mKzXdRB;
        Tue, 16 Aug 2022 18:43:26 +0800 (CST)
Received: from huawei.com (10.67.174.191) by canpemm500009.china.huawei.com
 (7.192.105.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 16 Aug
 2022 18:47:37 +0800
From:   Li Hua <hucool.lihua@huawei.com>
To:     <peterz@infradead.org>
CC:     <bristot@redhat.com>, <bsegall@google.com>,
        <dietmar.eggemann@arm.com>, <hucool.lihua@huawei.com>,
        <juri.lelli@redhat.com>, <linux-kernel@vger.kernel.org>,
        <mgorman@suse.de>, <mingo@redhat.com>, <rostedt@goodmis.org>,
        <stable@vger.kernel.org>, <vincent.guittot@linaro.org>,
        <vschneid@redhat.com>
Subject: Re: [PATCH -next] sched/cputime: Fix the bug of reading time backward from /proc/stat
Date:   Wed, 17 Aug 2022 08:44:45 +0800
Message-ID: <20220817004445.43216-1-hucool.lihua@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <YvoAk1pnU4gZcFJ1@worktop.programming.kicks-ass.net>
References: <YvoAk1pnU4gZcFJ1@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.191]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's unreadable, I'm sorry about that.

The CPU statistics time read from /proc/stat should only be incremented. The bug
I found is that the value read latest is smaller than the former.

The root cause of the problem is that the "vtime->utime" and "delta" are temporarily
added to the stack and show to the user. The value of 'vtime->utime + delta' depends
on which task the CPU is executing. As bellow:
show_stat -> kcpustat_cpu_fetch -> kcpustat_cpu_fetch_vtime -> cpustat[CPUTIME_USER] += vtime->utime + delta
