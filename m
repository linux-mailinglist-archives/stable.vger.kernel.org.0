Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B52409901
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbhIMQ1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:27:00 -0400
Received: from smtpout1.mo529.mail-out.ovh.net ([178.32.125.2]:44051 "EHLO
        smtpout1.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229795AbhIMQ1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 12:27:00 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2021 12:26:59 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.146.44])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 26866BDC1B10;
        Mon, 13 Sep 2021 18:19:33 +0200 (CEST)
Received: from kaod.org (37.59.142.103) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Mon, 13 Sep
 2021 18:19:33 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-103G005f9cd1f28-1563-4076-a263-cc79d3707ab1,
                    B58C78742DCB5DC23679A7A9E2785397667D7E18) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Subject: Re: [PATCH AUTOSEL 5.14 38/99] KVM: PPC: Book3S HV: XICS: Fix mapping
 of passthrough interrupts
To:     Sasha Levin <sashal@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        <kvm-ppc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
References: <20210910001558.173296-1-sashal@kernel.org>
 <20210910001558.173296-38-sashal@kernel.org>
 <27739836-bad2-6b3f-7f40-e84663fbbf24@kaod.org> <YTy+xUtEEpln2Sq4@sashalap>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <90cd638d-62d2-8c98-cce0-4c71feee8671@kaod.org>
Date:   Mon, 13 Sep 2021 18:19:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YTy+xUtEEpln2Sq4@sashalap>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.103]
X-ClientProxiedBy: DAG2EX2.mxp5.local (172.16.2.12) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: c78f8b93-1b94-4716-88b6-cfd8e4a89938
X-Ovh-Tracer-Id: 8796937449597471526
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvtddrudegjedgleeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepjeetfeejteefhfeuveethfduffeftdelvdeghfelhfeljeehheeuieevudeggefhnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepshgrshhhrghlsehkvghrnhgvlhdrohhrgh
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/11/21 4:35 PM, Sasha Levin wrote:
> On Fri, Sep 10, 2021 at 07:48:18AM +0200, Cédric Le Goater wrote:
>> On 9/10/21 2:14 AM, Sasha Levin wrote:
>>> From: Cédric Le Goater <clg@kaod.org>
>>>
>>> [ Upstream commit 1753081f2d445f9157550692fcc4221cd3ff0958 ]
>>>
>>> PCI MSIs now live in an MSI domain but the underlying calls, which
>>> will EOI the interrupt in real mode, need an HW IRQ number mapped in
>>> the XICS IRQ domain. Grab it there.
>>>
>>> Signed-off-by: Cédric Le Goater <clg@kaod.org>
>>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>> Link: https://lore.kernel.org/r/20210701132750.1475580-31-clg@kaod.org
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>>
>> Why are we backporting this patch in stable trees ?
>>
>> It should be fine but to compile, we need a partial backport of commit
>> 51be9e51a800 ("KVM: PPC: Book3S HV: XIVE: Fix mapping of passthrough
>> interrupts") which exports irq_get_default_host().
> 
> Or, I can drop it if it makes no sense?

Yes I would. 

It makes sense only with the full patchset, the one reworking PCI MSI 
support in the PPC pSeries and PowerNV platforms.

Thanks,

C.
