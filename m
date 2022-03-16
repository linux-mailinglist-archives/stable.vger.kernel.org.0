Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAD94DB3A1
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349582AbiCPOuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245291AbiCPOuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:50:16 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3537344E3;
        Wed, 16 Mar 2022 07:49:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 708A71476;
        Wed, 16 Mar 2022 07:49:01 -0700 (PDT)
Received: from [192.168.178.6] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A55DF3F766;
        Wed, 16 Mar 2022 07:48:58 -0700 (PDT)
Message-ID: <eb33745a-9d63-89b1-1245-9d1e0e04a169@arm.com>
Date:   Wed, 16 Mar 2022 15:48:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] topology: make core_mask include at least
 cluster_siblings
Content-Language: en-US
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org, Barry Song <21cnbao@gmail.com>
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
 <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
 <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com> <YieXQD7uG0+R5QBq@fedora>
 <7ac47c67-0b5e-5caa-20bb-a0100a0cb78f@arm.com> <YijxUAuufpBKLtwy@fedora>
 <9398d7ad-30e7-890a-3e18-c3011c383585@arm.com> <Yi9zUuroS1vHWexY@fedora>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
In-Reply-To: <Yi9zUuroS1vHWexY@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

- Barry Song <song.bao.hua@hisilicon.com> (always get undelivered mail
  returned to sender)
+ Barry Song <21cnbao@gmail.com>

On 14/03/2022 17:54, Darren Hart wrote:
> On Mon, Mar 14, 2022 at 05:35:05PM +0100, Dietmar Eggemann wrote:
>> On 09/03/2022 19:26, Darren Hart wrote:
>>> On Wed, Mar 09, 2022 at 01:50:07PM +0100, Dietmar Eggemann wrote:
>>>> On 08/03/2022 18:49, Darren Hart wrote:
>>>>> On Tue, Mar 08, 2022 at 05:03:07PM +0100, Dietmar Eggemann wrote:
>>>>>> On 08/03/2022 12:04, Vincent Guittot wrote:
>>>>>>> On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:

[...]

> Ultimately, this delivers the same result. I do think it imposes more complexity
> for everyone to address what as far as I'm aware only affect the one system.
> 
> I don't think the term "Cluster" has a clear and universally understood
> definition, so I don't think it's a given that "CLS should be sub-SD of MC". I

I agree, the term 'cluster' is overloaded but default_topology[] clearly
says (with direction up means smaller SD spans).

  #ifdef CONFIG_SCHED_CLUSTER
        { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
  #endif

  #ifdef CONFIG_SCHED_MC
        { cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
  #endif

In ACPI code we have `cluster_node = fetch_pptt_node(... ,
cpu_node->parent) but then the cache information (via
llc_id/llc_sibling) can change things which make this less easy to grasp.

> think this has been assumed, and that assumption has mostly held up, but this is
> an abstraction, and the abstraction should follow the physical topologies rather
> than the other way around in my opinion. If that's the primary motivation for
> this approach, I don't think it justifies the additional complexity.
> 
> All told, I prefer the 2 line change contained within cpu_coregroup_mask() which
> handles the one known exception with minimal impact. It's easy enough to come
> back to this to address more cases with a more complex solution if needed in the
> future - but I prefer to introduce the least amount of complexity as possible to
> address the known issues, especially if the end result is the same and the cost
> is paid by the affected systems.
> 
> Thanks,

Yeah, I can see your point. It's the smaller hack. My solution just
prevents us to manipulate the coregroup mask only to get the MC layer
degenerated by the core topology code. But people might say that's a
clever thing to do here. So I'm fine with your original solution as well.

[...]
