Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B9D3F3232
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 19:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbhHTR0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 13:26:06 -0400
Received: from mail.efficios.com ([167.114.26.124]:39608 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbhHTR0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 13:26:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 2535A37E7BE;
        Fri, 20 Aug 2021 13:25:27 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 4f9oN96_Tncg; Fri, 20 Aug 2021 13:25:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id B4EE437E47A;
        Fri, 20 Aug 2021 13:25:22 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com B4EE437E47A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1629480322;
        bh=f0vUlUd/VO5b3+MsSLcR1hbgTNkXeg5qd2QXkDjrv4g=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=YTNoOU6kIBCBcx74M0gIx0/1BnehnhQguEpmV3e5v6rAkop/MoYrxFII54adTbwJW
         x6nDROO5oVCpu22zbcksiu/zHGnZEdbBu6E+e0vcZz9AtCWRlbxvcAua7HJtIntg4i
         YhPDY5kUPtGAo0RcGdsOJzvgkkOJx8JSYsPENSsV1sEY+8zGhc5VlJcDbJ67LDop8O
         XNYacB9AgehGL+8dQfGDtTjGHkDb2rs2zANn84KMEpoeu9pvefT1FdMeoxih0d5JaG
         IzHmCKyKJj7/84bripi9VAjyNy3341MgBeeJIoKf3XiaORrLbfUYjFlxJXk3dcEQ/y
         4LU+v3FqKuizg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vvwh7blkFlez; Fri, 20 Aug 2021 13:25:22 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id A49B537E64A;
        Fri, 20 Aug 2021 13:25:22 -0400 (EDT)
Date:   Fri, 20 Aug 2021 13:25:22 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        paulmck <paulmck@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Message-ID: <1591741552.20153.1629480322520.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210819204204.00f9ad28@rorschach.local.home>
References: <1628500832155134@kroah.com> <20210819170933.5c4c6a38@oasis.local.home> <20210819204204.00f9ad28@rorschach.local.home>
Subject: Re: FAILED: patch "[PATCH] tracepoint: Use rcu get state and cond
 sync for static call" failed to apply to 5.10-stable tree
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4101 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4059)
Thread-Topic: FAILED: patch "[PATCH] tracepoint: Use rcu get state and cond sync for static call" failed to apply to 5.10-stable tree
Thread-Index: +QopAfEfAPlEh5ZqHnBT7F1ViwKwrg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Aug 19, 2021, at 8:42 PM, rostedt rostedt@goodmis.org wrote:

> On Thu, 19 Aug 2021 17:09:33 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> Mathieu, seems that the "slow down 10x" patch was able to be backported
>> to 5.10, where as this patch was not. Reason being is that
>> start_poll_synchronize_rcu() was added in 5.13.
> 
> I can get this to work if I backport the following RCU patches:
> 
> 29d2bb94a8a126ce80ffbb433b648b32fdea524e
> srcu: Provide internal interface to start a Tree SRCU grace period
> 
> 5358c9fa54b09b5d3d7811b033aa0838c1bbaaf2
> srcu: Provide polling interfaces for Tree SRCU grace periods
> 
> 1a893c711a600ab57526619b56e6f6b7be00956e
> srcu: Provide internal interface to start a Tiny SRCU grace period
> 
> 8b5bd67cf6422b63ee100d76d8de8960ca2df7f0
> srcu: Provide polling interfaces for Tiny SRCU grace periods
> 
> The first three can be cherry-picked without issue. The last one has a
> small conflict, of:
> 
> include/linux/srcutiny.h.rej:
> --- include/linux/srcutiny.h
> +++ include/linux/srcutiny.h
> @@ -16,6 +16,7 @@
> struct srcu_struct {
>        short srcu_lock_nesting[2];     /* srcu_read_lock() nesting depth. */
>        unsigned short srcu_idx;        /* Current reader array element in bit 0x2. */
> +       unsigned short srcu_idx_max;    /* Furthest future srcu_idx request. */
>        u8 srcu_gp_running;             /* GP workqueue running? */
>        u8 srcu_gp_waiting;             /* GP waiting for readers? */
>        struct swait_queue_head srcu_wq;
> 
> 
> Which I just added that line, and everything worked.
> 
> Paul, do you have any issues with these four patches getting backported?
> 
> Greg, Are you OK with them too?
> 
> Once those are backported, this patch can be backported as well, and
> everything should work. This patch really needs to stay with:
> 
> 231264d6927f6740af36855a622d0e240be9d94c
> tracepoint: Fix static call function vs data state mismatch
> 
> Otherwise I would say to revert it if this one can't be backported with
> it.

In my opinion backporting those patches to stable is important, because the tracepoint
fix which causes the slowdown is really fixing a correctness issue: it ensures that the
kernel does not crash in specific race scenarios.

Indeed the slowdown associated with that patch is quite big on typical use-cases of
tracepoint registration/unregistration, so the second fixing the speed regression is
also important, and that last fix requires the SRCU backports.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
