Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE5C316C91
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 18:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhBJR0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 12:26:24 -0500
Received: from mail.efficios.com ([167.114.26.124]:53538 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbhBJR0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 12:26:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id AC6072FDF94;
        Wed, 10 Feb 2021 12:25:31 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 4s4obU5j8meL; Wed, 10 Feb 2021 12:25:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 4C35B2FDE2F;
        Wed, 10 Feb 2021 12:25:31 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 4C35B2FDE2F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1612977931;
        bh=io6jcxeNM2lxF9S8jKCyDAOxOk5s55Q5wZFoRXhWX2M=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=I0JoMuxVGV57WxJbVNVIP/VnIRusdKWAsEgVbtYTcuaEPb3Edr0Y95IqaefFc9vvF
         CmXjB8qBwF1mTH+27NImXBoscDcoRIMTT3rmUvt6J1dc8DCVK4ZRNUFKEcN20bo/2Q
         UX3+xGPkvAOYPxJJqJgySUMVjAtnHTO9xwIMDyj1RJew7l+UzZrOHNmwuRHSbQsgbI
         U7cAvbTXLMfTyB2AQ00gWQKY0QNUV6Nv8hRJ3KiV5QxpTBuh8x+fN/3rAAMHFPpcnz
         GSjo4oIdz3HD32YRRrl8VYMrGOfH9vpd17Ps+8vm6uZTwuDz0fplwhtjPeCYIrPiuW
         VFW5IH7XYglkA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VMpGiQn7Tg1X; Wed, 10 Feb 2021 12:25:31 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 3DBEA2FDEAE;
        Wed, 10 Feb 2021 12:25:31 -0500 (EST)
Date:   Wed, 10 Feb 2021 12:25:31 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rostedt <rostedt@goodmis.org>,
        Michael Jeanson <mjeanson@efficios.com>
Message-ID: <2071967108.15704.1612977931149.JavaMail.zimbra@efficios.com>
In-Reply-To: <YCQTQyRlCsJHXzIQ@kroah.com>
References: <537870616.15400.1612973059419.JavaMail.zimbra@efficios.com> <YCQTQyRlCsJHXzIQ@kroah.com>
Subject: Re: [stable 4.4, 4.9, 4.14, 4.19 LTS] Missing fix "memcg: fix a
 crash in wb_workfn when a device disappears"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3996 (ZimbraWebClient - FF85 (Linux)/8.8.15_GA_3996)
Thread-Topic: Missing fix "memcg: fix a crash in wb_workfn when a device disappears"
Thread-Index: Ttc552H2ElXvNAOr94i9faJfXx6q2g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Feb 10, 2021, at 12:09 PM, Greg Kroah-Hartman gregkh@linuxfoundation.org wrote:

> On Wed, Feb 10, 2021 at 11:04:19AM -0500, Mathieu Desnoyers wrote:
>> Hi,
>> 
>> While reconciling the lttng-modules writeback instrumentation with its
>> counterpart
>> within the upstream Linux kernel, I notice that the following commit introduced
>> in
>> 5.6 is present in stable branches 5.4 and 5.5, but is missing from LTS stable
>> branches
>> for 4.4, 4.9, 4.14, 4.19:
>> 
>> commit 68f23b89067fdf187763e75a56087550624fdbee
>> ("memcg: fix a crash in wb_workfn when a device disappears")
>> 
>> Considering that this fix was CC'd to the stable mailing list, is there any
>> reason why it has not been integrated into those LTS branches ?
> 
> Yes, it doesn't apply at all.  If you think this is needed, I will
> gladly take backported and tested patches.
> 
> But why do you think this is needed in older kernels?  Have you hit
> this in real-life?

No, I have not hit this in real-life. Looking at the patch commit message,
the conditions needed to trigger this issue are very specific: memcg must
be enabled, and a device must be hotremoved while writeback is going on,
with writeback tracing active.

AFAIU memcg was present in those LTS releases and devices can be hotremoved
(please correct me if I'm wrong here), so all the preconditions appear to be
met.

Considering that I don't have the setup ready to reproduce this issue, I will
have to defer to the original patch authors for a properly tested backport,
if it happens to be relevant at all.

I just though reporting what appears to be a missing fix in LTS branches
would be the right thing to do.

Thanks,

Mathieu

> 
> thanks,
> 
> greg k-h

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
