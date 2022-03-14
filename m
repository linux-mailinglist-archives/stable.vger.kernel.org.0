Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDE84D7EC5
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 10:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiCNJja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 05:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiCNJj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 05:39:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54A30DEF6;
        Mon, 14 Mar 2022 02:38:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B371BED1;
        Mon, 14 Mar 2022 02:38:15 -0700 (PDT)
Received: from [192.168.178.6] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA2B63F99C;
        Mon, 14 Mar 2022 02:38:12 -0700 (PDT)
Message-ID: <35344252-5284-b08e-fec7-6dc99476b4b0@arm.com>
Date:   Mon, 14 Mar 2022 10:37:21 +0100
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
 <7ac47c67-0b5e-5caa-20bb-a0100a0cb78f@arm.com> <YijxUAuufpBKLtwy@fedora>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
In-Reply-To: <YijxUAuufpBKLtwy@fedora>
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

On 09/03/2022 19:26, Darren Hart wrote:
> On Wed, Mar 09, 2022 at 01:50:07PM +0100, Dietmar Eggemann wrote:
>> On 08/03/2022 18:49, Darren Hart wrote:
>>> On Tue, Mar 08, 2022 at 05:03:07PM +0100, Dietmar Eggemann wrote:
>>>> On 08/03/2022 12:04, Vincent Guittot wrote:
>>>>> On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:
>>
>> [...]
>>
>>>> IMHO, if core_mask weight is 1, MC will be removed/degenerated anyway.
>>>>
>>>> This is what I get on my Ampere Altra (I guess I don't have the ACPI
>>>> changes which would let to a CLS sched domain):
>>>>
>>>> # cat /sys/kernel/debug/sched/domains/cpu0/domain*/name
>>>> DIE
>>>> NUMA
>>>> root@oss-altra01:~# zcat /proc/config.gz | grep SCHED_CLUSTER
>>>> CONFIG_SCHED_CLUSTER=y
>>>
>>> I'd like to follow up on this. Would you share your dmidecode BIOS
>>> Information section?
>>
>> # dmidecode -t 0
>> # dmidecode 3.2
>> Getting SMBIOS data from sysfs.
>> SMBIOS 3.2.0 present.
>>
>> Handle 0x0000, DMI type 0, 26 bytes
>> BIOS Information
>> 	Vendor: Ampere(TM)
>> 	Version: 0.9.20200724
>> 	Release Date: 2020/07/24
>> 	ROM Size: 7680 kB
>> 	Characteristics:
>> 		PCI is supported
>> 		BIOS is upgradeable
>> 		Boot from CD is supported
>> 		Selectable boot is supported
>> 		ACPI is supported
>> 		UEFI is supported
>> 	BIOS Revision: 5.15
>> 	Firmware Revision: 0.6
>>
> 
> Thank you, I'm following internally and will get with you.

Looks like in my PPTT, the `Processor Hierarchy Nodes` which represents
cluster nodes have no valid `ACPI Processor ID`.

Example for CPU0:

cpu_node-:

[1B9Ch 7068   1]           Subtable Type : 00 [Processor Hierarchy Node]
[1B9Dh 7069   1]                       Length : 1C
[1B9Eh 7070   2]                     Reserved : 0000
[1BA0h 7072   4]        Flags (decoded below) : 0000001A
                            Physical package : 0
                     ACPI Processor ID valid : 1           <-- valid !!!
                       Processor is a thread : 0
                              Node is a leaf : 1
                    Identical Implementation : 1
[1BA4h 7076   4]                       Parent : 00001B88  <-- parent !!!
[1BA8h 7080   4]            ACPI Processor ID : 00001200 [1BACh 7084
4]      Private Resource Number : 00000002
[1BB0h 7088   4]             Private Resource : 00001B58
[1BB4h 7092   4]             Private Resource : 00001B70

cluster_node (cpu_node->parent):

[1B88h 7048   1]           Subtable Type : 00 [Processor Hierarchy Node]
[1B89h 7049   1]                       Length : 14
[1B8Ah 7050   2]                     Reserved : 0000
[1B8Ch 7052   4]        Flags (decoded below) : 00000010
                            Physical package : 0
                     ACPI Processor ID valid : 0       <-- not valid !!!
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                       Processor is a thread : 0
                              Node is a leaf : 0
                    Identical Implementation : 1
[1B90h 7056   4]                       Parent : 000001C8
[1B94h 7060   4]            ACPI Processor ID : 00000000
[1B98h 7064   4]      Private Resource Number : 00000000

The code which checks this is:

int find_acpi_cpu_topology_cluster(unsigned int cpu)
{
    ....
    if (cluster_node->flags & ACPI_PPTT_ACPI_PROCESSOR_ID_VALID)
        retval = cluster_node->acpi_processor_id;
    else
       retval = ACPI_PTR_DIFF(cluster_node, table);

The else patch just returns distinct values for each CPU, so there is no
sub-grouping of CPUs which can lead to a CLS SD.
