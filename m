Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4F4181925
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgCKNGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbgCKNGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 09:06:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7570220873;
        Wed, 11 Mar 2020 13:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583931995;
        bh=PlaS74TA52+HyUfV2WJZ2U19MoadXqctbqu4D164gSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TeWdulkJWMeVeaaEZGETJ9tKpfFNWxoEk6v0ywm9ujxOMwzAYeGDhTcA3XLySgwfL
         akd7JVKlT7J59GDxrR5A/Xch7VLjquPNM57glysIry3yTkq+Cna3IsKyqc4IjdMpb3
         xnNuXNI0w1ToAtKSsuA6q14naYS6uMTTkD1MTxcg=
Date:   Wed, 11 Mar 2020 14:06:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4.14 057/126] KVM: SVM: Override default MMIO mask if
 memory encryption is enabled
Message-ID: <20200311130628.GA3833342@kroah.com>
References: <20200310124203.704193207@linuxfoundation.org>
 <20200310124207.819562318@linuxfoundation.org>
 <20200310181952.GF9305@linux.intel.com>
 <220a78d4-0e46-a321-49cd-5d1c5827aef0@amd.com>
 <0bab862b-0780-38c3-0c60-b078d61613de@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bab862b-0780-38c3-0c60-b078d61613de@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 03:59:25PM -0500, Tom Lendacky wrote:
> On 3/10/20 1:42 PM, Tom Lendacky wrote:
> > On 3/10/20 1:19 PM, Sean Christopherson wrote:
> >> Has this been tested on the stable kernels?  There's a recent bug report[*]
> >> that suggests the 4.19 backport of this patch may be causing issues.
> > 
> > I missed this went the stable patches went by...  when backported to the
> > older version of kvm_mmu_set_mmio_spte_mask() in the stable kernels (4.14
> > and 4.19), the call should have been:
> > 
> > kvm_mmu_set_mmio_spte_mask(mask, mask) and not:
> > 
> > kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);
> > 
> > The call in the original upstream patch was:
> > 
> > kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
> 
> Greg,
> 
> I should have asked in the earlier email...  how do you want to address this?

I will fix this up now, thanks for pointing out what I got wrong...

greg k-h
