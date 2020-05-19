Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B2F1D98EC
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 16:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgESOGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 10:06:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31747 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728832AbgESOGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 10:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589897203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVan/lIqM1KxVmRz7U7tBP5JZcD+A76sVahm1WJ7cGI=;
        b=MGXARKHT2qR1iyZpeQ4oYR+4XZ3al24IKsg5lapy1qsmPTvZs+qc0UARaOHDBIZtBbNkig
        Rk465nZrOtIkFTtDiK2Ij2N13J/WPFvtmUuSzakGfb6KTpX43QjPNyVYTy3i+PonGL7LQ6
        URpq+xDDkAcV2LCoLxlkk1gkMPpK6Vs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-iFlIJQaKNUaQZ-ia_sVxng-1; Tue, 19 May 2020 10:06:42 -0400
X-MC-Unique: iFlIJQaKNUaQZ-ia_sVxng-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2311E464;
        Tue, 19 May 2020 14:06:41 +0000 (UTC)
Received: from starship (unknown [10.35.207.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92A966155F;
        Tue, 19 May 2020 14:06:38 +0000 (UTC)
Message-ID: <043b0ee715413433e9ece0cb05f75e3c5f8799ce.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: only do L1TF workaround on affected processors
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Tue, 19 May 2020 17:06:37 +0300
In-Reply-To: <d1f27df9-2f25-cce1-918e-6471b56db801@amd.com>
References: <20200519095008.1212-1-pbonzini@redhat.com>
         <adb8a844689f1569875b1e6574ce7db4962e611c.camel@redhat.com>
         <d1f27df9-2f25-cce1-918e-6471b56db801@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-05-19 at 08:56 -0500, Tom Lendacky wrote:
> On 5/19/20 5:59 AM, Maxim Levitsky wrote:
> > On Tue, 2020-05-19 at 05:50 -0400, Paolo Bonzini wrote:
> > > KVM stores the gfn in MMIO SPTEs as a caching optimization.  These are split
> > > in two parts, as in "[high 11111 low]", to thwart any attempt to use these bits
> > > in an L1TF attack.  This works as long as there are 5 free bits between
> > > MAXPHYADDR and bit 50 (inclusive), leaving bit 51 free so that the MMIO
> > > access triggers a reserved-bit-set page fault.
> > 
> > Most of machines I used have MAXPHYADDR=39, however on larger server machines,
> > isn't MAXPHYADDR already something like 48, thus not allowing enought space for these bits?
> > This is the case for my machine as well.
> > 
> > In this case, if I understand correctly, the MAXPHYADDR value reported to the guest can
> > be reduced to accomodate for these bits, is that true?
> > 
> > 
> > > The bit positions however were computed wrongly for AMD processors that have
> > > encryption support.  In this case, x86_phys_bits is reduced (for example
> > > from 48 to 43, to account for the C bit at position 47 and four bits used
> > > internally to store the SEV ASID and other stuff) while x86_cache_bits in
> > > would remain set to 48, and _all_ bits between the reduced MAXPHYADDR
> > > and bit 51 are set.
> > 
> > If I understand correctly this is done by the host kernel. I haven't had memory encryption
> > enabled when I did these tests.
> > 
> > 
> > FYI, later on, I did some digging about SME and SEV on my machine (3970X), and found out that memory encryption (SME) does actually work,
> > except that it makes AMD's own amdgpu driver panic on boot and according to google this is a very well known issue.
> > This is why I always thought that it wasn't supported.
> > 
> > I tested this issue while SME is enabled with efifb and it seems that its state (enabled/disabled) doesn't affect this bug,
> > which suggest me that a buggy bios always reports that memory encrypiton is enabled in that msr, or something
> > like that. I haven't yet studied this area well enought to be sure.
> 
> If the SMEE MSR bit (bit 23 of 0xc0010010) is enabled then the overall 
> hardware encryption feature is active which means the encryption bit is 
> available and active, regardless of whether the OS supports it or not, and 
> the physical address space is reduced.

This means if I understand correctly that when I don't enable the encryption in
the kernel, then basically kernel just doesn't set the 'C' bit in the physical address,
but it can if it wanted to.
This makes sense, thanks for the explanation.


> 
> Some BIOSes provide an option to disable/turn off the SMEE bit, but not all.
> 
My BIOS indeed doesn't have any option in regard to this.


> > SEV on the other hand is not active because the system doesn't seem to have PSP firmware loaded,
> > and only have CCP active (I added some printks to the ccp/psp driver and it shows that PSP reports 0 capability which indicates that it is not there)
> > It is reported as supported in CPUID (even SEV-ES).
> 
> Correct, the hardware supports the feature, but you need the SEV firmware, 
> too. The SEV firmware is only available on EPYC processors.
That what I figured out. Thanks!

BTW, any ideas on why AMDGPU driver crashes with SME enabled?
Is it still not supported or this is is a corner case which I can file a bug report about?

I have Radeon Pro WX 4100, and I am using mainline branch of the kernel.

I don't yet have means to capture the kernel panic it is getting,
since I don't yet have a serial port on this machine, and I am looking
into getting one trying my luck with usb3 debug cable.

I used to get the kernel panic reports via 'ramoops' mechanism which relies on
storing the kernel log in a fixed area in the ram, and on the fact that BIOS doesn't really
clear the memory on reboot, but since memory is encrypted it doesn't work.

Best regards,
	Maxim Levitsky

