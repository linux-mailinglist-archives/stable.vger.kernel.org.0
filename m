Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138A048CEFE
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 00:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbiALXOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 18:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbiALXOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 18:14:37 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B85C061748
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 15:14:33 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id l8so6818201plt.6
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 15:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d0jCBobpVlBNvfREglfkw9YIUT/N0ds0mEhgutOEthA=;
        b=n6Jxs6LoIzS+LRw2wZy+Sc+Am+Ey0wbLg2vXnruhPw8xCIDgqyAyRn3pZbeNeZ2SvO
         p7B+gQMPcATJIFB5RGgQbjvqAqXyxsr54/VXtIxGQyBT/paqUQFIf7L3ZiSZMEPHDXsD
         XxDFFK6mJTOfjCriQUU4awpFu580O0fyI39e/XH9wvYqnl4DqkagsJ+qcHOe+Uj08FvG
         hVj/142yKdUswoc84398SfOY1T7gOHTwI+2GMFp4JYx39VoXZrxkpnL8racb8H+i6Btf
         OFFTr5tsmwvK/E+5YOcbVBgF2w9CCubvlPp4vC63A2SHyOx5Zf+YY8c+tGGigTdhwd/r
         ve/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d0jCBobpVlBNvfREglfkw9YIUT/N0ds0mEhgutOEthA=;
        b=ZGm1zS2D3xHKi51Zl/DuhdemCaqICkOg0BAYwimdBiTzrlHSipH2Ld9Be4yk+9J7i7
         89UyB86iwnDlCkhpOc71As3o2Zo08t8O9W9mPP9ThjYNWxiIgMx4HL/NmmetuvSarC0N
         JC3g4puqF8iPssSUYyVOoOIus+sBHJKoQeG0OENrT2RKGi+iroUlMKVW4g5nxq0bwXLg
         KpCZTmbInz2Zln3b+zGafJPG0VU5EK2+B3e5RkK3LnZc191OT2i3QTvnlhP3QrDoi+X1
         6R9vPvfvVcRZ2oc0r7Lj5TwpIkzoeIbfyKkWRPlg+mVAmEwcEyfU7yn9Zsmo11Uw7zGZ
         6ALg==
X-Gm-Message-State: AOAM5324WvLBBl5DV20LtZi25XyHfwC3qZKyT0GaPpjnn0y9XYyL7SEn
        EYWsgKJcHRpnmkrZ7naeDdJ1LQ==
X-Google-Smtp-Source: ABdhPJwbLerEnHvBEXjR+pRHR7npc25cvNWskbT2LviKUgAOfZkdQMObjbgnEDsUiFmQb4/W0gaKsg==
X-Received: by 2002:a17:902:cec5:b0:14a:5aa5:6a76 with SMTP id d5-20020a170902cec500b0014a5aa56a76mr1636127plg.51.1642029272798;
        Wed, 12 Jan 2022 15:14:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r13sm590859pga.29.2022.01.12.15.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 15:14:32 -0800 (PST)
Date:   Wed, 12 Jan 2022 23:14:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Fix write-protection of PTs mapped by
 the TDP MMU
Message-ID: <Yd9g1KIoNwUPtFrt@google.com>
References: <20220112215801.3502286-1-dmatlack@google.com>
 <20220112215801.3502286-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112215801.3502286-2-dmatlack@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022, David Matlack wrote:
> When the TDP MMU is write-protection GFNs for page table protection (as
> opposed to for dirty logging, or due to the HVA not being writable), it
> checks if the SPTE is already write-protected and if so skips modifying
> the SPTE and the TLB flush.
> 
> This behavior is incorrect because the SPTE may be write-protected for
> dirty logging. This implies that the SPTE could be locklessly be made
> writable on the next write access, and that vCPUs could still be running
> with writable SPTEs cached in their TLB.
> 
> Fix this by unconditionally setting the SPTE and only skipping the TLB
> flush if the SPTE was already marked !MMU-writable or !Host-writable,
> which guarantees the SPTE cannot be locklessly be made writable and no
> vCPUs are running the writable SPTEs cached in their TLBs.
> 
> Technically it would be safe to skip setting the SPTE as well since:
> 
>   (a) If MMU-writable is set then Host-writable must be cleared
>       and the only way to set Host-writable is to fault the SPTE
>       back in entirely (at which point any unsynced shadow pages
>       reachable by the new SPTE will be synced and MMU-writable can
>       be safetly be set again).
> 
>   and
> 
>   (b) MMU-writable is never consulted on its own.
> 
> And in fact this is what the shadow MMU does when write-protecting guest
> page tables. However setting the SPTE unconditionally is much easier to
> reason about and does not require a huge comment explaining why it is safe.

I disagree.  I looked at the code+comment before reading the full changelog and
typed up a response saying the code should be:

		if (!is_writable_pte(iter.old_spte) &&
		    !spte_can_locklessly_be_made_writable(spte))
			break;

Then I went read the changelog and here we are :-)

I find that much more easier to grok, e.g. in plain English: "if the SPTE isn't
writable and can't be made writable, there's nothing to do".

Versus "unconditionally clear the writable bits because ???, but only flush if
the write was actually necessary", with a slightly opinionated translation :-)

And with that, you don't need to do s/spte_set/flush.  Though I would be in favor
of a separate patch to do s/spte_set/write_protected here and in the caller, to
match kvm_mmu_slot_gfn_write_protect().
