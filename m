Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6423DD734
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbhHBNfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:35:21 -0400
Received: from smtpout1.mo3005.mail-out.ovh.net ([79.137.123.220]:52239 "EHLO
        smtpout1.3005.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233719AbhHBNfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:35:21 -0400
X-Greylist: delayed 2166 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2021 09:35:21 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.146.59])
        by mo3005.mail-out.ovh.net (Postfix) with ESMTPS id EC3A413B0E9;
        Mon,  2 Aug 2021 12:59:02 +0000 (UTC)
Received: from kaod.org (37.59.142.97) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Mon, 2 Aug
 2021 14:59:02 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-97G0024d37b098-f782-465d-969d-06a754345f4b,
                    BF3CD4E3C57DE48CDC00B7E56D076D590FF73035) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.66.77.115
Subject: Re: [PATCH] powerpc/xive: Do not skip CPU-less nodes when creating
 the IPIs
To:     Michael Ellerman <mpe@ellerman.id.au>,
        <linuxppc-dev@lists.ozlabs.org>
CC:     Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        <stable@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Laurent Vivier <lvivier@redhat.com>,
        David Gibson <dgibson@redhat.com>,
        Kairui Song <kasong@redhat.com>
References: <20210629131542.743888-1-clg@kaod.org>
 <87a6m0l5by.fsf@mpe.ellerman.id.au>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <1facebb0-3ac1-18cc-e473-46120a5ef4ad@kaod.org>
Date:   Mon, 2 Aug 2021 14:59:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87a6m0l5by.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.97]
X-ClientProxiedBy: DAG1EX1.mxp5.local (172.16.2.1) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 5022168f-0f47-41e8-8cfd-12b1bc3af52d
X-Ovh-Tracer-Id: 17011784644205841260
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvtddriedvgdehgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeehuedtheeghfdvhedtueelteegvdefueektdefiefhffffieduuddtudfhgfevtdenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdeljeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepmhhpvgesvghllhgvrhhmrghnrdhiugdrrghu
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/2/21 8:37 AM, Michael Ellerman wrote:
> Cédric Le Goater <clg@kaod.org> writes:
>> On PowerVM, CPU-less nodes can be populated with hot-plugged CPUs at
>> runtime. Today, the IPI is not created for such nodes, and hot-plugged
>> CPUs use a bogus IPI, which leads to soft lockups.
>>
>> We could create the node IPI on demand but it is a bit complex because
>> this code would be called under bringup_up() and some IRQ locking is
>> being done. The simplest solution is to create the IPIs for all nodes
>> at startup.
>>
>> Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
>> Cc: stable@vger.kernel.org # v5.13
>> Reported-by: Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
>> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> Signed-off-by: Cédric Le Goater <clg@kaod.org>
>> ---
>>
>> This patch breaks old versions of irqbalance (<= v1.4). Possible nodes
>> are collected from /sys/devices/system/node/ but CPU-less nodes are
>> not listed there. When interrupts are scanned, the link representing
>> the node structure is NULL and segfault occurs.
> 
> Breaking userspace is usually frowned upon, even if it is irqbalance.
>
> If CPU-less nodes appeared in /sys/devices/system/node would that fix
> it? Could we do that or is that not possible for other reasons?
> 
>> Version 1.7 seems immune. 
> 
> Which was released in August 2020.
> 
> Looks like some distros still ship 1.6, I take it you're not sure if
> that is broken or not.

I did a bisect on irqbalance and the "bad" commit was introduced between 
version 1.7 and version 1.8 :

  commit 31dea01f3a47 ("Also fetch node info for non-PCI devices") 
  https://github.com/Irqbalance/irqbalance/commit/31dea01f3a47aa6374560638486879e5129f9c94

which was backported on RHEL 8 in RPM irqbalance-1.4.0-6.el8.

Any distro using irqbalance <= 1.7 without the patch above is fine. 

Since irqbalance handled cleanly irqs referencing offline nodes before 
this patch, I am inclined to think that the irqbalance fix is incomplete. 
Unfortunately, the commit log lacks some context on the non-PCI devices. 

Thanks,

C. 
