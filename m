Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B957316DC5
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 19:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhBJSDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 13:03:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhBJSBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 13:01:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 171A864E6F;
        Wed, 10 Feb 2021 18:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612980027;
        bh=Zk7OqLQIa9Im9RmLh/iXB3llwfY7isgcOwpCyCEnmTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RHhw7Ixm9JO/VgrXA5FpKhv2NNlOfhg2fKBr0WGqmhQM1acwzEJgsl/ErZLllTftO
         NozAltpMUklKOGdpyBaLNL79Z1uPPl5n7nKzfpEVFy8J8Py7QHjX0FuXGHolAwAnP6
         JMEhTob/3Tweom/dFQOHCH1iCXSLraw23EIayN6MtI9w5hpTzrAI2G1cA1ssus2Tn+
         LOxE3T/mFOb9E8YGYgpFV/SVnH/m3uNL8DoHi1hFlX2mG48+A+VKsI+A0lsIylSMp2
         7XqZ6yJaxvAY99GbHvaAF0P73glsX6b6SJE0rA//ivheIHRU/pwXSNMWStzW5/UdfA
         kHIQyZNacCHkQ==
Date:   Wed, 10 Feb 2021 13:00:25 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rostedt <rostedt@goodmis.org>,
        Michael Jeanson <mjeanson@efficios.com>
Subject: Re: [stable 4.4, 4.9, 4.14, 4.19 LTS] Missing fix "memcg: fix a
 crash in wb_workfn when a device disappears"
Message-ID: <20210210180025.GE4035784@sasha-vm>
References: <537870616.15400.1612973059419.JavaMail.zimbra@efficios.com>
 <YCQTQyRlCsJHXzIQ@kroah.com>
 <2071967108.15704.1612977931149.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2071967108.15704.1612977931149.JavaMail.zimbra@efficios.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 12:25:31PM -0500, Mathieu Desnoyers wrote:
>----- On Feb 10, 2021, at 12:09 PM, Greg Kroah-Hartman gregkh@linuxfoundation.org wrote:
>
>> On Wed, Feb 10, 2021 at 11:04:19AM -0500, Mathieu Desnoyers wrote:
>>> Hi,
>>>
>>> While reconciling the lttng-modules writeback instrumentation with its
>>> counterpart
>>> within the upstream Linux kernel, I notice that the following commit introduced
>>> in
>>> 5.6 is present in stable branches 5.4 and 5.5, but is missing from LTS stable
>>> branches
>>> for 4.4, 4.9, 4.14, 4.19:
>>>
>>> commit 68f23b89067fdf187763e75a56087550624fdbee
>>> ("memcg: fix a crash in wb_workfn when a device disappears")
>>>
>>> Considering that this fix was CC'd to the stable mailing list, is there any
>>> reason why it has not been integrated into those LTS branches ?
>>
>> Yes, it doesn't apply at all.  If you think this is needed, I will
>> gladly take backported and tested patches.
>>
>> But why do you think this is needed in older kernels?  Have you hit
>> this in real-life?
>
>No, I have not hit this in real-life. Looking at the patch commit message,
>the conditions needed to trigger this issue are very specific: memcg must
>be enabled, and a device must be hotremoved while writeback is going on,
>with writeback tracing active.
>
>AFAIU memcg was present in those LTS releases and devices can be hotremoved
>(please correct me if I'm wrong here), so all the preconditions appear to be
>met.
>
>Considering that I don't have the setup ready to reproduce this issue, I will
>have to defer to the original patch authors for a properly tested backport,
>if it happens to be relevant at all.
>
>I just though reporting what appears to be a missing fix in LTS branches
>would be the right thing to do.

Looks like it doesn't apply due to churn with tracepoints, I think it's
fixable. Let me try and get something for <=4.19.

-- 
Thanks,
Sasha
