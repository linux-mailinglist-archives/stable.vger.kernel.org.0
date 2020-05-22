Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A411D1DE1A5
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 10:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgEVIS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 04:18:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:55020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbgEVIS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 04:18:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BF3A7BE73;
        Fri, 22 May 2020 08:18:27 +0000 (UTC)
Subject: Re: [PATCH] xen/events: avoid NULL pointer dereference in
 evtchn_from_irq()
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20200319071428.12115-1-jgross@suse.com>
 <30719c35-6de7-d400-7bb8-cff4570f8971@oracle.com>
 <20200521184602.GP98582@mail-itl>
 <c36de3eb-c0ad-45e1-e08b-cb7d86d197f6@oracle.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <5839ff92-92e4-667a-8ed1-f5f9f3453299@suse.com>
Date:   Fri, 22 May 2020 10:18:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c36de3eb-c0ad-45e1-e08b-cb7d86d197f6@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.05.20 23:57, Boris Ostrovsky wrote:
> On 5/21/20 2:46 PM, Marek Marczykowski-Górecki wrote:
>> On Thu, May 21, 2020 at 01:22:03PM -0400, Boris Ostrovsky wrote:
>>> On 3/19/20 3:14 AM, Juergen Gross wrote:
>>>> There have been reports of races in evtchn_from_irq() where the info
>>>> pointer has been NULL.
>>>>
>>>> Avoid that case by testing info before dereferencing it.
>>>>
>>>> In order to avoid accessing a just freed info structure do the kfree()
>>>> via kfree_rcu().
>>>
>>> Looks like noone ever responded to this.
>>>
>>>
>>> This change looks fine but is there a background on the problem? I
>>> looked in the archives and didn't find the relevant discussion.
>> Here is the original bug report:
>> https://xen.markmail.org/thread/44apwkwzeme4uavo
>>
> 
> 
> Thanks. Do we know what the race is? Is it because an event is being
> delivered from a dying guest who is in the process of tearing down event
> channels?

Missing synchronization between event channel (de-)allocation and
handling.

I have a patch sitting here, just didn't have the time to do some proper
testing and sending it out.


Juergen
