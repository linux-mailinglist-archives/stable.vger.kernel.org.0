Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C348F4D2F73
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 13:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiCIMvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 07:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiCIMvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 07:51:16 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88910522F1;
        Wed,  9 Mar 2022 04:50:17 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F0261FB;
        Wed,  9 Mar 2022 04:50:17 -0800 (PST)
Received: from [192.168.1.10] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BF143FA4D;
        Wed,  9 Mar 2022 04:50:14 -0800 (PST)
Message-ID: <7ac47c67-0b5e-5caa-20bb-a0100a0cb78f@arm.com>
Date:   Wed, 9 Mar 2022 13:50:07 +0100
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
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
 <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
 <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com> <YieXQD7uG0+R5QBq@fedora>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
In-Reply-To: <YieXQD7uG0+R5QBq@fedora>
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

On 08/03/2022 18:49, Darren Hart wrote:
> On Tue, Mar 08, 2022 at 05:03:07PM +0100, Dietmar Eggemann wrote:
>> On 08/03/2022 12:04, Vincent Guittot wrote:
>>> On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:

[...]

>> IMHO, if core_mask weight is 1, MC will be removed/degenerated anyway.
>>
>> This is what I get on my Ampere Altra (I guess I don't have the ACPI
>> changes which would let to a CLS sched domain):
>>
>> # cat /sys/kernel/debug/sched/domains/cpu0/domain*/name
>> DIE
>> NUMA
>> root@oss-altra01:~# zcat /proc/config.gz | grep SCHED_CLUSTER
>> CONFIG_SCHED_CLUSTER=y
> 
> I'd like to follow up on this. Would you share your dmidecode BIOS
> Information section?

# dmidecode -t 0
# dmidecode 3.2
Getting SMBIOS data from sysfs.
SMBIOS 3.2.0 present.

Handle 0x0000, DMI type 0, 26 bytes
BIOS Information
	Vendor: Ampere(TM)
	Version: 0.9.20200724
	Release Date: 2020/07/24
	ROM Size: 7680 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		Boot from CD is supported
		Selectable boot is supported
		ACPI is supported
		UEFI is supported
	BIOS Revision: 5.15
	Firmware Revision: 0.6

> Which kernel version?

v5.17-rc5

[...]

>>> I would not say that I'm happy because this solution skews the core
>>> cpu mask in order to abuse the scheduler so that it will remove a
>>> wrong but useless level when it will build its domains.
>>> But this works so as long as the maintainer are happy, I'm fine
> 
> I did explore the other options and they added considerably more
> complexity without much benefit in my view. I prefer this option which
> maintains the cpu_topology as described by the platform, and maps it
> into something that suits the current scheduler abstraction. I agree
> there is more work to be done here and intend to continue with it.
> 
>> I do not have any better idea than this tweak here either in case the
>> platform can't provide a cleaner setup.
> 
> I'd argue The platform is describing itself accurately in ACPI PPTT
> terms. The topology doesn't fit nicely within the kernel abstractions
> today. This is an area where I hope to continue to improve things going
> forward.

I see. And I assume lying about SCU/LLC boundaries in ACPI is not an
option since it messes up /sys/devices/system/cpu/cpu0/cache/index*/.

[...]
