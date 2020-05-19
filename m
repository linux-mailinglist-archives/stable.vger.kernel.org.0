Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35621D9323
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 11:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgESJS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 05:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgESJS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 05:18:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13C52206D4;
        Tue, 19 May 2020 09:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589879905;
        bh=SZOxCYwn1E36zdZQTDfsq61IamxmccNBhSdJ1qTjYrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lu7xxmkzrwFOEEo0n6p2VytA4vzHv1cW2KQp/K31QevBRf4XAmysev9K6tIw0P1o0
         67dxQ10Fy9qBCkRWnEjyGUdJhC/eicM7pi8Nobxag+Vx5807bK8YeMCfjfGOlu5vzI
         IHvFbqFPbZ7FmyJBCfhJwzNrJL6Q4p9OnMEjYwjg=
Date:   Tue, 19 May 2020 11:18:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Frantisek Hrbata <fhrbata@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, rhkernel-list@redhat.com,
        Andrew Jones <drjones@redhat.com>, stable@vger.kernel.org,
        Bandan Das <bsd@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RHEL 8.3 BZ 1768622 PATCH 3/3] KVM: x86: use raw clock values
 consistently
Message-ID: <20200519091822.GA4143612@kroah.com>
References: <20200518191516.165550666@fuller.cnet>
 <20200518191759.624834612@fuller.cnet>
 <20200519085852.GE20516@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519085852.GE20516@localhost.localdomain>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 10:58:52AM +0200, Frantisek Hrbata wrote:
> Hi Marcelo,
> 
> I'm marking this as superseded by pwid 303977
> 
> http://patchwork.lab.bos.redhat.com/patch/303977/
> 
> which was included in kernel-4.18.0-196.el8
> 
>     commit 9751522d92195bc64883c71e2bee8ed0fcbc5007
>     Author: Vitaly Kuznetsov <vkuznets@redhat.com>
>     Date:   Mon Apr 20 15:20:04 2020 -0400
> 
>     [x86] kvm: x86: use raw clock values consistently
> 
>     Message-id: <20200420152004.933168-1-vkuznets@redhat.com>
>     Patchwork-id: 303977
>     Patchwork-instance: patchwork
>     O-Subject: [RHEL8.3 virt PATCH v2 312/614] KVM: x86: use raw clock values consistently
>     Bugzilla: 1813987
>     RH-Acked-by: Andrew Jones <drjones@redhat.com>
>     RH-Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>     RH-Acked-by: Tony Camuso <tcamuso@redhat.com>
> 
> Note there is a difference between yours and Vitaly's patch in the
> following hunk
> 
> +@@ -1656,6 +1656,18 @@ static void update_pvclock_gtod(struct timekeeper *tk)
> 
>         write_seqcount_end(&vdata->seq);
>   }
> @@ -14,12 +16,12 @@
>  +static s64 get_kvmclock_base_ns(void)
>  +{
>  +      /* Master clock not used, so we can just use CLOCK_BOOTTIME.  */
> -+      return ktime_get_boottime_ns();
> ++      return ktime_get_boot_ns();
>  +}
>   #endif
> 
> 
> This is in !CONFIG_X86_64 path, so I'm not sure how much we care about
> this. Anyway Vitaly's patch corrects this, because
> rhel does not have upstream commit 9285ec4c8b61d4930a575081abeba2cd4f449a74

Gotta love private git repo discussions on a public mailing list :)

greg k-h
