Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE01D2620D7
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 22:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgIHUQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 16:16:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730068AbgIHPKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599577783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FZa+iT6uJluJlrs0f7SlUYi8Jd20qJSgs2ucWw1RdNE=;
        b=KNM4TtzKm2ZvhqJZIscJeevndAlkwg7sKMf73shwY4ZYBnGHV9iphOgR+SObdC6fmkfwpW
        5BUI7H1aC/8cfqXtl73fr0FLSJYwFny4FLL4M/iYHtKv2dUGyEfeOLF0lDBy9xdy5FRLAx
        b9iU4nbF8NQWtaZJl/iSclGvAVVSEIE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-COb6RyaJPwm5J6x8ijO5ng-1; Tue, 08 Sep 2020 10:29:17 -0400
X-MC-Unique: COb6RyaJPwm5J6x8ijO5ng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D9021005E5C;
        Tue,  8 Sep 2020 14:29:15 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3928560C84;
        Tue,  8 Sep 2020 14:29:05 +0000 (UTC)
Date:   Tue, 8 Sep 2020 08:29:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <cohuck@redhat.com>, <peterx@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <vsirnapalli@vmware.com>
Subject: Re: [PATCH v4.14.y 0/3] vfio: Fix for CVE-2020-12888
Message-ID: <20200908082904.045ff744@w520.home>
In-Reply-To: <1599509828-23596-4-git-send-email-akaher@vmware.com>
References: <1599509828-23596-1-git-send-email-akaher@vmware.com>
        <1599509828-23596-4-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Sep 2020 01:47:08 +0530
Ajay Kaher <akaher@vmware.com> wrote:

> CVE-2020-12888 Kernel: vfio: access to disabled MMIO space of some
> devices may lead to DoS scenario
>     
> The VFIO modules allow users (guest VMs) to enable or disable access to the
> devices' MMIO memory address spaces. If a user attempts to access (read/write)
> the devices' MMIO address space when it is disabled, some h/w devices issue an
> interrupt to the CPU to indicate a fatal error condition, crashing the system.
> This flaw allows a guest user or process to crash the host system resulting in
> a denial of service.
>     
> Patch 1/ is to force the user fault if PFNMAP vma might be DMA mapped
> before user access.
>     
> Patch 2/ setup a vm_ops handler to support dynamic faulting instead of calling
> remap_pfn_range(). Also provides a list of vmas actively mapping the area which
> can later use to invalidate those mappings.
>     
> Patch 3/ block the user from accessing memory spaces which is disabled by using
> new vma list support to zap, or invalidate, those memory mappings in order to
> force them to be faulted back in on access.
>     
> Upstreamed patches link:
> https://lore.kernel.org/kvm/158871401328.15589.17598154478222071285.stgit@gimli.home
>         
> [PATCH v4.14.y 1/3]:
> Backporting of upsream commit 41311242221e:
> vfio/type1: Support faulting PFNMAP vmas
>         
> [PATCH v4.14.y 2/3]:
> Backporting of upsream commit 11c4cd07ba11:
> vfio-pci: Fault mmaps to enable vma tracking
>         
> [PATCH v4.14.y 3/3]:
> Backporting of upsream commit abafbc551fdd:
> vfio-pci: Invalidate mmaps and block MMIO access on disabled memory
> 

I'd recommend also including the following or else SR-IOV VFs will be
broken for DPDK:

commit ebfa440ce38b7e2e04c3124aa89c8a9f4094cf21
Author: Alex Williamson <alex.williamson@redhat.com>
Date:   Thu Jun 25 11:04:23 2020 -0600

    vfio/pci: Fix SR-IOV VF handling with MMIO blocking
    
    SR-IOV VFs do not implement the memory enable bit of the command
    register, therefore this bit is not set in config space after
    pci_enable_device().  This leads to an unintended difference
    between PF and VF in hand-off state to the user.  We can correct
    this by setting the initial value of the memory enable bit in our
    virtualized config space.  There's really no need however to
    ever fault a user on a VF though as this would only indicate an
    error in the user's management of the enable bit, versus a PF
    where the same access could trigger hardware faults.
    
    Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
    Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

