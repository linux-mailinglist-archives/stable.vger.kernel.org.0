Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19676216AC6
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 12:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgGGKvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 06:51:46 -0400
Received: from mail.efficios.com ([167.114.26.124]:50334 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGGKvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 06:51:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 17D5725B0;
        Tue,  7 Jul 2020 06:51:45 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZPLoVSiFp3tp; Tue,  7 Jul 2020 06:51:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id CEC762900;
        Tue,  7 Jul 2020 06:51:44 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com CEC762900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1594119104;
        bh=65U6cZeoHJ0b5uwyqFXxHAmikJcNMvEpm9mPm7idWLY=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=fq9dqb9+7BWAfcO430hyxnqpMmln7WEUOJxaiSvhFT5vjgIiTRME3SMA89I0xOYBo
         3l1WfNUVziv3M7PJ0PAm2UrR8OZmYz7DFbZZlGKJJxTzA4xOOz33A46RlhPtK1L0/T
         KfwrtjK1g0e6aog9RyLPwa/SedSVpaVPEtl517OC9NHeIuLP/q3GP4SGMGq9Adw8ud
         pqrrVg2oIcUXwGmw5hQfZ5+KvK2CzhJI1XcTzju9gkXFCiJtdsDwZw/CYZ58fCN0dS
         74mk4Op2uv1LeFQGp4s6g1EQWjSQ6S83FO/6v9FjbMdnEUzJ6r1i5kckncUWvuH9Xa
         bS/VGsbxKiKXA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6rXMaviP4Q9e; Tue,  7 Jul 2020 06:51:44 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id BC4FD263A;
        Tue,  7 Jul 2020 06:51:44 -0400 (EDT)
Date:   Tue, 7 Jul 2020 06:51:44 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Neel Natu <neelnatu@google.com>,
        stable <stable@vger.kernel.org>
Message-ID: <1513249086.945.1594119104750.JavaMail.zimbra@efficios.com>
In-Reply-To: <87blkrzssa.fsf@mid.deneb.enyo.de>
References: <20200706204913.20347-1-mathieu.desnoyers@efficios.com> <20200706204913.20347-2-mathieu.desnoyers@efficios.com> <87blkrzssa.fsf@mid.deneb.enyo.de>
Subject: Re: [RFC PATCH for 5.8 1/4] sched: Fix unreliable rseq cpu_id for
 new tasks
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3955 (ZimbraWebClient - FF78 (Linux)/8.8.15_GA_3953)
Thread-Topic: sched: Fix unreliable rseq cpu_id for new tasks
Thread-Index: +EFr9o+gVaPjCkmbkUIMJ25jGoinrQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Jul 7, 2020, at 3:30 AM, Florian Weimer fw@deneb.enyo.de wrote:

> * Mathieu Desnoyers:
> 
>> While integrating rseq into glibc and replacing glibc's sched_getcpu
>> implementation with rseq, glibc's tests discovered an issue with
>> incorrect __rseq_abi.cpu_id field value right after the first time
>> a newly created process issues sched_setaffinity.
>>
>> For the records, it triggers after building glibc and running tests, and
>> then issuing:
>>
>>   for x in {1..2000} ; do posix/tst-affinity-static  & done
>>
>> and shows up as:
>>
>> error: Unexpected CPU 2, expected 0
>> error: Unexpected CPU 2, expected 0
>> error: Unexpected CPU 2, expected 0
>> error: Unexpected CPU 2, expected 0
>> error: Unexpected CPU 138, expected 0
>> error: Unexpected CPU 138, expected 0
>> error: Unexpected CPU 138, expected 0
>> error: Unexpected CPU 138, expected 0
> 
> As far as I can tell, the glibc reproducer no longer shows the issue
> with this patch applied.
> 
> Tested-By: Florian Weimer <fweimer@redhat.com>

Thanks a lot Florian for your thorough review and testing !

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
