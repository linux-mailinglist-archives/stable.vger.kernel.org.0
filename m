Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5EB348D15
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 10:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCYJhi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 25 Mar 2021 05:37:38 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2739 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhCYJhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 05:37:18 -0400
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4F5fyj3RkJz682BC;
        Thu, 25 Mar 2021 17:32:29 +0800 (CST)
Received: from lhreml714-chm.china.huawei.com (10.201.108.65) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 10:37:15 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml714-chm.china.huawei.com (10.201.108.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 09:37:15 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.013; Thu, 25 Mar 2021 09:37:15 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH for-stable-5.10 2/2] KVM: arm64: Workaround firmware
 wrongly advertising GICv2-on-v3 compatibility
Thread-Topic: [PATCH for-stable-5.10 2/2] KVM: arm64: Workaround firmware
 wrongly advertising GICv2-on-v3 compatibility
Thread-Index: AQHXIVdkF/Q7jN0LS02rK142tsme1qqUcRaAgAAAZbA=
Date:   Thu, 25 Mar 2021 09:37:15 +0000
Message-ID: <3ed860eaf93c43969b7dfeb0904efb2e@huawei.com>
References: <20210325091424.26348-1-shameerali.kolothum.thodi@huawei.com>
 <20210325091424.26348-3-shameerali.kolothum.thodi@huawei.com>
 <9850fc39c1c80840ea77eba60ee5e663@kernel.org>
In-Reply-To: <9850fc39c1c80840ea77eba60ee5e663@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.26.249]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 25 March 2021 09:33
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; stable@vger.kernel.org;
> pbonzini@redhat.com; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH for-stable-5.10 2/2] KVM: arm64: Workaround firmware
> wrongly advertising GICv2-on-v3 compatibility
> 
> On 2021-03-25 09:14, Shameer Kolothum wrote:
> > From: Marc Zyngier <maz@kernel.org>
> >
> > commit 9739f6ef053f104a997165701c6e15582c4307ee upstream.
> >
> > It looks like we have broken firmware out there that wrongly
> > advertises a GICv2 compatibility interface, despite the CPUs not being
> > able to deal with it.
> >
> > To work around this, check that the CPU initialising KVM is actually
> > able to switch to MMIO instead of system registers, and use that as a
> > precondition to enable GICv2 compatibility in KVM.
> >
> > Note that the detection happens on a single CPU. If the firmware is
> > lying *and* that the CPUs are asymetric, all hope is lost anyway.
> >
> > Cc: stable@vger.kernel.org #5.10
> > Reported-by: Shameerali Kolothum Thodi
> > <shameerali.kolothum.thodi@huawei.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Message-Id: <20210305185254.3730990-8-maz@kernel.org>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> 
> Please hold on on that.
> 
> This patch causes a regression, and needs a fix that is currently queued for 5.12
> [1]. Once this hits upstream, please add the fix to the series and post it as a
> whole.

Ok. Yes, I noted that. But was thinking if this goes through first and then we can have a 
stable tag for that one, we can manage it. Anyway, will wait now.

Thanks,
Shameer
 
> Thanks,
> 
>          M.
> 
> [1] https://lore.kernel.org/r/20210323162301.2049595-1-maz@kernel.org
> --
> Jazz is not dead. It just smells funny...
