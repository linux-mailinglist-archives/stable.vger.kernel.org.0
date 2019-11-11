Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9F7F70EE
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 10:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfKKJix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 04:38:53 -0500
Received: from proxmox-new.maurer-it.com ([212.186.127.180]:52551 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfKKJix (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 04:38:53 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Nov 2019 04:38:51 EST
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id DE1AB46945;
        Mon, 11 Nov 2019 10:32:07 +0100 (CET)
Subject: Re: [PATCH 4.19 167/211] KVM: x86: Manually calculate reserved bits
 when loading PDPTRS
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Doug Reiland <doug.reiland@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20191003154447.010950442@linuxfoundation.org>
 <20191003154525.870373223@linuxfoundation.org>
From:   Thomas Lamprecht <t.lamprecht@proxmox.com>
Message-ID: <68d02406-b9cc-2fc1-848c-5d272d9a3350@proxmox.com>
Date:   Mon, 11 Nov 2019 10:32:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:71.0) Gecko/20100101
 Thunderbird/71.0
MIME-Version: 1.0
In-Reply-To: <20191003154525.870373223@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/19 5:53 PM, Greg Kroah-Hartman wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> commit 16cfacc8085782dab8e365979356ce1ca87fd6cc upstream.
> 
> Manually generate the PDPTR reserved bit mask when explicitly loading
> PDPTRs.  The reserved bits that are being tracked by the MMU reflect the
> current paging mode, which is unlikely to be PAE paging in the vast
> majority of flows that use load_pdptrs(), e.g. CR0 and CR4 emulation,
> __set_sregs(), etc...  This can cause KVM to incorrectly signal a bad
> PDPTR, or more likely, miss a reserved bit check and subsequently fail
> a VM-Enter due to a bad VMCS.GUEST_PDPTR.
> 
> Add a one off helper to generate the reserved bits instead of sharing
> code across the MMU's calculations and the PDPTR emulation.  The PDPTR
> reserved bits are basically set in stone, and pushing a helper into
> the MMU's calculation adds unnecessary complexity without improving
> readability.
> 
> Oppurtunistically fix/update the comment for load_pdptrs().
> 
> Note, the buggy commit also introduced a deliberate functional change,
> "Also remove bit 5-6 from rsvd_bits_mask per latest SDM.", which was
> effectively (and correctly) reverted by commit cd9ae5fe47df ("KVM: x86:
> Fix page-tables reserved bits").  A bit of SDM archaeology shows that
> the SDM from late 2008 had a bug (likely a copy+paste error) where it
> listed bits 6:5 as AVL and A for PDPTEs used for 4k entries but reserved
> for 2mb entries.  I.e. the SDM contradicted itself, and bits 6:5 are and
> always have been reserved.
> 
> Fixes: 20c466b56168d ("KVM: Use rsvd_bits_mask in load_pdptrs()")
> Cc: stable@vger.kernel.org
> Cc: Nadav Amit <nadav.amit@gmail.com>
> Reported-by: Doug Reiland <doug.reiland@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/x86/kvm/x86.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -581,8 +581,14 @@ static int kvm_read_nested_guest_page(st
>  				       data, offset, len, access);
>  }
>  
> +static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
> +{
> +	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63) | rsvd_bits(5, 8) |
> +	       rsvd_bits(1, 2);
> +}
> +
>  /*
> - * Load the pae pdptrs.  Return true is they are all valid.
> + * Load the pae pdptrs.  Return 1 if they are all valid, 0 otherwise.
>   */
>  int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>  {
> @@ -601,8 +607,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, s
>  	}
>  	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
>  		if ((pdpte[i] & PT_PRESENT_MASK) &&
> -		    (pdpte[i] &
> -		     vcpu->arch.mmu.guest_rsvd_check.rsvd_bits_mask[0][2])) {
> +		    (pdpte[i] & pdptr_rsvd_bits(vcpu))) {
>  			ret = 0;
>  			goto out;
>  		}
> 
> 
> 


first off, I hope that I'm not a bit blunt to just message you all here :)

It seems that a backport of this to stable and distro kernels tickled out
some issue[0] for KVM Linux 64bit guests on older than about 8-10 year old
Intel CPUs[1].

Basically, booting this kernel as host, then running an KVM guest distro
or kernel fails it that guest kernel early in the boot phase without any
error or other log to serial console, earlyprintk.

Quickest test here, boot the booted kernel with QEMU/KVM, e.g.:
# qemu-system-x86_64 -enable-kvm -kernel /boot/vmlinuz-4.19.77 -nographic -append console=ttyS0

FYI: booting a "problematic" kernel (e.g., 4.19.77) as guest kernel while
having a good host kernel (e.g., 4.19.76) works just fine.

As this does not happen when applying it on a 5.3.7 kernel (e.g.,
Ubuntu-5.3.0-21.22 which includes this works just fine), so IMO the
questions is: what other patch is missing from the backport of this one?

I did not immediately find a fix or some related change which seemed like
the reason for above working with 5.3.7 but not with the stable 4.19.77 to
4.19.81 or Ubuntu's Disco 5.0.21 based kernel, so I started a reverse bisect
between the known-bad 5.2 and the known-good 5.3-rc1, at each step
cherry-picking this "manual calculate reserved bits when loading PDPTRS"
commit, which made the issues show up.

But I could not single out a definitive (supporting) commit for this,
albeit, as you see in the rev-bisect log[2], I had found some promising
commit, but once I only applied that one as single cherry-pick, the
"reboot looping KVM Linux guest" issue did show up again... But maybe I
also just made an error during bisecting, and came to wrong conclusions..

In a act of desperation I then tried to cherry-pick all "arch/x86/kvm"
commits, i.e., those found with:
# git log --no-merges --oneline v5.2..v5.3-rc1 -- arch/x86/kvm/
but to no avail, so there may be more than one supporting commit needed,
but that's just guessing. I think you people have surely an better idea
about what the underlying issue could be.

cheers,
Thomas

[0]: https://bugzilla.kernel.org/show_bug.cgi?id=205441
[1]: models tested as problematic are: intel core2duo E8500; Xeon E5420; so
     westmere, conroe and that stuff. AFAICT anything from about pre-2010 which
     has VMX support (i.e. is 64bit based)
[2]: git reverse bisect log:
 git bisect start '--term-new=fixed' '--term-old=broken'
 # fixed: [4d856f72c10ecb060868ed10ff1b1453943fc6c8] Linux 5.3
 git bisect fixed 4d856f72c10ecb060868ed10ff1b1453943fc6c8
 # broken: [0ecfebd2b52404ae0c54a878c872bb93363ada36] Linux 5.2
 git bisect broken 0ecfebd2b52404ae0c54a878c872bb93363ada36
 # fixed: [43c95d3694cc448fdf50bd53b7ff3a5bb4655883] Merge tag 'pinctrl-v5.3-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
 git bisect fixed 43c95d3694cc448fdf50bd53b7ff3a5bb4655883
 # broken: [8f6ccf6159aed1f04c6d179f61f6fb2691261e84] Merge tag 'clone3-v5.3' of git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux
 git bisect broken 8f6ccf6159aed1f04c6d179f61f6fb2691261e84
 # broken: [753c8d9b7d81206bb5d011b28abe829d364b028e] Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
 git bisect broken 753c8d9b7d81206bb5d011b28abe829d364b028e
 # broken: [d72619706abc4aa7e540ea882dae883cee7cc3b3] Merge tag 'tty-5.3-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
 git bisect broken d72619706abc4aa7e540ea882dae883cee7cc3b3
 # broken: [f632a8170a6b667ee4e3f552087588f0fe13c4bb] Merge tag 'driver-core-5.3-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
 git bisect broken f632a8170a6b667ee4e3f552087588f0fe13c4bb
 # fixed: [5010fe9f095414b959fd6fda63986dc90fd0c419] Merge tag 'vfs-fix-ioctl-checking-3' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux
 git bisect fixed 5010fe9f095414b959fd6fda63986dc90fd0c419
 # fixed: [a45ff5994c9cde41af627c46abb9f32beae68943] Merge tag 'kvm-arm-for-5.3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
 git bisect fixed a45ff5994c9cde41af627c46abb9f32beae68943
 # fixed: [2183f5645ae7e074ed1777f3de9a782dd23db248] KVM: VMX: Shadow VMCS primary execution controls
 git bisect fixed 2183f5645ae7e074ed1777f3de9a782dd23db248
 # fixed: [2ea72039808d50c909c2eb00eaebfaaaa743927a] kvm: nVMX: small cleanup in handle_exception
 git bisect fixed 2ea72039808d50c909c2eb00eaebfaaaa743927a
 # fixed: [fb89f4ea7feb1e605f8f405d256c56d8ad69125c] kvm: selftests: introduce aarch64_vcpu_add_default
 git bisect fixed fb89f4ea7feb1e605f8f405d256c56d8ad69125c
 # fixed: [f257d6dcda0187693407e0c2e5dab69bdab3223f] KVM: Directly return result from kvm_arch_check_processor_compat()
 git bisect fixed f257d6dcda0187693407e0c2e5dab69bdab3223f
 # fixed: [84ea3acaa01fb90861b341038998e27a5198e1a0] KVM: LAPIC: Extract adaptive tune timer advancement logic
 git bisect fixed 84ea3acaa01fb90861b341038998e27a5198e1a0
 # fixed: [f3ecb59dd49f1742b97df6ba071aaa3d031154ac] kvm: x86: Fix reserved bits related calculation errors caused by MKTME
 git bisect fixed f3ecb59dd49f1742b97df6ba071aaa3d031154ac 

