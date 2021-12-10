Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1459846FB96
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 08:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhLJHeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 02:34:44 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:60637 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230506AbhLJHeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 02:34:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V-80-gZ_1639121467;
Received: from 30.226.12.31(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-80-gZ_1639121467)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Dec 2021 15:31:07 +0800
Subject: Re: [PATCH v2 2/2] io_uring: ensure task_work gets run as part of
 cancelations
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com,
        stable@vger.kernel.org
References: <20211209155956.383317-1-axboe@kernel.dk>
 <20211209155956.383317-3-axboe@kernel.dk>
 <89990fca-63d3-cbac-85cc-bce2818dd30e@kernel.dk>
 <227847a6-a76c-3942-a563-7d492b0d2ced@linux.alibaba.com>
 <bfd55851-62d8-c9ea-bc49-c94efd40b38a@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <281d4248-676e-efc5-d95a-d848cbf0df41@linux.alibaba.com>
Date:   Fri, 10 Dec 2021 15:31:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <bfd55851-62d8-c9ea-bc49-c94efd40b38a@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2021/12/10 下午12:22, Jens Axboe 写道:
> On 12/9/21 8:29 PM, Hao Xu wrote:
>> 在 2021/12/10 上午12:16, Jens Axboe 写道:
>>> If we successfully cancel a work item but that work item needs to be
>>> processed through task_work, then we can be sleeping uninterruptibly
>>> in io_uring_cancel_generic() and never process it. Hence we don't
>>> make forward progress and we end up with an uninterruptible sleep
>>> warning.
>>>
>>> Add the waitqueue earlier to ensure that any wakeups from cancelations
>>> are seen, and switch to using uninterruptible sleep so that postponed
>> ^ typo
> Not really a typo, but should be killed from v2 for sure. I'll do that.
>
Don't know why the ^ char doesn't align with 'uninterruptible' ... here 
I mean 'uninterruptible' is a typo
