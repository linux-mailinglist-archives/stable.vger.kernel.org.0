Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09813CD41E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 13:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhGSLJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 07:09:30 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:11344 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhGSLJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 07:09:30 -0400
Received: from dggeme703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GT0Qk0cnTz7tG1;
        Mon, 19 Jul 2021 19:45:34 +0800 (CST)
Received: from [10.174.177.180] (10.174.177.180) by
 dggeme703-chm.china.huawei.com (10.1.199.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 19 Jul 2021 19:50:07 +0800
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
To:     Matthew Wilcox <willy@infradead.org>
CC:     Boqun Feng <boqun.feng@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, <paulmck@kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "Huang, Ying" <ying.huang@intel.com>, <gregkh@linuxfoundation.org>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name> <6698965.kvI7vG0SvZ@natalenko.name>
 <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1>
 <YPSweHyCrD2q2Pue@casper.infradead.org>
 <20210719015313.GS4397@paulmck-ThinkPad-P17-Gen-1>
 <CAABZP2yE+3vzd+LgJDJcJ2f8qttJQSUQ6efD9MaFd2iD4xPTZA@mail.gmail.com>
 <YPTmtNMJpykEpzx6@casper.infradead.org> <YPVQfaamqwu1PRrK@boqun-archlinux>
 <08803f78-3e99-6b3f-e809-5828fe47cf06@huawei.com>
 <YPVgaY6uw59Fqg5x@casper.infradead.org>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <8058e175-cec5-c243-6499-c1cd4e3c8605@huawei.com>
Date:   Mon, 19 Jul 2021 19:50:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YPVgaY6uw59Fqg5x@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.180]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme703-chm.china.huawei.com (10.1.199.99)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/7/19 19:22, Matthew Wilcox wrote:
> On Mon, Jul 19, 2021 at 07:12:58PM +0800, Miaohe Lin wrote:
>> When in the commit 2799e77529c2a, we're using the percpu_ref to serialize against
>> concurrent swapoff, i.e. there's percpu_ref inside get_swap_device() instead of
>> rcu_read_lock(). Please see commit 63d8620ecf93 ("mm/swapfile: use percpu_ref to
>> serialize against concurrent swapoff") for detail.
> 
> Oh, so this is a backport problem.  2799e77529c2 was backported without
> its prerequisite 63d8620ecf93.  Greg, probably best to just drop

Yes, they're posted as a patch set:

https://lkml.kernel.org/r/20210426123316.806267-1-linmiaohe@huawei.com

> 2799e77529c2 from all stable trees; the race described is not very
> important (swapoff vs reading a page back from that swap device).
> .
> 

The swapoff races with reading a page back from that swap device should be really
uncommon as most users only do swapoff when the system is going to shutdown.

Sorry for the trouble!
