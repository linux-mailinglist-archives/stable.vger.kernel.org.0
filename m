Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66CFF9FEF
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKMBNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:13:07 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:53604 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726979AbfKMBNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:13:07 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4192FDD1EFD836803095;
        Wed, 13 Nov 2019 09:13:05 +0800 (CST)
Received: from [127.0.0.1] (10.133.217.137) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 13 Nov 2019
 09:12:57 +0800
Subject: Re: [PATCH stable 4.4] tracing: Have trace_buffer_unlock_commit()
 call the _regs version with NULL
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wangkefeng wang <wangkefeng.wang@huawei.com>
References: <20191112061850.71600-1-wangkefeng.wang@huawei.com>
 <20191112093010.380d3f3e@gandalf.local.home>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <c099742a-5927-e3f5-e862-0bfd154fbdd4@huawei.com>
Date:   Wed, 13 Nov 2019 09:12:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191112093010.380d3f3e@gandalf.local.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.217.137]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/11/12 22:30, Steven Rostedt wrote:
> On Tue, 12 Nov 2019 14:18:50 +0800
> Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>>
>> Commit 33fddff24d05d71f97722cb7deec4964d39d10dc upstream
>>
>> There's no real difference between trace_buffer_unlock_commit() and
>> trace_buffer_unlock_commit_regs() except that the former passes NULL to
>> ftrace_stack_trace() instead of regs. Have the former be a static inline of
>> the latter which passes NULL for regs.
>>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> [backport: modify trace_buffer_unlock_commit() in include/linux/trace_events.h]
>> Fixes: c5e0535fe67b ("tracing: Skip more functions when doing stack tracing of events")
          ^^^^^^^^^^^^
should be 70b3d6c5aa71 in v4.4.x, I will resend a new one if no objection.


>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
> 
> I'm not against this backport, but I'd like to know more why you feel
> this is a stable fix. Just to get a better backtrace? Can you show some
> examples of the issue you have and how this fixes it?

PATCH1: "tracing: Skip more functions when doing stack tracing of events" from v4.8-rc1~111^2~9
PATCH2: "tracing: Have trace_buffer_unlock_commit() call the _regs version with NULL" from tags/v4.7-rc1~72^2~8
PATCH1 is after PATCH2, the "skip" of ftrace_trace_stack() called by trace_buffer_unlock_commit_regs()
and trace_buffer_unlock_commit() is all changed. but we only have PATCH1 in 4.4.x, I found this when
using stacktrace on arm64,

cd /sys/kernel/debug/tracing
echo 1 > options/stacktrace
echo 1 > events/kmem/mm_page_alloc/enable
cat trace

before
---

              sh-781   [004] ...1    31.300106: mm_page_alloc: page=ffffffbdc0246380 pfn=299406 order=0 migratetype=1 gfp_flags=GFP_HIGHUSER_MOVABLE
              sh-781   [004] ...1    31.301373: <stack trace>
 => do_page_fault
 => do_translation_fault
 => do_mem_abort
 => el0_da
              sh-781   [004] ...1    31.303494: mm_page_alloc: page=ffffffbdc021cf00 pfn=296764 order=2 migratetype=0 gfp_flags=GFP_USER|GFP_ZERO|GFP_NOTRACK
              sh-781   [004] ...1    31.303508: <stack trace>
 => copy_process.isra.8
 => _do_fork
 => SyS_clone
 => el0_svc_naked
              sh-781   [004] ...1    31.303975: mm_page_alloc: page=ffffffbdc021cd40 pfn=296757 order=0 migratetype=0 gfp_flags=GFP_USER|GFP_REPEAT|GFP_ZERO|GFP_NOTRACK
              sh-781   [004] ...1    31.303987: <stack trace>
 => pgd_alloc
 => mm_init.isra.4
 => copy_process.isra.8
 => _do_fork
 => SyS_clone
 => el0_svc_naked
after
---
            sh-780   [002] ...1    14.728783: mm_page_alloc: page=ffffffbdc2e86200 pfn=1024392 order=0 migratetype=1 gfp_flags=GFP_HIGHUSER_MOVABLE
              sh-780   [002] ...1    14.729985: <stack trace>
 => __alloc_pages_nodemask
 => handle_mm_fault
 => do_page_fault
 => do_translation_fault
 => do_mem_abort
 => el0_da
              sh-780   [002] ...1    14.731854: mm_page_alloc: page=ffffffbdc021dc00 pfn=296816 order=2 migratetype=0 gfp_flags=GFP_USER|GFP_ZERO|GFP_NOTRACK
              sh-780   [002] ...1    14.731867: <stack trace>
 => __alloc_pages_nodemask
 => alloc_kmem_pages_node
 => copy_process.isra.8
 => _do_fork
 => SyS_clone
 => el0_svc_naked
              sh-780   [002] ...1    14.732069: mm_page_alloc: page=ffffffbdc021d600 pfn=296792 order=0 migratetype=0 gfp_flags=GFP_USER|GFP_REPEAT|GFP_ZERO|GFP_NOTRACK
              sh-780   [002] ...1    14.732079: <stack trace>
 => __alloc_pages_nodemask
 => __get_free_pages
 => pgd_alloc
 => mm_init.isra.4
 => copy_process.isra.8
 => _do_fork
 => SyS_clone
 => el0_svc_naked



> 
> Thanks!
> 
> -- Steve
> 
> .
> 

