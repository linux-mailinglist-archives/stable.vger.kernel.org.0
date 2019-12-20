Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 695061283A4
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 22:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfLTVPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 16:15:02 -0500
Received: from mail.efficios.com ([167.114.142.138]:56748 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfLTVPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 16:15:02 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id EB2E1690318;
        Fri, 20 Dec 2019 16:15:00 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id AuZ_7fZyEPuh; Fri, 20 Dec 2019 16:15:00 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 75457690314;
        Fri, 20 Dec 2019 16:15:00 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 75457690314
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576876500;
        bh=DyLYgI0zjI8pT79Vk8bMwp6yN3rTY6yP7kkznA03AoE=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Sm6WcPq+rLA8zt4MYfb94nK3+RZLbBdghlOlN7MM6m1GFRdoTZMEGgaUZMycutm1M
         pc1an4l7K/7ZGFyA9niyKxs2SBZz8sv80cB0LR4w4VHk9H7kbCBvcx0b53KWPVwUeR
         j9j/d5gZ2/M4RtJH/LAg1ToVOIdka/7uzERnAMi38UnPgh3+ig+s34xfz5x84/ttir
         j5Kpf7pNXUtqcaxGAx3IMflFW+H5ciDD1t9MIqM2vJeOXwzl24xqFiX/wxyHZd6TKB
         XIQF9iISzPujP/Cdnn9O5ExaLzNFrwJTXPufzVSN1LzI1WBBcF2+baNK2BFVAyBxrZ
         adUpNqNuugJ1A==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id qLX3NVtIpGkE; Fri, 20 Dec 2019 16:15:00 -0500 (EST)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id 59E49690306;
        Fri, 20 Dec 2019 16:15:00 -0500 (EST)
Date:   Fri, 20 Dec 2019 16:15:00 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Neel Natu <neelnatu@google.com>
Message-ID: <669061171.14506.1576876500152.JavaMail.zimbra@efficios.com>
In-Reply-To: <875zian2a2.fsf@mid.deneb.enyo.de>
References: <20191220201207.17389-1-mathieu.desnoyers@efficios.com> <87imman36g.fsf@mid.deneb.enyo.de> <173832695.14381.1576875253374.JavaMail.zimbra@efficios.com> <875zian2a2.fsf@mid.deneb.enyo.de>
Subject: Re: [PATCH for 5.5 1/2] rseq: Fix: Clarify rseq.h UAPI rseq_cs
 memory reclaim requirements
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.15_GA_3888 (ZimbraWebClient - FF71 (Linux)/8.8.15_GA_3890)
Thread-Topic: rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
Thread-Index: lBXaukfByKp9TejsCTqcOtGiErTiYA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 20, 2019, at 3:57 PM, Florian Weimer fw@deneb.enyo.de wrote:

> * Mathieu Desnoyers:
>=20
>> ----- On Dec 20, 2019, at 3:37 PM, Florian Weimer fw@deneb.enyo.de wrote=
:
>>
>>> * Mathieu Desnoyers:
>>>=20
>>>> diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
>>>> index 9a402fdb60e9..6f26b0b148a6 100644
>>>> --- a/include/uapi/linux/rseq.h
>>>> +++ b/include/uapi/linux/rseq.h
>>>> @@ -100,7 +100,9 @@ struct rseq {
>>>>  =09 * instruction sequence block, as well as when the kernel detects =
that
>>>>  =09 * it is preempting or delivering a signal outside of the range
>>>>  =09 * targeted by the rseq_cs. Also needs to be set to NULL by user-s=
pace
>>>> -=09 * before reclaiming memory that contains the targeted struct rseq=
_cs.
>>>> +=09 * before reclaiming memory that contains the targeted struct rseq=
_cs
>>>> +=09 * or reclaiming memory that contains the code refered to by the
>>>> +=09 * start_ip and post_commit_offset fields of struct rseq_cs.
>>>=20
>>> Maybe mention that it's good practice to clear rseq_cs before
>>> returning from a function that contains a restartable sequence?
>>
>> Unfortunately, clearing it is not free. Considering that rseq is meant t=
o
>> be used in very hot code paths, it would be preferable that applications
>> clear it in the very infrequent case where the rseq_cs or code will
>> vanish (e.g. dlclose or JIT reclaim), and not require it to be cleared
>> after each critical section. I am therefore reluctant to document the
>> behavior you describe as a "good practice" for rseq.
>=20
> You already have to write to rseq_cs before entering the critical
> section, right?  Then you've already determined the address, and the
> cache line is already hot, so it really should be close to zero cost.

Considering that overall rseq executes in fraction of nanoseconds on
some architectures, adding an extra store is perhaps close to zero,
but still significantly degrades performance.

>=20
> I mean, you can still discard the advice, but you do so ad your own
> peril =E2=80=A6

I am also uncomfortable leaving this to the end user. One possibility
would be to extend rseq or membarrier to add a kind of "rseq-clear"
barrier, which would ensure that the kernel will have cleared the
rseq_cs field for each thread belonging to the current process. glibc
could then call this barrier before dlclose.

This is slightly different from another rseq-barrier that has been
requested by Paul Turner: a way to ensure that all previously
running rseq critical sections have completed or aborted.

AFAIU, the desiderata for each of the 2 use-cases is as follows:

rseq-barrier: guarantee that all prior rseq critical sections have
completed or aborted for the current process or for a set of registered
processes. Allows doing RCU-like algorithms within rseq critical sections.

rseq-clear: guarantee that the rseq_cs field is cleared for each thread
belonging to the current process before the barrier system call returns
to the caller. Aborts currently running rseq critical sections for all
threads belonging to the current process. The use-case is to allow
dlclose and JIT reclaim to clear any leftover reference to struct
rseq_cs or code which are going to be reclaimed.

Thoughts ?

Thanks,

Mathieu

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
