Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6B4264ACA
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 19:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgIJRM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 13:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgIJRMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 13:12:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B811120C09;
        Thu, 10 Sep 2020 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599757971;
        bh=PUBpYQj0CxzLrTEIPelTfB5FM7z8aFgQE0RamhRKdGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EKml8Bp/9LmNdjeMi1rCzFyiQzegEeGNrtKf/vFqrtC10kEjnhTIxRe8hB5Fle0t6
         7uDN6w35OLtDdE66DdKTs0hbqzABuv0/xOPYY4y/aU5Q6aO8CQMGTJLFJhZB+mbNPD
         xJtDa0Yi6FsRPugbXzyqZtdbxk2aEPJyCbwfgXWE=
Date:   Thu, 10 Sep 2020 19:12:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     sashal@kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        peterx@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu,
        vsirnapalli@vmware.com
Subject: Re: [PATCH v2 v4.14.y 0/3] vfio: Fix for CVE-2020-12888
Message-ID: <20200910171258.GC1621093@kroah.com>
References: <1599591263-46520-1-git-send-email-akaher@vmware.com>
 <1599591263-46520-4-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599591263-46520-4-git-send-email-akaher@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 09, 2020 at 12:24:23AM +0530, Ajay Kaher wrote:
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
> Diff from v1:
> Fixed build break problem.
> 
> [PATCH v2 v4.14.y 1/3]:
> Backporting of upsream commit 41311242221e:
> vfio/type1: Support faulting PFNMAP vmas
>         
> [PATCH v2 v4.14.y 2/3]:
> Backporting of upsream commit 11c4cd07ba11:
> vfio-pci: Fault mmaps to enable vma tracking
>         
> [PATCH v2 v4.14.y 3/3]:
> Backporting of upsream commit abafbc551fdd:
> vfio-pci: Invalidate mmaps and block MMIO access on disabled memory

This worked better, now all queued up, thanks!

greg k-h
