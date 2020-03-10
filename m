Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEE218012F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCJPHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:07:25 -0400
Received: from mail.itouring.de ([188.40.134.68]:51370 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgCJPHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 11:07:25 -0400
Received: from tux.applied-asynchrony.com (p5B07E2B3.dip0.t-ipconnect.de [91.7.226.179])
        by mail.itouring.de (Postfix) with ESMTPSA id 86B074161A07;
        Tue, 10 Mar 2020 16:07:23 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 32E34F01606;
        Tue, 10 Mar 2020 16:07:23 +0100 (CET)
Subject: Re: [PATCH 5.4 000/168] 5.4.25-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux@roeck-us.net, shuah@kernel.org,
        stable@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>
References: <20200310123635.322799692@linuxfoundation.org>
 <d97347d3-4eea-f5e1-8a3c-a12410e9ad5f@applied-asynchrony.com>
 <20200310143527.GB3376131@kroah.com>
 <daf30758-fe28-0709-7908-91bb99ee5e39@applied-asynchrony.com>
 <20200310150018.GA3422873@kroah.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <1371d06f-306b-7e42-3871-fb1a0d7936bf@applied-asynchrony.com>
Date:   Tue, 10 Mar 2020 16:07:23 +0100
MIME-Version: 1.0
In-Reply-To: <20200310150018.GA3422873@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 4:00 PM, Greg Kroah-Hartman wrote:
> On Tue, Mar 10, 2020 at 03:51:01PM +0100, Holger Hoffstätte wrote:
>> On 3/10/20 3:35 PM, Greg Kroah-Hartman wrote:
>>> On Tue, Mar 10, 2020 at 03:02:37PM +0100, Holger Hoffstätte wrote:
>>>> On 3/10/20 1:37 PM, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 5.4.25 release.
>>>>
>>>> This fails to compile due to broken patch 001/168:
>>>> "block, bfq: get a ref to a group when adding it to a service tree":
>>>>
>>>> ..
>>>> block/bfq-wf2q.c: In function 'bfq_get_entity':
>>>> ./include/linux/kernel.h:994:51: error: 'struct bfq_group' has no member named 'entity'
>>>> ..
>>>>
>>>> The calls to bfq_get_entity::bfqg_and_blkg_get and bfq_forget_entity::bfqg_and_blkg_put
>>>> in bfq-wf2q.c need to be wrapped in #ifdef CONFIG_BFQ_GROUP_IOSCHED, otherwise
>>>> the build will fail when CONFIG_BFQ_GROUP_IOSCHED is not enabled.
>>>> This horribly error-prone #ifdef mess was finally removed in upstream commit
>>>> 4d8340d0d4d9. For 5.4 we'll either need that as well or add them back.
>>>
>>> Ick, that's a mess.
>>>
>>> I'll go drop that patch now, odd that it passed my build tests...
>>
>> Uh, please no? It fixes a rather nasty UAF when cgroups are in use.
>> Please just add the other upstream commit as well, I confirmed it applies
>> cleanly and fixes the problem.
> 
> I didn't get that from your email at all, sorry.
> 
> So, what commits, and in what order, should be applied to 5.4.y at the
> moment to resolve this issue?

Just add upstream 4d8340d0d4d9 and it should work. Order shouldn't matter
(built for me either way) unless you want to follow upstream, in which case
it should come before "get a ref to a group..". Easy :)

-h
